
findMinPowerOfTwo = (x)->
  n = 1
  loop
    r = Math.pow(2, n)
    break if r >= x
    n = n + 1
  r

findMinPowerOfBase = (base, x)->
  n = 1
  loop
    r = Math.pow(base, n)
    break if r >= x
    n = n + 1
  r


module.exports = {
  ##
  # 底2をとる最小の乗数Nを返す関数
  # example
  # findMinPowerOfTwo(512) => 512
  # findMinPowerOfTwo(400) => 512
  # findMinPowerOfTwo(511) => 512
  ofTwo: findMinPowerOfTwo

  ##
  # 底baseをとる最小の乗数Nを返す関数
  # example
  ofBase: findMinPowerOfBase
}
