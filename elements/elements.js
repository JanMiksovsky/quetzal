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
        style: "@host {\n  * {\n    color: #444;\n    font-size: 0.9em;\n  }\n}\n\n#container {\n  display: inline-block;\n  max-width: 300px;\n  vertical-align: top;\n}\n\nh3 {\n  border-top: 2px solid gray;\n  color: black;\n  font-size: 1.2em;\n  padding-top: 0.5em;\n}\n\n#code {\n  margin: 0;\n  white-space: pre-wrap;\n  word-wrap: break-word;\n}"
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
                        select: "property[name='classname']"
                      }
                    }
                  ]
                }
              ]
            }, {
              p: [
                {
                  content: {
                    select: "property[name='description']"
                  }
                }
              ]
            }, {
              content: {
                select: "property[name='demo']"
              }
            }, {
              pre: {
                id: "code"
              }
            }
          ]
        }
      }
    ];

    DemoTile.prototype.ready = function() {
      var _this = this;

      DemoTile.__super__.ready.call(this);
      this.addEventListener("contentChanged", function(event) {
        return _this._showDemoCode();
      });
      return this._showDemoCode();
    };

    DemoTile.prototype._showDemoCode = function() {
      var demo, _ref1;

      demo = this.querySelector("property[name='demo']");
      return this.$.code.textContent = (_ref1 = demo != null ? demo.innerHTML : void 0) != null ? _ref1 : "";
    };

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
  var PopupSource, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PopupSource = (function(_super) {
    __extends(PopupSource, _super);

    function PopupSource() {
      _ref = PopupSource.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    PopupSource.prototype.template = [
      {
        quetzal_popup: {
          id: "popup",
          content: [
            {
              content: {
                select: "property[name='popup']"
              }
            }
          ]
        }
      }, {
        div: {
          id: "container",
          content: [
            {
              content: []
            }
          ]
        }
      }
    ];

    PopupSource.prototype.ready = function() {
      var _this = this;

      PopupSource.__super__.ready.call(this);
      this.$.container.addEventListener("click", function() {
        if (typeof console !== "undefined" && console !== null) {
          console.log("open");
        }
        return _this.$.popup.open();
      });
      this.$.popup.addEventListener("closed", function() {
        return typeof console !== "undefined" && console !== null ? console.log("close") : void 0;
      });
      return this.$.popup.addEventListener("canceled", function() {
        return typeof console !== "undefined" && console !== null ? console.log("cancel") : void 0;
      });
    };

    PopupSource.register();

    return PopupSource;

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
        style: "button {\n  background: none; /* Better to start with no background than a browser-dependent one. */\n  border: none; /* Many button styles don't want a border by default. */\n  box-sizing: border-box;\n  color: inherit; /* Suppress browser's use of special button text color. */\n  cursor: default;\n  /* cursor: pointer; */ /* Improves consistency */\n  font: inherit;\n  margin: 0; /* Addresses margins set differently in IE6/7, FF3+, S5, Chrome */\n  text-align: left; /* Many more things behave like buttons than want to be center-aligned like a stock button. */\n  -webkit-user-select: none;\n  -moz-user-select: none;\n  vertical-align: baseline; /* Improves appearance and consistency in all browsers */\n}\n\n/* &.generic */\nbutton {\n  background: whitesmoke;\n  background-image: -webkit-linear-gradient(top, white, #e6e6e6);\n  background-image: linear-gradient(top, white, #e6e6e6);\n  border: 1px solid #ccc;\n  border-radius: 3px;\n  box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);\n  color: #333;\n  padding: 0.3em 0.6em;\n  text-align: center;\n  text-shadow: 0 1px 1px rgba(255,255,255,.75);\n  white-space: nowrap;\n  vertical-align: middle;\n}\n\nbutton:hover {\n  background-color: #e6e6e6;\n  background-image: -webkit-linear-gradient(top, white, #eee);\n  background-image: linear-gradient(top, white, #eee);\n  border-bottom-color: #ccc;\n  border-left-color: #ddd;\n  border-right-color: #ddd;\n  border-top-color: #e0e0e0;\n  color: #222;\n  text-shadow: 0 1px 3px white;\n}\n\nbutton:active {\n  background-color: #d9d9d9;\n  background-image: none;\n  border-color: #aaa;\n  box-shadow: inset 0 1px 4px 2gba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);\n  color: #111;\n  outline: 0;\n}\n\nbutton[disabled] {\n  background: whitesmoke;\n  border: 1px solid #ccc;\n  box-shadow: none;\n  color: #999;\n  cursor: default; /* Re-set default cursor for disabled buttons */\n  text-shadow: none;\n}\n\n/* For now, workaround shadow button click bug by giving huge margin. */\nbutton {\n  padding: 1em;\n}"
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

/*
An element that covers the entire viewport, typically to swallow clicks.
*/


(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.QuetzalOverlay = (function(_super) {
    __extends(QuetzalOverlay, _super);

    function QuetzalOverlay() {
      _ref = QuetzalOverlay.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    QuetzalOverlay.prototype.template = [
      {
        style: "@host {\n  * {\n    background: black;\n    bottom: 0;\n    cursor: default;\n    left: 0;\n    opacity: 0.25;\n    position: fixed;\n    right: 0;\n    top: 0;\n  }\n}"
      }
    ];

    QuetzalOverlay.property("target", function(target) {
      var targetZIndex;

      if (target === null) {
        return;
      }
      targetZIndex = parseInt(target.style.zIndex);
      if (targetZIndex) {
        this.style.zIndex = targetZIndex;
      }
      return target.parentNode.insertBefore(this, target);
    });

    QuetzalOverlay.register();

    return QuetzalOverlay;

  })(QuetzalElement);

}).call(this);

(function() {
  var QuetzalPopup, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  QuetzalPopup = (function(_super) {
    __extends(QuetzalPopup, _super);

    function QuetzalPopup() {
      _ref = QuetzalPopup.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    QuetzalPopup.prototype.template = [
      {
        style: "@host {\n\n  * {\n    position: absolute;\n    z-index: 1;\n  }\n\n  *:not(.opened) {\n    display: none;\n  }\n\n  /* Generic appearance */\n  /* &.generic { */\n  * {\n    background: white;\n    border: 1px solid rgba(0, 0, 0, 0.2);\n    box-shadow: 0 2px 4px rgba( 0, 0, 0, 0.2 );\n    box-sizing: border-box;\n    padding: .25em;\n    -webkit-user-select: none;\n    user-select: none;\n  }\n}"
      }, {
        content: []
      }
    ];

    QuetzalPopup.propertyBool("cancelOnEscapeKey", null, true);

    QuetzalPopup.propertyBool("cancelOnOutsideClick", null, true);

    QuetzalPopup.propertyBool("closeOnInsideClick", null, true);

    QuetzalPopup.prototype.cancel = function() {
      return this._close("canceled");
    };

    QuetzalPopup.prototype.close = function() {
      return this._close("closed");
    };

    QuetzalPopup.prototype.ready = function() {
      var _ref1;

      QuetzalPopup.__super__.ready.call(this);
      return (_ref1 = this.overlayclass) != null ? _ref1 : this.overlayclass = "quetzal-overlay";
    };

    QuetzalPopup.prototype.open = function() {
      if (this.opened) {
        return;
      }
      if (this.overlayclass != null) {
        this.overlay = QuetzalElement.create(this.overlayclass);
        this.overlay.target = this;
      }
      this._eventsOn();
      this.opened = true;
      this.dispatchEvent(new CustomEvent("opened"));
      return this.positionPopup();
    };

    QuetzalPopup.getter("opened", function() {
      return this.classList.contains("opened");
    });

    QuetzalPopup.setter("opened", function(opened) {
      return this.classList.toggle("opened", opened);
    });

    QuetzalPopup.property("overlay");

    QuetzalPopup.property("overlayclass");

    QuetzalPopup.prototype.positionPopup = function() {};

    QuetzalPopup.prototype._close = function(closeEventName) {
      this._eventsOff();
      if (this.overlay != null) {
        this.overlay.remove();
        this.overlay = null;
      }
      if (this.opened) {
        if (closeEventName) {
          this.dispatchEvent(new CustomEvent(closeEventName));
        }
        return this.opened = false;
      }
    };

    QuetzalPopup.prototype._eventsOff = function() {
      var _ref1;

      if (this._handlerOutsideClick != null) {
        if ((_ref1 = this.overlay) != null) {
          _ref1.removeEventListener("click", this._handlerOutsideClick);
        }
        this._handlerOutsideClick = null;
      }
      if (this._handlerInsideClick != null) {
        this.removeEventListener("click", this._handlerInsideClick);
        this._handlerInsideClick = null;
      }
      if (this._handlerDocumentKeydown) {
        document.removeEventListener("keydown", this._handlerDocumentKeydown);
        return this._handlerDocumentKeydown = null;
      }
    };

    QuetzalPopup.prototype._eventsOn = function() {
      var _ref1,
        _this = this;

      this._handlerDocumentKeydown = function(event) {
        if (_this.cancelOnEscapeKey && event.keyCode === 27) {
          _this.cancel();
          return event.stopPropagation();
        }
      };
      document.addEventListener("keydown", this._handlerDocumentKeydown);
      if (this.cancelOnOutsideClick) {
        this._handlerOutsideClick = function(event) {
          return _this.cancel();
        };
        if ((_ref1 = this.overlay) != null) {
          _ref1.addEventListener("click", this._handlerOutsideClick);
        }
      }
      if (this.closeOnInsideClick) {
        this._handlerInsideClick = function(event) {
          return _this.close();
        };
        return this.addEventListener("click", this._handlerInsideClick);
      }
    };

    QuetzalPopup.property("_handlerInsideClick");

    QuetzalPopup.property("_handlerOutsideClick");

    QuetzalPopup.property("_handlerDocumentKeydown");

    QuetzalPopup.register();

    return QuetzalPopup;

  })(QuetzalElement);

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

    TestElement.prototype.template = [
      "Content: ", {
        content: {
          select: ":not(property)"
        }
      }, {
        p: [
          {
            i: [
              "Foo:", {
                content: {
                  select: "property[name='foo']"
                }
              }
            ]
          }
        ]
      }
    ];

    TestElement.register();

    return TestElement;

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
        style: "@host {\n  * {\n    font-weight: bold;\n  }        \n}"
      }, {
        "super": [
          {
            img: {
              id: "icon"
            }
          }, " ", {
            content: []
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
  var PopupButton, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PopupButton = (function(_super) {
    __extends(PopupButton, _super);

    function PopupButton() {
      _ref = PopupButton.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    PopupButton.prototype.template = [
      {
        "super": [
          {
            property: {
              name: "popup"
            }
          }, [
            {
              content: {
                select: "property[name='popup']"
              }
            }
          ], {
            quetzal_button: {
              id: "button",
              content: [
                {
                  content: []
                }
              ]
            }
          }
        ]
      }
    ];

    PopupButton.register();

    return PopupButton;

  })(PopupSource);

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
