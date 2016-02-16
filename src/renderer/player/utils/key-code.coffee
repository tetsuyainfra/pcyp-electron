keyset = {}

##
# windowsのvirtual keyと互換性を持たせる
# https://msdn.microsoft.com/ja-jp/library/windows/desktop/dd375731(v=vs.85).aspx
#

# 与えられた2文字からリストを作って返す関数
range = (start, end) ->
  r = []
  for n in [start.charCodeAt(0)..end.charCodeAt(0)]
    r.push(String.fromCharCode(n))
  r


# 数字、アルファベット
for s in range("0", "9").concat range("A", "Z")
  keyset["K_#{s}"] = s.charCodeAt(0)



## -- 特殊キー --
# F1(0x70=112) ~ F24(0x87=135)
for i in [1..24]
  keyset["VK_F#{i}"] = 0x6F + i

# テンキー 0(0x60)~9(0x69)
for i in [0..9]
  keyset["VK_NUMPAD#{i}"] = 0x60 + i

console.log(__filename, keyset)
module.exports = keyset
