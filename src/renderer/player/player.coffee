require('./three_extras')
{ PlayerManager, WcjsPlayer }= require('./wrap-wcjs')

{ ParamParser } = require('./utils')

global.manager = new PlayerManager(dom_id: "player_container")
player = new WcjsPlayer()

global.manager.add(player)

#player.setDefault({mute: true})
#player.play("http://archive.org/download/CartoonClassics/Krazy_Kat_-_Keeping_Up_With_Krazy.mp4")

player.setDefault({mute: false})
console.log(ParamParser().url)
player.play(ParamParser().url)

global.manager.animate()
