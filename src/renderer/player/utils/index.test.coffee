#assert = require('assert')
my = require('./')

describe "renderer/player/utils", ()->

  describe "find-min-power", () ->
    it "ofTwo", () ->
      m = my.findMinPower.ofTwo
      expect(m(2)).toBe(2)
      expect(m(511)).toBe(512)
      expect(m(512)).toBe(512)
      expect(m(513)).toBe(1024)
      expect(m(320)).toBe(512)
    it "ofBase", () ->
      m = my.findMinPower.ofBase
      expect(m(2, 2)).toBe(2)
      expect(m(2, 4)).toBe(4)
      expect(m(2, 320)).toBe(512)
      expect(m(4, 2)).toBe(4)
      expect(m(4, 4)).toBe(4)
      expect(m(4, 8)).toBe(16)

  describe "ParamParser", () ->
    beforeEach( () ->
      global.window = { location:{ search: "" } }
    )
    afterEach(() ->
      delete global.window
    )
    pp = my.ParamParser
    it "can parse single query", () ->
      window.location.search = "?tdd=1"
      expect( pp() ).toEqual({tdd: '1'})

    it "can parse multi query and include URIComponent", () ->
      window.location.search = "?tdd=1&unicode=#{encodeURIComponent("d;d")}"
      expect( pp() ).toEqual({tdd: '1', unicode: 'd;d'})

  xdescribe "new test", () ->
