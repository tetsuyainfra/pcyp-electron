
## プログラムの目的
本プログラムはPeerCastを快適に利用するためのソフトウェアであり、
いついかなるときでも、自由で快適な視聴環境を提供できるよう努力する．
また、外部のサイトや人物に悪影響を及ぼさないよう十分に配慮して開発・配布する．

## 特徴
本プログラムはElectronをベースに開発されており、次の機能が実装される．
- メイン機能：Yellow Pageブラウザ(YPブラウザ)
- サブ機能：内部プレイヤ(ストリーミングの再生)(内部プレイヤ)
必要であれば外部プログラムをビューワーに指定することも可能である．


## プログラムの構造
ElectronはNodeによって拡張されたWebブラウザであり、リッチなデスクトップアプリケーションが
開発できる環境である。  
その内部ではメインプロセス(旧称ブラウザプロセス？)とレンダラープロセスの二種類のプロセスが動作しており、メインプロセスは常に1つだけ、レンダラープロセスはウィンドウの数だけ存在する。
プロセスが分かれているため、データの同期はIPC通信を用いて行う．
また、プロセスが分かれているため、各ウィンドウがクラッシュしたときその他ウィンドウに影響を与えない(基本的には)．

さて、近年の高速インターネット回線の普及により、PeerCastを使って複数のストリーミングを
再生することも少なくない。
本プログラムではブラウザとプレイヤー機能を内蔵するが、別々のウィンドウで動作させることにする．

また、メインプロセスは設定の保存先とIPC通信のハブと考え、
可能な限り処理をレンダラープロセス内で完結させるようにする．


## メインプロセスとレンダラープロセスの関係
-
-
-
http://dev.chromium.org/developers/design-documents/multi-process-architecture

## 構造
```
<App>
  <Headder>
  <Contents>
</App>
```

## Fluxパターンを維持した画面実装
基本的な考えとしてウィンドウひとつ一つで閉じたFluxドメインと考え、
メインウィンドウ(メインプロセス)がウィンドウ間のメッセージを仲介させる。
極力JavaScriptで処理を行いipc通信は最低限にする(ipc遅いはず・・・)


![Alt text](http://g.gravizo.com/g?
  digraph G {
    graph [compound=true];
    newrank = true;
    subgraph cluster1 {
      label = "main window";
      size ="4,4";
      A1 [shape=box, label=Action];
      D1 [shape=box, label=Dispatcher];
      S1 [shape=box, label=Store];
      V1 [shape=box, label=View];
      A1 -> D1 -> S1 -> V1;
    }
    subgraph cluster0 {
      label = "browser process";
      size = "4,4";
      View [label="Warap View"]
      Action -> Dispatcher -> Store -> View;
    }
    subgraph cluster9 {
      label = "internet";
      size = "4,4";
      WebAPI [shape=box style=lined];
    }
    Dispatcher ->WebAPI;
    WebAPI -> Dispatcher;
    subgraph cluster2 {
      label = "setting window";
      size ="4,4";
      A2 [shape=box, label=Action];
      D2 [shape=box, label=Dispatcher];
      S2 [shape=box, label=Store];
      V2 [shape=box, label=View];
      A2 -> D2 -> S2 -> V2;
    }
    View -> V1 [lhead=cluster1, constraint=false];
    View -> V2 [lhead=cluster2, constraint=false];
  }
)
<!-- constraintでランク付けの可否設定に利用しない -->

# 参考
- [gravizo](http://gravizo.com/)
- [Graphviz チュートリアル](http://homepage3.nifty.com/kaku-chan/graphviz/)
