

# ディレクトリ構造




# 開発環境@ディレクトリ構造

- src
  * __browser__  
    ブラウザプロセス用モジュール
  * __renderer__  
    レンダラプロセス用モジュール
    - main.jade メインウィンドウのエントリーポイント
    - settings.jade 設定ウィンドウのエントリーポイント
  * __styles__  
    静的ファイル
  - app.coffee  
    アプリのエントリポイント
  - default.json  
    初期設定
  - package.json  
    パッケージ情報
  - pcyp-electron_icon.ico  
    windows用アイコン
- webpack.config.coffee Webpack標準でコンパイルされる設定
    内部でwebpack.client, webpack.electronを読み込んでいる
- webpack.client.coffee レンダラープロセスで実行するプログラムのWEBPACK設定
- webpack.electron.coffee ブラウザープロセスで実行するプログラムのWEBPACK設定
- webpack.dll.config.coffee レンダラープロセスで読み込むプログラムを一つにまとめるWEBPACK設定
