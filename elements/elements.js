/*
Quetzal
*/


/*
Sugar to allow quick creation of element properties.
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
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

  Function.prototype.property = function(propertyName, sideEffect) {
    return Object.defineProperty(this.prototype, propertyName, {
      enumerable: true,
      get: function() {
        return this._properties[propertyName];
      },
      set: function(value) {
        this._properties[propertyName] = value;
        return sideEffect != null ? sideEffect.call(this, value) : void 0;
      }
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


  window.QuetzalElement = (function(_super) {
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

    QuetzalElement.parse = function(json, elementClass) {
      var child, element, fragment, keys, properties, propertyName, propertyValue, tag, _i, _len;

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
          element = tag === "super" ? this._createSuperInstance(elementClass) : document.createElement(tag);
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
              element[propertyName] = propertyValue;
            } else {
              element[propertyName] = this.parse(propertyValue, elementClass);
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
        this._createShadow(this.template);
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

    QuetzalElement.prototype._createShadow = function(template) {
      var classDefiningTemplate, elementClass, name, root, subelement, superElement, superInstance, value, _i, _j, _len, _len1, _ref, _ref1, _ref2, _results;

      root = this.webkitCreateShadowRoot();
      elementClass = this.constructor;
      classDefiningTemplate = this._classDefiningTemplate(elementClass);
      if (typeof this.template === "string") {
        root.innerHTML = this.template;
        CustomElements.upgradeAll(root);
        superElement = root.querySelector("super");
        if (superElement != null) {
          superInstance = QuetzalElement._createSuperInstance(classDefiningTemplate);
          while (superElement.childNodes[0] != null) {
            superInstance.appendChild(superElement.childNodes[0]);
          }
          this.$ = superInstance.$;
          this._properties = superInstance._properties;
          _ref = superElement.attributes;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            _ref1 = _ref[_i], name = _ref1.name, value = _ref1.value;
            this[name] = value;
          }
          superElement.parentNode.replaceChild(superInstance, superElement);
        }
      } else {
        root.appendChild(QuetzalElement.parse(this.template, classDefiningTemplate));
        CustomElements.upgradeAll(root);
      }
      _ref2 = root.querySelectorAll("[id]");
      _results = [];
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        subelement = _ref2[_j];
        _results.push(this.$[subelement.id] = subelement);
      }
      return _results;
    };

    QuetzalElement._createSuperInstance = function(elementClass) {
      var baseClass;

      baseClass = elementClass.__super__.constructor;
      if (baseClass == null) {
        throw "The template for " + elementClass.name + " uses <super>, but superclass can't be found.";
      }
      return QuetzalElement.create(baseClass);
    };

    return QuetzalElement;

  })(HTMLDivElement);

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

}).call(this);

(function() {
  var RepeatList, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  RepeatList = (function(_super) {
    __extends(RepeatList, _super);

    function RepeatList() {
      _ref = RepeatList.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RepeatList.prototype.template = {
      style: ":not(style) {\n  display: block;\n}"
    };

    RepeatList.property("count", function() {
      return this._refresh();
    });

    RepeatList.property("increment", function() {
      return this._refresh();
    });

    RepeatList.property("itemclass", function() {
      return this._refresh();
    });

    RepeatList.prototype.ready = function() {
      RepeatList.__super__.ready.call(this);
      return this.increment = true;
    };

    RepeatList.prototype.contentForNthElement = function(index) {
      var textNode, _ref1, _ref2, _ref3;

      textNode = document.createTextNode();
      textNode.textContent = (_ref1 = (_ref2 = this.repeatcontent) != null ? _ref2 : (_ref3 = this.itemclass) != null ? _ref3.name : void 0) != null ? _ref1 : this.itemclass;
      return textNode;
    };

    RepeatList.property("repeatcontent", function() {
      return this._refresh();
    });

    RepeatList.prototype._refresh = function() {
      var contentElement, count, element, index, itemclass, _i, _ref1, _results;

      count = parseInt(this.count);
      itemclass = this.itemclass;
      if (!((count != null) && (itemclass != null))) {
        return;
      }
      this._emptyShadowRoot();
      _results = [];
      for (index = _i = 0, _ref1 = count - 1; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; index = 0 <= _ref1 ? ++_i : --_i) {
        element = QuetzalElement.create(itemclass);
        contentElement = this.contentForNthElement(index);
        if (this.increment) {
          contentElement.textContent += " " + (index + 1);
        }
        element.appendChild(contentElement);
        _results.push(this.webkitShadowRoot.appendChild(element));
      }
      return _results;
    };

    RepeatList.prototype._emptyShadowRoot = function() {
      var _results;

      _results = [];
      while (this.webkitShadowRoot.childNodes[1] != null) {
        _results.push(this.webkitShadowRoot.childNodes[1].remove());
      }
      return _results;
    };

    RepeatList.register();

    return RepeatList;

  })(QuetzalElement);

}).call(this);

(function() {
  var TestElement, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  TestElement = (function(_super) {
    __extends(TestElement, _super);

    function TestElement() {
      _ref = TestElement.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    TestElement.prototype.template = {
      div: "Stuff goes here"
    };

    TestElement.register();

    return TestElement;

  })(QuetzalElement);

}).call(this);

/*
Shows a block of a CSS color, either a color name or value.
*/


