Stats = require('stats.js')
{ KeyCode } = require('../utils')
{ EventEmitter } = require('events')

##
# 外部変数

###
setSize    <-- 外部からの要求操作
_resizing  <-- Window操作
_resized   <-- Canvasリサイズ後の操作
###


###
Aspect比の考え方
WindowWidth : WindowHeight
TextureWidth: TextureHeight
Width:Height                = MovieAspectRate

textureサイズは常に1:1にする？ -> windowSize計算



###

##
# Playerを管理するクラス
#
class PlayerManager extends EventEmitter
  constructor: (props={}) ->
    super()
    {
      @width = 320,
      @height = 240,
      @dom_id = "player"
    } = props
    @container = document.getElementById(@dom_id)
    @renderer = new THREE.WebGLRenderer({canvas: @container, antialias: false, alpha: true});
    @players = []
    @stats =  new Stats()
    @count = 0
    @resize_delay = 100
    @initWindowEvent()
    @initMouseEvent()
    @initKeyBoardEvent()
    @initRenderer()
    console.log('PlayerManager()', @)

  ## 管理するPlayerを追加
  add: (player) ->
    @players.push(player)

  ## windowサイズの変更
  setSize: (width, height) ->
    console.log "setSize(#{width}, #{height})"
    win = require('electron').remote.getCurrentWindow()
    win.setContentSize(width+10, height+10)

  ## windowがリサイズされたときに呼ばれる関数
  _resized: () ->
    p = @container.parentElement
    @width = p.clientWidth; @height = p.clientHeight
    # renderer
    @renderer.setSize(@width, @height)
    # cam
    # @camera.left  = -@width/2.0
    # @camera.right =  @width/2.0
    # @camera.top   =  @height/2.0
    # @camera.bottom= -@height/2.0
    # @camera.updateProjectionMatrix()
    dar = @width/@height
    if @players[0]?
      fW = @players[0].width; fH = @players[0].height
      far = fW / fH
      console.log('dar', dar)
      if dar < far
        # 表示画面は縦長
        #console.log('dar/far', dar/far)
        @mesh.scale.set(1, dar/far, 1)
      else
        # 表示画面は横長
        #console.log('far/dar', far/dar)
        @mesh.scale.set(far/dar, 1, 1)

      #console.log "_resized(#{@width}, #{@height})"
    delete @_resize_handle

  ## windowがフルスクリーンになった後に呼ばれる関数
  _fullscreened: () ->
    # borderを消すのが遅れることがあるので、fullscreen後に再度呼ぶ
    @_resized()
    return true


  initWindowEvent: () ->
    @on 'resized', @._resized
    # 適当に間引いてくれる setTimeoutの方が良いかも
    window.addEventListener('resize', (e)=>
      if @_resize_handle?
        console.log('handle', @_resize_handle)
        clearImmediate(@_resize_handle)
        #clearTimeout(@_resize_handle)
      @_resize_handle = setImmediate(() => @.emit('resized'))
      # @_resize_handle = setTimeout( () =>
      #   @.emit('resized')
      # , 100)
    ,false)
    document.addEventListener('webkitfullscreenchange', (e) =>
      @_fullscreened()
    )

  initMouseEvent: () ->
    # console.log 'initMouseEvent'
    # Mouseカーソル制御
    e = @container
    dragging   = false
    drag_start = null
    e.addEventListener('mousedown', (evt) ->
      #console.log('MouseDown:', evt.x, evt.y, evt, drag_start);
      dragging = true;
      drag_start = require('electron').screen.getCursorScreenPoint()
    , false)
    e.addEventListener('mouseup', (evt)->
      #console.log('MouseUp:', evt.x, evt.y);
      dragging = false;
    , false)
    e.addEventListener('mousemove', (evt) ->
      if dragging
        new_pos = require('electron').screen.getCursorScreenPoint()
        dx = new_pos.x - drag_start.x
        dy = new_pos.y - drag_start.y
        win = require('electron').remote.getCurrentWindow()
        [x, y] = win.getPosition()
        win.setPosition(x+dx, y+dy)
        drag_start = new_pos
        evt.preventDefault()
    , false)
    e.addEventListener('mouseover', (evt) ->
      #console.log('MouseOver:', evt.x, evt.y)
      dragging = false;
    , false)
    e.addEventListener('mouseenter', (evt) ->
      #console.log('MouseEnter:', evt.x, evt.y)
      dragging = false;
    , false)
    e.addEventListener('mouseout', (evt) ->
      #console.log('MouseOut:', evt.x, evt.y)
      dragging = false;
    , false)

    e.addEventListener('dblclick', (evt) ->
      #console.log('DoubleClick')
      requestFullScreen()
    , false)

  #
  initKeyBoardEvent: () ->
    #e = @container
    document.addEventListener('keydown', (evt) =>
      #console.log('keydown:', evt, evt.which, evt.keyCode)
      key = evt.keyCode || evt.which
      switch key
        when KeyCode.K_0
          @setSize(320, 240)
        when KeyCode.K_1 # 1
          @setSize(640, 480)
        when KeyCode.K_2 # 1
          @setSize(800, 600)
        when KeyCode.K_Q # 1
          @players[0].stop()
        when KeyCode.K_P # 1
          @players[0].play()
        else
          #console.log('default')
    , false)

  #
  initRenderer: () ->
    # console.log 'initRenderer'
    @renderer.setClearColor( new THREE.Color(0x00ffff), 0.3) #背景色
    @scene = new THREE.Scene();

    #@camera = new THREE.OrthographicCamera( @width/-2.0, @width/2.0, @height/2.0, -@height/2.0, 1, 1000 )
    @camera = new THREE.OrthographicCamera( -0.5, 0.5, 0.5, -0.5, 1, 1000)
    #@camera.up.set(0,1,0)
    @camera.position.set(0,0,1000)
    #@camera.lookAt({x:0, y:0, z:0})

    @camera.updateProjectionMatrix()
    #console.log('camera: ', @camera)

    #@geometry = new THREE.BoxGeometry( 1, 1, 200 )
    #@geometry = new THREE.PlaneGeometry( 100, 1, 1, 1 )
    scale = 1
    aspect = 4/3
    scale = scale * aspect
    @geometry = new THREE.PlaneGeometry( 1, 1)
    # @geometry.vertices[0].z = 75
    # @geometry.vertices[1].z = 25
    # @geometry.vertices[2].z = 50
    # console.log('vert:', @geometry.vertices)
    # console.log('faces:', @geometry.faces)

    @texture = THREE.ImageUtils.generateDataTexture(320, 240,  new THREE.Color(0.5,0.25,0.75))

    @uniforms = {
        u_resolution: { type: "v2", value: new THREE.Vector2(320, 240) }
        u_texture:     { type: "t", value: @texture }
        u_texY:    { type: "t", value: @texture }
        u_texU:    { type: "t", value: @texture }
        u_texV:    { type: "t", value: @texture }
    }

    @material = new THREE.ShaderMaterial( {
        #wireframe: true,
        uniforms: @uniforms,
        vertexShader: document.getElementById( 'vertexShader' ).textContent,
        fragmentShader: document.getElementById( 'fragmentShader' ).textContent
    } );


    @mesh = new THREE.Mesh( @geometry, @material );
    @mesh.matrixAutoUpdate = true

    @scene.add( @mesh );

    # for Stats
    @stats.setMode(0)
    @stats.domElement.style.position = 'absolute';
    @stats.domElement.style.right = '0px';
    @stats.domElement.style.top = '0px';
    @container.parentElement.appendChild(@stats.domElement)

    @_resized()

  animate: ()->
    requestAnimationFrame(@animate.bind(this))

    @stats.begin()

    @count = 0 if @count > 1.0

    textures = @players[0].textures
    if @texture.uuid != textures.y.uuid or @texture.version != textures.y.version
      @texture                   = textures.y
      @uniforms.u_texture.value  = textures.y

      @uniforms.u_texY.value = textures.y
      @uniforms.u_texU.value = textures.u
      @uniforms.u_texV.value = textures.v
      # aspect ration setting
      # dW = @width; dH = @height
      # dar = @width/@height
      # console.log "display(#{dW}, #{dH}) : #{dar}"
      #
      # fW = @players[0].width; fH = @players[0].height
      # far = fW / fH
      # console.log "frame(#{fW}, #{fH}) : #{far}"
      # console.log('dar, far', dar, far)
      # if dar < 1.0
      #   # 表示画面は縦長
      #   # darの比率になっているピクセル比を1:1にする
      #   #@mesh.scale.set(1/dar, 1, 1)
      #
      #   # 1:1の表示になった画面を元動画の比率にする
      #   #@mesh.scale.set(1/dar*far, 1, 1)
      #
      #   # 大きさを横幅ベースに変える
      #   #@mesh.scale.set(dar/dar*far, dar, 1)
      #   console.log('dar/far', dar/far)
      #   @mesh.scale.set(1, dar/far, 1)
      # else
      #   # 表示画面は横長
      #   console.log('表示画面は横長')
      #   console.log('far/dar', far/dar)
      #   #@mesh.scale.set(1/dar, 1, 1)
      #   #@mesh.scale.set(1/dar*far, 1, 1)
      #   # width, height
      #   @mesh.scale.set(far/dar, 1, 1)
      # 同じ値なら何もしない

      #@mesh.scale.set()

    #console.log(@mesh.scale)
    #@mesh.scale.set(0.5, 1, 0)
    #@mesh.rotation.x += 0.02
    #@mesh.rotation.y += 0.02

    @renderer.clear()
    @renderer.render(@scene, @camera)

    @count += 0.004

    @stats.end()


module.exports = PlayerManager


# playerサイズの変更は非表示domを重ねる方法でいく？
