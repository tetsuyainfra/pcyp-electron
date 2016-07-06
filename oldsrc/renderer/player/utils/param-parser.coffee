


module.exports = () ->
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
  params



  #console.log(window.location)