(function() {
  var ColorSwatch, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ColorSwatch = (function(_super) {
    __extends(ColorSwatch, _super);

    function ColorSwatch() {
      _ref = ColorSwatch.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ColorSwatch.prototype.template = [
      {
        style: "@host {\n  * {\n    display: inline-block;\n  }\n}\n\n#swatch {\n  box-sizing: border-box;\n  min-height: 1.5em;\n  min-width: 1.5em;\n}\n#swatch:not(.valid) {\n  border: 1px solid lightgray;\n}"
      }, {
        div: {
          id: "swatch",
          content: [
            {
              content: []
            }
          ]
        }
      }
    ];

    ColorSwatch.getter("color", function() {
      return this.$.swatch.style.backgroundColor;
    });

    ColorSwatch.setter("color", function(color) {
      var colorValid, colorValue, swatch, swatchStyle;

      swatch = this.$.swatch;
      swatchStyle = swatch.style;
      swatchStyle.backgroundColor = "white";
      swatchStyle.backgroundColor = color;
      colorValid = (function() {
        switch (color) {
          case "":
            return false;
          case "white":
          case "rgb( 255, 255, 255 )":
            return true;
          default:
            colorValue = swatchStyle.backgroundColor;
            return !(colorValue === "white" || colorValue === "rgb( 255, 255, 255 )");
        }
      })();
      if (colorValid) {
        return swatch.classList.add("valid");
      } else {
        return swatch.classList.remove("valid");
      }
    });

    ColorSwatch.getter("valid", function() {
      return this.$.swatch.classList.contains("valid");
    });

    ColorSwatch.register();

    return ColorSwatch;

  })(QuetzalElement);

}).call(this);

(function() {
  var DemoTile, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  DemoTile = (function(_super) {
    __extends(DemoTile, _super);

    function DemoTile() {
      _ref = DemoTile.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    DemoTile.prototype.template = [
      {
        style: "@host {\n  * {\n    color: #444;\n    font-size: 0.9em;\n  }\n}\n\n#container {\n  display: inline-block;\n  width: 300px;\n  vertical-align: top;\n}\n\nh3 {\n  border-top: 2px solid gray;\n  color: black;\n  font-size: 1.2em;\n  padding-top: 0.5em;\n}"
      }, {
        div: {
          id: "container",
          content: [
            {
              h3: [
                {
                  markup_tag: [
                    {
                      content: {
                        select: "property"
                      }
                    }
                  ]
                }
              ]
            }, {
              content: []
            }
          ]
        }
      }
    ];

    DemoTile.register();

    return DemoTile;

  })(QuetzalElement);

}).call(this);

(function() {
  var LabeledColorSwatch, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  LabeledColorSwatch = (function(_super) {
    __extends(LabeledColorSwatch, _super);

    function LabeledColorSwatch() {
      _ref = LabeledColorSwatch.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    LabeledColorSwatch.prototype.template = [
      {
        style: ":not(style) {\n  display: inline-block;\n}"
      }, {
        color_swatch: {
          id: "swatch"
        }
      }, " ", {
        content: []
      }
    ];

    LabeledColorSwatch.prototype.ready = function() {
      var _this = this;

      LabeledColorSwatch.__super__.ready.call(this);
      this.addEventListener("contentChanged", function(event) {
        return _this._updateColor();
      });
      return this._updateColor();
    };

    LabeledColorSwatch.prototype._updateColor = function() {
      return this.$.swatch.color = this.textContent;
    };

    LabeledColorSwatch.register();

    return LabeledColorSwatch;

  })(QuetzalElement);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.ListElement = (function(_super) {
    __extends(ListElement, _super);

    function ListElement() {
      _ref = ListElement.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ListElement.property("itemclass", function(elementClass) {
      return this._transmuteChildren();
    });

    ListElement.prototype.ready = function() {
      return ListElement.__super__.ready.call(this);
    };

    ListElement.prototype._transmuteChildren = function() {
      var child, children, index, itemclass, _i, _len, _results;

      itemclass = this.itemclass;
      if (!itemclass) {
        return;
      }
      children = this.childNodes;
      _results = [];
      for (index = _i = 0, _len = children.length; _i < _len; index = ++_i) {
        child = children[index];
        _results.push(QuetzalElement.transmute(children[index], itemclass));
      }
      return _results;
    };

    ListElement.register();

    return ListElement;

  })(QuetzalElement);

}).call(this);

/*
Placeholder image from LoremPixel.com
*/


(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.LoremPixel = (function(_super) {
    __extends(LoremPixel, _super);

    function LoremPixel() {
      _ref = LoremPixel.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    LoremPixel.prototype.template = {
      img: {
        id: "image"
      }
    };

    LoremPixel.alias("height", "$.image.height", function(height) {
      return this._reload();
    });

    LoremPixel.prototype.ready = function() {
      LoremPixel.__super__.ready.call(this);
      if (this.$.image.src === "") {
        this.height = 300;
        return this.width = 400;
      }
    };

    LoremPixel.alias("width", "$.image.width", function(width) {
      return this._reload();
    });

    LoremPixel.prototype._reload = function() {
      if (this.height > 0 && this.width > 0) {
        return this.$.image.src = "http://lorempixel.com/" + this.width + "/" + this.height + "/nature";
      }
    };

    LoremPixel.register();

    return LoremPixel;

  })(QuetzalElement);

}).call(this);

(function() {
  var MappedList, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MappedList = (function(_super) {
    __extends(MappedList, _super);

    function MappedList() {
      _ref = MappedList.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    MappedList.prototype.styles = ":not(style) {\n  display: block;\n}";

    MappedList.getter("count", function() {
      var _ref1;

      return (_ref1 = this.children) != null ? _ref1.length : void 0;
    });

    MappedList.getter("increment", function() {
      return false;
    });

    MappedList.prototype.contentForNthElement = function(index) {
      var contentElement;

      contentElement = document.createElement("content");
      contentElement.select = ":nth-child(" + (index + 1) + ")";
      return contentElement;
    };

    MappedList.prototype.ready = function() {
      return MappedList.__super__.ready.call(this);
    };

    MappedList.register();

    return MappedList;

  })(RepeatList);

}).call(this);

(function() {
  var MarkupTag, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MarkupTag = (function(_super) {
    __extends(MarkupTag, _super);

    function MarkupTag() {
      _ref = MarkupTag.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    MarkupTag.prototype.template = [
      {
        style: "@host {\n  * {\n    font-family: Courier, Courier New, monospace;\n  }\n}"
      }, "<", {
        content: []
      }, ">"
    ];

    MarkupTag.register();

    return MarkupTag;

  })(QuetzalElement);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.QuetzalButton = (function(_super) {
    __extends(QuetzalButton, _super);

    function QuetzalButton() {
      _ref = QuetzalButton.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    QuetzalButton.prototype.template = [
      {
        style: "button {\n  background: none; /* Better to start with no background than a browser-dependent one. */\n  border: none; /* Many button styles don't want a border by default. */\n  box-sizing: border-box;\n  color: inherit; /* Suppress browser's use of special button text color. */\n  cursor: default;\n  /* cursor: pointer; */ /* Improves consistency */\n  font: inherit;\n  margin: 0; /* Addresses margins set differently in IE6/7, FF3+, S5, Chrome */\n  text-align: left; /* Many more things behave like buttons than want to be center-aligned like a stock button. */\n  -webkit-user-select: none;\n  -moz-user-select: none;\n  vertical-align: baseline; /* Improves appearance and consistency in all browsers */\n}\n\n/* &.generic */\nbutton {\n  background: whitesmoke;\n  background-image: -webkit-linear-gradient(top, white, #e6e6e6);\n  background-image: linear-gradient(top, white, #e6e6e6);\n  border: 1px solid #ccc;\n  border-radius: 3px;\n  box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);\n  color: #333;\n  padding: 0.3em 0.6em;\n  text-align: center;\n  text-shadow: 0 1px 1px rgba(255,255,255,.75);\n  white-space: nowrap;\n  vertical-align: middle;\n}\n\nbutton:hover {\n  background-color: #e6e6e6;\n  background-image: -webkit-linear-gradient(top, white, #eee);\n  background-image: linear-gradient(top, white, #eee);\n  border-bottom-color: #ccc;\n  border-left-color: #ddd;\n  border-right-color: #ddd;\n  border-top-color: #e0e0e0;\n  color: #222;\n  text-shadow: 0 1px 3px white;\n}\n\nbutton:active {\n  background-color: #d9d9d9;\n  background-image: none;\n  border-color: #aaa;\n  box-shadow: inset 0 1px 4px 2gba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);\n  color: #111;\n  filter: none;\n  outline: 0;\n}\n\nbutton[disabled] {\n  background: whitesmoke;\n  border: 1px solid #ccc;\n  box-shadow: none;\n  color: #999;\n  cursor: default; /* Re-set default cursor for disabled buttons */\n  text-shadow: none;\n}\n\n/* For now, workaround shadow button click bug by giving huge margin. */\nbutton {\n  padding: 1em;\n}"
      }, {
        button: [
          {
            content: []
          }
        ]
      }
    ];

    QuetzalButton.register();

    return QuetzalButton;

  })(QuetzalElement);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.IconButton = (function(_super) {
    __extends(IconButton, _super);

    function IconButton() {
      _ref = IconButton.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    IconButton.prototype.template = [
      {
        style: "span {\n  font-weight: bold;\n}"
      }, {
        "super": [
          {
            img: {
              id: "icon"
            }
          }, " ", {
            span: [
              {
                content: []
              }
            ]
          }
        ]
      }
    ];

    IconButton.alias("icon", "$.icon.src");

    IconButton.register();

    return IconButton;

  })(QuetzalButton);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.DocumentIconButton = (function(_super) {
    __extends(DocumentIconButton, _super);

    function DocumentIconButton() {
      _ref = DocumentIconButton.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    DocumentIconButton.prototype.inherited = {
      icon: "resources/document_alt_stroke_12x16.png"
    };

    DocumentIconButton.register();

    return DocumentIconButton;

  })(IconButton);

}).call(this);
