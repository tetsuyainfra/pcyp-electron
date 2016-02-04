THREE = require('three')

player = () ->
  query = window.location.search.substring( 1 )
  params = {}
  query.split('&').forEach( (s) ->
    element = s.split( '=' )
    key = decodeURIComponent( element[ 0 ] )
    value = decodeURIComponent( element[ 1 ] )
    if value
      params[key] = value
    else
      params[key] = true
  )
  console.log("params", params)
  wcjs = require('wcjs-prebuilt')
  window.vlcPlayer = wcjs.createPlayer(["-vvv"])
  console.log("vlcPlayer", vlcPlayer)

  renderContext = require("webgl-video-renderer").setupCanvas("canvas")
  console.log(renderContext)

  vlcPlayer.onFrameReady = (frame) ->
    renderContext.render(frame, frame.width, frame.height, frame.uOffset, frame.vOffset);

  if params.url?
    console.log("play:", params.url)
    #vlcPlayer.play("http://archive.org/download/CartoonClassics/Krazy_Kat_-_Keeping_Up_With_Krazy.mp4");
    vlcPlayer.play(params.url)

scene = null
mesh = null
camera = null
renderer = null

init = () ->
  scene = new THREE.Scene();

  camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 );
  camera.position.z = 1000;

  geometry = new THREE.BoxGeometry( 200, 200, 200 );
  material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } );

  mesh = new THREE.Mesh( geometry, material );
  scene.add( mesh );

  renderer = new THREE.WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );

  document.body.appendChild( renderer.domElement );

animate = () ->
  requestAnimationFrame( animate )

  mesh.rotation.x += 0.01
  mesh.rotation.y += 0.02

  renderer.render( scene, camera )

init()
animate()
