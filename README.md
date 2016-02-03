## What's this?
Peercast Yellow Pageを表示するためのクライアントです。  
2016/02/03現在、OSXに対応したクライアントが無いのでOSXでも使えるクライアントを・・・と考え開発してます。
ただ、現状はWindowsで開発しているので初期設定などがWindows向けになってます。  
そのうち改善予定


## How to development
```cmd
copy npmrc_windows .npmrc
edit .npmrc       # たぶん何もする必要ないです
npm install       
bower install
gulp compile
npm start
```


## 64bit対応について
面倒なのでしばらくは32bitオンリーで開発していきます。


## ライセンスについて・・・
依存ライブラリについて調べてる途中なのでLGPL-2.1にしておきます。
後ほど変更する可能性があります。（MITにしたい）
