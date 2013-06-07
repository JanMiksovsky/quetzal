/*
Quetzal
*/


/*
Sugar to allow quick creation of element properties.
*/


(function() {
  var QuetzalElement, Super, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Function.prototype.alias = function(propertyName, accessChain, sideEffect) {
    var processChain;

    processChain = function(obj, propertyName, accessChain, sideEffect, value) {
      var index, key, keys, result, setter, _i, _len;

      result = obj;
      keys = accessChain.split(".");
      setter = value !== void 0;
      for (index = _i = 0, _len = keys.length; _i < _len; index = ++_i) {
        key = keys[index];
        if (index === keys.length - 1 && setter) {
          result[key] = value;
          result = value;
        } else {
          result = result[key];
        }
      }
      if (setter && (sideEffect != null)) {
        sideEffect.call(obj, value);
      }
      return result;
    };
    return Object.defineProperty(this.prototype, propertyName, {
      enumerable: true,
      get: function() {
        return processChain(this, propertyName, accessChain, sideEffect);
      },
      set: function(value) {
        return processChain(this, propertyName, accessChain, sideEffect, value);
      }
    });
  };

  Function.prototype.getter = function(propertyName, get) {
    return Object.defineProperty(this.prototype, propertyName, {
      get: get,
      configurable: true,
      enumerable: true
    });
  };

  if (Function.prototype.name == null) {
    Object.defineProperty(Function.prototype, "name", {
      get: function() {
        return /function\s+([^\( ]*)/.exec(this.toString())[1];
      }
    });
  }

  Function.prototype.property = function(propertyName, sideEffect, defaultValue, converter) {
    return Object.defineProperty(this.prototype, propertyName, {
      enumerable: true,
      get: function() {
        var result;

        result = this._properties[propertyName];
        if (result === void 0) {
          return defaultValue;
        } else {
          return result;
        }
      },
      set: function(value) {
        var result;

        result = converter ? converter.call(this, value) : value;
        this._properties[propertyName] = result;
        return sideEffect != null ? sideEffect.call(this, result) : void 0;
      }
    });
  };

  Function.prototype.propertyBool = function(propertyName, sideEffect, defaultValue) {
    return this.property(propertyName, sideEffect, defaultValue, function(value) {
      return String(value) === "true";
    });
  };

  Function.prototype.setter = function(propertyName, set) {
    return Object.defineProperty(this.prototype, propertyName, {
      set: set,
      configurable: true,
      enumerable: true
    });
  };

  /*
  Base Quetzal element class
  */


  QuetzalElement = (function(_super) {
    __extends(QuetzalElement, _super);

    function QuetzalElement() {
      var element, prototype;

      prototype = this.__proto__;
      element = document.createElement("div");
      element.__proto__ = prototype;
      element.ready();
      return element;
    }

    QuetzalElement.create = function(elementClass) {
      var classFn, newElement, tag, tagForClass, _ref;

      if (elementClass instanceof Function) {
        classFn = elementClass;
      } else if (typeof elementClass === "string") {
        if (CustomElements.registry[elementClass] != null) {
          tag = elementClass;
        } else if (elementClass.indexOf("-") >= 0) {
          if (CustomElements.registry[elementClass] != null) {
            tag = elementClass;
          }
        } else if (window[elementClass] != null) {
          classFn = window[elementClass];
        } else {
          tag = elementClass;
        }
      }
      if (classFn != null) {
        tagForClass = QuetzalElement.tagForClass(classFn);
        if (CustomElements.registry[tagForClass] != null) {
          tag = tagForClass;
        }
      }
      if (tag != null) {
        newElement = document.createElement(tag);
      } else if (classFn != null) {
        newElement = new classFn();
        if (((_ref = classFn.name) != null ? _ref.length : void 0) > 0) {
          newElement.classList.add(classFn.name);
        }
      } else {
        throw "QuetzalElement.create(): invalid class";
      }
      return newElement;
    };

    QuetzalElement.prototype.parse = function(json, elementClass) {
      var child, element, fragment, keys, properties, propertyName, propertyValue, tag, target, _i, _len;

      if (json instanceof Array) {
        fragment = document.createDocumentFragment();
        for (_i = 0, _len = json.length; _i < _len; _i++) {
          child = json[_i];
          fragment.appendChild(this.parse(child, elementClass));
        }
        return fragment;
      } else if (typeof json === "string") {
        return document.createTextNode(json);
      } else {
        keys = Object.keys(json);
        if (keys.length > 0) {
          tag = keys[0];
          properties = json[tag];
          tag = tag.replace("_", "-");
          element = document.createElement(tag);
          if (tag === "super") {
            this._populateSuperElement(element, elementClass);
            target = this;
          } else {
            target = element;
          }
          if (properties instanceof Array || typeof properties === "string") {
            properties = {
              content: properties
            };
          }
          for (propertyName in properties) {
            propertyValue = properties[propertyName];
            if (propertyName === "content") {
              element.appendChild(this.parse(propertyValue, elementClass));
            } else if (typeof propertyValue === "string") {
              target[propertyName] = propertyValue;
            } else {
              target[propertyName] = this.parse(propertyValue, elementClass);
            }
          }
          return element;
        } else {
          return null;
        }
      }
    };

    QuetzalElement.prototype.ready = function() {
      var key, name, observer, value, _i, _len, _ref, _ref1, _ref2, _results,
        _this = this;

      this.$ = {};
      this._properties = {};
      observer = new MutationObserver(function() {
        var event;

        event = document.createEvent("CustomEvent");
        event.initCustomEvent("contentChanged", false, false, null);
        return _this.dispatchEvent(event);
      });
      observer.observe(this, {
        characterData: true,
        childList: true,
        subtree: true
      });
      if (this.template != null) {
        this._createShadowWithTemplate(this, this.constructor);
      }
      _ref = this.inherited;
      for (key in _ref) {
        value = _ref[key];
        this[key] = value;
      }
      _ref1 = this.attributes;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        _ref2 = _ref1[_i], name = _ref2.name, value = _ref2.value;
        _results.push(this[name] = value);
      }
      return _results;
    };

    QuetzalElement.prototype.readyCallback = function() {
      return this.ready();
    };

    QuetzalElement.tagForClass = function(classFn) {
      var lowercaseWords, regexWords, word, words;

      if (!classFn.name) {
        return null;
      }
      regexWords = /[A-Z][a-z]*/g;
      words = classFn.name.match(regexWords);
      lowercaseWords = (function() {
        var _i, _len, _results;

        _results = [];
        for (_i = 0, _len = words.length; _i < _len; _i++) {
          word = words[_i];
          _results.push(word.toLowerCase());
        }
        return _results;
      })();
      return lowercaseWords.join("-");
    };

    QuetzalElement.transmute = function(oldElement, newClass) {
      var newElement;

      newElement = QuetzalElement.create(newClass);
      while (oldElement.childNodes.length > 0) {
        newElement.appendChild(oldElement.childNodes[0]);
      }
      oldElement.parentNode.replaceChild(newElement, oldElement);
      return newElement;
    };

    QuetzalElement.prototype.transmute = function(newClass) {
      return QuetzalElement.transmute(this, newClass);
    };

    QuetzalElement.prototype._classDefiningTemplate = function(elementClass) {
      var _ref;

      while (elementClass != null) {
        if (elementClass.prototype.hasOwnProperty("template")) {
          return elementClass;
        }
        elementClass = (_ref = elementClass.__super__) != null ? _ref.constructor : void 0;
      }
      return null;
    };

    QuetzalElement.prototype._createShadowWithTemplate = function(element, elementClass) {
      var classDefiningTemplate, name, root, superElement, template, value, _i, _len, _ref, _ref1;

      root = element.webkitCreateShadowRoot();
      classDefiningTemplate = this._classDefiningTemplate(elementClass);
      if (classDefiningTemplate == null) {
        return;
      }
      template = classDefiningTemplate.prototype.template;
      if (typeof template === "string") {
        root.innerHTML = template;
        superElement = root.querySelector("super");
        if (superElement != null) {
          this._populateSuperElement(superElement, elementClass);
          _ref = superElement.attributes;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            _ref1 = _ref[_i], name = _ref1.name, value = _ref1.value;
            this[name] = value;
          }
        }
      } else {
        root.appendChild(this.parse(template, elementClass));
      }
      CustomElements.upgradeAll(root);
      return this._generateElementReferences(root);
    };

    QuetzalElement.prototype._generateElementReferences = function(subtree) {
      var subelement, subelementsWithIds, _i, _len, _ref, _results;

      if ((_ref = this.$) == null) {
        this.$ = {};
      }
      subelementsWithIds = subtree != null ? subtree.querySelectorAll("[id]") : void 0;
      if ((subelementsWithIds != null ? subelementsWithIds.length : void 0) > 0) {
        _results = [];
        for (_i = 0, _len = subelementsWithIds.length; _i < _len; _i++) {
          subelement = subelementsWithIds[_i];
          _results.push(this.$[subelement.id] = subelement);
        }
        return _results;
      }
    };

    QuetzalElement.prototype._populateSuperElement = function(element, elementClass) {
      var baseClass;

      baseClass = elementClass.__super__.constructor;
      if (baseClass == null) {
        throw "The template for " + elementClass.name + " uses <super>, but superclass can't be found.";
      }
      if (!(baseClass.prototype instanceof QuetzalElement)) {
        throw "The template for " + elementClass.name + " uses <super>, but only subclasses of QuetzalElement can do that.";
      }
      return this._createShadowWithTemplate(element, baseClass);
    };

    return QuetzalElement;

  })(HTMLDivElement);

  Super = (function(_super) {
    __extends(Super, _super);

    function Super() {
      _ref = Super.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    return Super;

  })(QuetzalElement);

  /*
  Allow registration of Quetzal element classes with browser.
  
  This defines a window global with the class' name. If the class is already
  global, this will *redefine* the global class to point to the registered class.
  When using Polymer's document.register() polyfill, the registered class is a
  munged version of the original. Assertions about instanceof should remain true
  even after munging, however.
  */


  Function.prototype.register = function() {
    var className, methodName, originalClass, originalImplementation, registeredClass, tag;

    originalClass = this;
    className = originalClass.name;
    tag = QuetzalElement.tagForClass(originalClass);
    registeredClass = document.register(tag, {
      prototype: originalClass.prototype
    });
    for (methodName in originalClass) {
      if (!__hasProp.call(originalClass, methodName)) continue;
      originalImplementation = originalClass[methodName];
      if (methodName[0] !== "_") {
        registeredClass[methodName] = originalImplementation;
      }
    }
    return window[className] = registeredClass;
  };

  QuetzalElement.register();

  Super.register();

}).call(this);
