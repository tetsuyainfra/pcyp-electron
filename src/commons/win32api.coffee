FFI = require('ffi')
ref = require('ref')
Struct = require('ref-struct')

TEXT = (text) ->
   return new Buffer(text, 'ucs2').toString('binary')


pointStruct = Struct({
  'x': 'long',
  'y': 'long'
});

msgStruct = Struct({
  'hwnd': 'int32',
  'message': 'int32',
  'wParam': 'int32',
  'lParam': 'int32',
  'time': 'int32',
  'pt': pointStruct
});
msgStructPtr = ref.refType(msgStruct);

rectStruct = Struct({
  left:   'int32'
  top:    'int32'
  right:  'int32'
  bottom: 'int32'
})
rectStructPtr = ref.refType(rectStruct)

wndinfoStruct = Struct(
  cbSize: 'uint32'
  rcWindow: rectStruct
  rcClient: rectStruct
  dwStyle:         'uint32'
  dwExStyle:       'uint32'
  dwWindowStatus:  'uint32'
  cxWindowBorders: 'uint32'
  cyWindowBorders: 'uint32'
  atomWindowType:  'pointer'
  wCreatorVersion: 'uint16'
)
wndinfoStructPtr = ref.refType(wndinfoStruct)

user32 = new FFI.Library('user32', {
  MessageBoxW: [
    'int32', [ 'int32', 'string', 'string', 'int32' ]
  ]
  GetForegroundWindow: [
    'pointer', []
  ]
  GetWindowInfo: [
    'bool', ['pointer', wndinfoStructPtr]
  ]
})

kernel32 = new FFI.Library('kernel32', {
   GetCurrentProcessId: [
     'uint32', []
   ]
})

myMsg = new msgStruct()

module.exports =
  GetCurrentProcessId: () ->
    kernel32.GetCurrentProcessId()

  GetForegroundWindow: () ->
    user32.GetForegroundWindow()

  GetWindowInfo: (hwnd) ->
    wndinfo = new wndinfoStruct()
    if user32.GetWindowInfo(hwnd, wndinfo.ref())
      return wndinfo
    return false

  CreateMessageBox: () ->
    user32.MessageBoxW(
      0, TEXT('I am Node.JS!'), TEXT('Hello, World!'), 1
    )
