evt_stream = require('event-stream')

nameDebug = ->
  return evt_stream.map (file,done)->
    console.log file
    done()


module.exports = {
  nameDebug: nameDebug
}
