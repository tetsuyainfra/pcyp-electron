_ = require('lodash')

require('../three_extras')
WCJS = require('wcjs-prebuilt')
{findMinPower} = require('../utils')
# こっちのほうがシンプルな構成ですねぇ
# window 1 -> 1 manager 1 -> N player 1 -> 1 render(webgl)
# どっちがええかなぁ
# window 1 -> 1 manager 1 -> N player 1 -> 1 render(webgl-texture)
#                         -> Renderer(webgl)

##
# WcjsPlayerのラッパー
#
class WcjsPlayer
  constructor: (props) ->
    props = {} unless props?
    @_vlc = WCJS.createPlayer(["-vvv"])

    {width = 320, height = 240, autoResize = false} = props
    @_initTextures(width, height)
    @setDefault(props)
    @_addEventListener()

    @updated = false
    @_vlc.onFrameSetup = @._onFrameSetup.bind(@)
    @_vlc.onFrameReady = @._onFrameReady.bind(@)


  play: (url) ->
    if url?
      console.log('settings:', @settings)
      @mute(@settings.mute)
      @_vlc.play(url)
    else
      @_vlc.play()

  stop: () ->
    @_vlc.stop()

  # trueならmute, falseならmute解除
  mute: (to_mute=true) ->
    if @_vlc.mute == false and to_mute == true
      @_vlc.toggleMute()
    else if @_vlc.mute == true and to_mute == false
      @_vlc.toggleMute()


  setDefault: (opts) ->
    if @settings?
      @settings = _.merge(@settings, opts)
    else
      @settings = _.merge({
        mute:               false
        deinterlaceEnable:  false
        deinterlaceMode:    'blend'
      }, opts)

  # インスタンスの初期化時に呼ばれる
  _initTextures: (width, height) ->
    @_resize(width, height)
    @textures = {}
    @textures.y = THREE.ImageUtils.generateDataTextureRGBA(width, height,  new THREE.Color(0xffffff), 0.5)
    @textures.y.minFilter = THREE.LinearFilter
    @textures.y.magFilter = THREE.LinearFilter
    @textures.y.needsUpdate = true

    @textures.u = THREE.ImageUtils.generateDataTextureRGBA(width, height,  new THREE.Color(0xffffff), 0.75)
    @textures.u.minFilter = THREE.LinearFilter
    @textures.u.magFilter = THREE.LinearFilter
    @textures.u.needsUpdate = true

    @textures.v = THREE.ImageUtils.generateDataTextureRGBA(width, height,  new THREE.Color(0xffffff), 0.9)
    @textures.v.minFilter = THREE.LinearFilter
    @textures.v.magFilter = THREE.LinearFilter
    @textures.v.needsUpdate = true

  _resize: (width, height) ->
    @width = width
    @height = height
    # emitする・・・

  _setupTextureYUV: (width, height, format, frame) ->
    @format = format
    if format != @_vlc.I420
      console.error("texture format not support: #{format}")
      return false

    try
      textures = {}
      w = width; h = height
      fmt    = THREE.AlphaFormat
      type   =   THREE.UnsignedByteType
      textures.y = new THREE.DataTexture(frame.subarray(0, w*h), w, h, fmt, type)
      textures.y.needsUpdate = true

      # MPEG系だと16の倍数なので2で割れるけど・・・yuvってどうなの？
      w = width/2; h = height/2
      textures.u = new THREE.DataTexture(frame.subarray(0, w*h), w, h, fmt, type)
      textures.u.needsUpdate = true

      textures.v = new THREE.DataTexture(frame.subarray(0, w*h), w, h, fmt, type)
      textures.v.needsUpdate = true
      @textures = textures
      @_resize(width, height)

      return true
    catch e
      console.error('error occuered in framesetup', e)
      return false

  _updateTextureYUV: (frame) ->
    return unless @textures?
    w = frame.width; h = frame.height
    @textures.y.image.data = frame.subarray(0, w*h)
    @textures.y.needsUpdate = true

    w = w/2; h = h/2
    @textures.u.image.data = frame.subarray(frame.uOffset, frame.uOffset + w*h)
    @textures.u.needsUpdate = true
    @textures.v.image.data = frame.subarray(frame.vOffset, frame.vOffset + w*h)
    @textures.v.needsUpdate = true

  _onFrameSetup: (w, h, format, vframe) ->
    console.log("onFrameSetup", arguments)
    result = @_setupTextureYUV(w, h, format, vframe)
    if result
      console.log('result', result, @textures)
    else
      @stop()

  _onFrameReady: (frame) ->
    if @error_occured == true
      @stop()
    switch frame.pixelFormat
      when @_vlc.I420
        @_updateTextureYUV(frame)
      else
        console.error('frame.pixelFormat is not support')
        @error_occured = true

  _addEventListener : () ->
    addListener = (evtEmitter, evtName) =>
      f = () ->
        console.log("catched #{evtName}", @, arguments)
      evtEmitter.on(evtName, f.bind(@))

    #@_vlc.events.on('Playing', @_onOpening.bind(@))

    addListener(@_vlc.events, 'MediaChanged')
    addListener(@_vlc.events, 'NothingSpecial')
    addListener(@_vlc.events, 'Opening')
    #addListener(@_vlc.events, 'Buffering')         # buffering 0~100
    addListener(@_vlc.events, 'Playing')
    addListener(@_vlc.events, 'Paused')
    addListener(@_vlc.events, 'Forward')
    addListener(@_vlc.events, 'Backward')
    addListener(@_vlc.events, 'EncounteredError')
    addListener(@_vlc.events, 'EndReached')
    addListener(@_vlc.events, 'Stopped')
    addListener(@_vlc.events, 'StateChanged')
    addListener(@_vlc.events, 'StateChangedInt')
    #addListener(@_vlc.events, 'TimeChanged')      # Integer millices?
    #addListener(@_vlc.events, 'PositionChanged')  # Position 0~1.0
    addListener(@_vlc.events, 'SeekableChanged')  # Position 0~1.0
    addListener(@_vlc.events, 'PausableChanged')  # Position 0~1.0
    addListener(@_vlc.events, 'LengthChanged')  # Position 0~1.0
    addListener(@_vlc.events, 'FrameSetup')

module.exports = WcjsPlayer


# MEMO:
# https://github.com/RSATom/WebChimera.js/wiki/JavaScript-API
