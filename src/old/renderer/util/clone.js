(function() {
  var clone, x, y;

  clone = function(obj) {
    var flags, key, newInstance;
    if ((obj == null) || typeof obj !== 'object') {
      return obj;
    }
    if (obj instanceof Date) {
      return new Date(obj.getTime());
    }
    if (obj instanceof RegExp) {
      flags = '';
      if (obj.global != null) {
        flags += 'g';
      }
      if (obj.ignoreCase != null) {
        flags += 'i';
      }
      if (obj.multiline != null) {
        flags += 'm';
      }
      if (obj.sticky != null) {
        flags += 'y';
      }
      return new RegExp(obj.source, flags);
    }
    newInstance = new obj.constructor();
    for (key in obj) {
      newInstance[key] = clone(obj[key]);
    }
    return newInstance;
  };

  module.exports = clone;

  if (module.name === 'main') {
    x = {
      foo: 'bar',
      bar: 'foo'
    };
    y = clone(x);
    y.foo = 'test';
    console.log(x.foo !== y.foo, x.foo, y.foo);
  }

}).call(this);

// https://coffeescript-cookbook.github.io/chapters/classes_and_objects/cloning
