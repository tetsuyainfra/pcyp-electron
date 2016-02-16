## What's this?
Peercast Yellow Pageを表示するためのクライアントです。  
2016/02/03現在、OSXに対応したクライアントが無いのでOSXでも使えるクライアントを・・・と考え開発してます。
ただ、現状はWindowsで開発しているので初期設定などがWindows向けになってます。  
そのうち改善予定


## 動作イメージ
![起動直後](https://raw.githubusercontent.com/tetsuyainfra/pcyp-electron/master/doc/images/pcyp-electron-startup.png)

## How to development on win32
```cmd
copy npmrc_windows .npmrc
edit .npmrc       # たぶん何もする必要ないです
npm install       
bower install
gulp compile
npm start
```


## How to scrap and build
```cmd
# one console
gulp watch

# another console
gulp connect
```
Note: src内のファイルを書き換えたら自動でコンパイルします。
その後、必要に応じてelectronの再起動・ブラウザ画面のリロードを行います。


## 64bit対応について
面倒なのでしばらくは32bitオンリーで開発していきます。


## ソースコード
基本的にはCoffeeScriptで書きます。そのうちTypeScriptに移行します。


## テスト
- 単体テストはNOブラウザで動作
- 結合テストは・・・どうしよう？


## ライセンスについて・・・
依存ライブラリについて調べてる途中なのでVLCのライセンスであるLGPL-2.1にしておきます。
後ほど変更する可能性があります。（可能ならばMITにしたい）

## TODO
- 内臓プレイヤー完成させる
- NativeModule対応
　- packagingでffiをどうする？

## 既知のバグ(という名の仕様)
- ドラッグアンドドロップでウィンドウを早く動かすとウィンドウ追従が外れる
- ウィンドウを最大化するとHTML,body要素のCSS:height,widthプロパティが4pxされる
  - https://github.com/atom/electron/issues/2498

## 仕様ライブラリなど(予定含む)
- React / Flux
- WebChemera.js (の予定)
- Three.js
