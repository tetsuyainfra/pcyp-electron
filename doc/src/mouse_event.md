

## Player Window における Mouse の Hook方法
メインプロセス側でWndProcをHookして操作をブラウザプロセス側に伝える
   getNativeWindowHandle()はバグってらっしゃる(pull request待ち)

```coffee
WM_LBUTTONUP = 0x0202
win.hookWindowMessage( WM_LBUTTONUP, (w_param, l_param) ->
  x = l_param.readInt16LE(0) #
  y = l_param.readInt16LE(2) #
  console.log('x,y:', x, y)
)
```
