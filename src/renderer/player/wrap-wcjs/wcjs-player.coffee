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
    @updated = false
    @_vlc.onFrameSetup = @._onFrameSetup.bind(@)
    @_vlc.onFrameReady = @._onFrameReady.bind(@)

  play: (url) ->
    @_vlc.play(url)

  stop: () ->
    @_vlc.stop()

  setDefault: (opts) ->
    {@mute} = opts

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
    @size =
      width: width
      height: height
    # emitする・・・

  _setupTextureYUV: (width, height, format, frame) ->
    @_resize(width, height)

    @format = format
    if format != @_vlc.I420
      console.error("texture format not support: #{format}")
      return false

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
    #@textures.v.minFilter = THREE.LinearFilter
    #@textures.v.magFilter = THREE.LinearFilter
    #textures.v.unpackAlignment = 1
    textures.v.needsUpdate = true
    @textures = textures

    return true

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
    @_vlc.audio.mute = @mute
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

module.exports = WcjsPlayer
