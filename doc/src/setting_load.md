

## 設定ファイルの読み込み順
ヒットした時点で読み込みを中断する.
もしdefault.configファイルがなければどうする？
- app.getPath('exe') / pcyp.config      
  // 実行してるアプリのパス
- app.getPath('userData')/ pcyp.config
  // -> C:\Users\ユーザー名\AppData\Roaming\pcyp-electron\user.config
- app.getPath('exe') / default.config
  // 初期設定ファイル → アプリ内に格納するか？


## 設定ファイルの内容
```
{
  config_version: "xx.xx",  # 設定ファイルのバージョン
  peercast: {
    wake_up_peca: true,
    port: 7144,
    host: "localhost"
  },
  player: {
    use_inner_player: true,
    user_players: [
      {
        is_enable:  true,
        ext: "wmv",
        player_path: "",
        command    : ""
      },
      {
        is_enable: true,
        ext: "flv",
        player_path: "",
        command    : ""
      }
    ]

  },
  favorite: {
  }
}
```
