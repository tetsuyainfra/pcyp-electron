

# チャンネル情報を3種類に分類
A. 通常のチャンネル  ID: ABCD EFGH IKJL MNOP  -1 < viewer < N
B. 帯域不足         ID: 0000 0000 0000 0000  viewer < ?
C. お知らせ         ID: 0000 0000 0000 0000  viewer < -1, broadcast_time: 0:00

まずは A, Bについて実装する
チャンネル情報の集合X から 部分集合Cを次の条件で取り除く
ID == '0000...' and broadcast_time == '0:00'
