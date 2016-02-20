require('./three_extras')
{ PlayerManager, WcjsPlayer }= require('./wrap-wcjs')

{ PeerCast, ParamParser } = require('./utils')

global.manager = new PlayerManager(dom_id: "player_container")
global.player = new WcjsPlayer()

global.manager.add(player)

#player.setDefault({mute: true})
#player.play("file://localhost/c:/work/sample_1440x1080.mp4")
#player.play("file://localhost/c:/work/sample_720x480.mp4")
#player.play("file://localhost/c:/work/sample_720x480_deinterlace.mp4")
#player.play("file://localhost/c:/work/sample_720x480_deinterlace.mp4")
#player.play("file://localhost/c:/work/sample_1920x1080.avi")

#player.setDefault({mute: true})
#player.play("http://archive.org/download/CartoonClassics/Krazy_Kat_-_Keeping_Up_With_Krazy.mp4")

# player.setDefault({mute: false})
# console.log(ParamParser().url)
# player.play(ParamParser().url)

global.manager.animate()
#video/x-ms-asf
global.PeerCast = PeerCast
global.PeerCast.getUrlAsync( ParamParser().url, (stream_url) ->
  player.setDefault({mute: true})
  player.play(stream_url)
)
#global.peca.setPlayUrl( ParamParser().url )
