
# 構造
```
<App>
  <Headder>
  <Contents>
</App>
```

# Fluxパターンを維持した画面実装
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
