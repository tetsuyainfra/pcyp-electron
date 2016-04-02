cp932Decoder = new TextDecoder("shift_jis", {fatal: true})
utf8Decoder = new TextDecoder("utf-8", {fatal: true})

HTTP_RE = /^http(s)?:\/\/([\w-]\.)*([\w-]+):([\d]+)?(\/[\w\d-./?%&=]+)*/m
MMS_RE = /^mms:\/\/([\w-]\.)*([\w-]+)(:[\d]+)?(\/[\w\d-./?%&=]+)*/m

getUrlPromise = (url) ->
  return new Promise((resolve, reject) ->
    req = new XMLHttpRequest()
    req.open('GET', url)
    req.responseType = 'arraybuffer'
    req.onload = () ->
      if req.status == 200
        resolve(req.response)
      else
        reject(Error(req.statusText))
    req.onerror = () ->
      reject(Error('Netowrk Error'))
    req.overrideMimeType('text/xml; charset=x-user-defined')
    req.send()
  )



class PeerCast
  constructor: (props={}) ->
    {@host = "localhost"} = props

  # class func
  @getUrlAsync: (url, callback) ->
    getUrlPromise(url).then( (res) ->
      try
        text = cp932Decoder.decode(res)
      catch e
        try
          console.warning('response is not cp932 text')
          text = utf8Decoder.decode(res)
        catch
          throw new Error('cant decode response', res)
      #parser = new DOMParser()
      return text
    ).then((decoded_text) ->
      console.debug 'decoded_text:', decoded_text
      # txtの場合
      ret = decoded_text.match(HTTP_RE)
      if ret?
        return ret[0]

      # asxの場合
      parser = new DOMParser()
      dom = parser.parseFromString(decoded_text, "application/xml")
      refs = dom.getElementsByTagName('Ref')
      idx = 0
      while (elm = refs.item(idx))
        mms_url = elm.getAttribute("href")
        idx += 1
      return mms_url
      #ret = mms_url.match(MMS_RE)[1..]
      #ret = "http://" + ret.join('')
      #return ret
    ).then((stream_url) ->
      console.log "connecting to #{stream_url}"
      callback(stream_url)
    ).catch((err) ->
      console.error('error in getPlayUrlAsync', err)
    )


  setPlayUrl: (url) ->
    xhr = new XMLHttpRequest()
    xhr.open('GET', url, true)
    xhr.responseType = 'arraybuffer'
    xhr.onreadystatechange = () ->
      console.log 'xhr', xhr
      console.log 'xhr.getAllResponseHeaders()', xhr.getAllResponseHeaders()
      console.log 'state', xhr.readyState, xhr.status
      if xhr.readyState == 4 && xhr.status == 200
        console.log 'response', xhr.response
        decoder = new TextDecoder("shift_jis")
        text = decoder.decode(xhr.response)
        console.log 'decode:', text
        parser = new DOMParser()
        console.log 'parsed', parser.parseFromString(text, "application/xml")
    xhr.overrideMimeType('text/xml; charset=x-user-defined')
    xhr.send(null)



# module.exports = {
#   GetStreamUrl: () ->
#     "http://localhost:7144/"
#   PeerCast: PeerCast
# }

module.exports = PeerCast
