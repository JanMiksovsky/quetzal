###
QuetzalElement tests

These rely on Polymer's ShadowDOMPolyfill to compose light DOM and shadow DOM
together for inspection purposes.
###

window.renderEqual = ( element, expected ) ->
  renderer = ShadowDOMPolyfill.getRendererForHost element
  renderer.render()
  actual = element.impl.innerHTML
  equal actual, expected

test "QuetzalElement: instantiate with constructor", ->
  element = new QuetzalElement()
  ok element instanceof QuetzalElement
  ok element instanceof HTMLDivElement
  element.innerHTML = "Hello"
  renderEqual element, "Hello"

test "QuetzalElement: instantiate with createElement", ->
  element = document.createElement "quetzal-element"
  ok element instanceof QuetzalElement
  ok element instanceof HTMLDivElement
  element.innerHTML = "Hello"
  renderEqual element, "Hello"

test "QuetzalElement: degenerate subclass", ->
  class Foo extends QuetzalElement
  foo = new Foo()
  foo.textContent = "Hello"
  ok foo instanceof Foo
  ok foo instanceof QuetzalElement
  ok foo instanceof HTMLDivElement
  renderEqual foo, "Hello"

test "QuetzalElement: subclass with simple template", ->
  class Greet extends QuetzalElement
    template: "Hello, <content></content>."
  greet = new Greet()
  greet.textContent = "Alice"
  ok greet instanceof Greet
  ok greet instanceof QuetzalElement
  ok greet instanceof HTMLDivElement
  renderEqual greet, "Hello, Alice."

test "QuetzalElement: sub-subclass", ->
  class Greet extends QuetzalElement
    template: "Hello, <content></content>."
  class SubGreet extends Greet
  subGreet = new SubGreet()
  subGreet.textContent = "Bob"
  ok subGreet instanceof SubGreet
  ok subGreet instanceof Greet
  ok subGreet instanceof QuetzalElement
  ok subGreet instanceof HTMLDivElement
  renderEqual subGreet, "Hello, Bob."

test "QuetzalElement: sub-subclass with <super>", ->
  class Greet extends QuetzalElement
    template: "Hello, <content></content>."
  class EmphaticGreet extends Greet
    template: "<super>*<content></content>*</super>"
  emphatic = new EmphaticGreet()
  emphatic.textContent = "Bob"
  ok emphatic instanceof EmphaticGreet
  ok emphatic instanceof Greet
  ok emphatic instanceof QuetzalElement
  ok emphatic instanceof HTMLDivElement
  renderEqual emphatic, "<div class=\"Greet\">Hello, *Bob*.</div>"

test "QuetzalElement: <super> with attribute sets property on super element", ->
  class Foo extends QuetzalElement
    @property "message", ( message ) ->
      this._message = message
  class Bar extends Foo
    template: """"
      <super message="Hello"></super>
    """
  bar = new Bar()
  equal bar._message, "Hello"

test "QuetzalElement: set inherited base class property", ->
  class Foo extends QuetzalElement
    @getter "message", ( message ) -> @._message
    @setter "message", ( message ) -> @._message = message
    test: "Hello"
  class Bar extends Foo
    inherited:
      message: "Hello"
  bar = new Bar()
  equal bar._message, "Hello"

test "QuetzalElement: element reference", ->
  class Foo extends QuetzalElement
    template: "<span id='message'></span>"
  foo1 = new Foo()
  foo2 = new Foo()
  equal foo1.$.message, foo1.webkitShadowRoot.querySelector "#message"
  equal foo2.$.message, foo2.webkitShadowRoot.querySelector "#message"

test "QuetzalElement: element reference on base class available to subclass", ->
  class Foo extends QuetzalElement
    template: "<span id='message'>Hello</span>"
  class Bar extends Foo
    template: "<super><content></content></super>"
  bar = new Bar()
  equal bar.$.message?.textContent, "Hello"

test "QuetzalElement: alias", ->
  class Foo extends QuetzalElement
    template: "<span id='message'>Hello</span>"
    @alias "message", "$.message.innerHTML", ( message ) ->
      @_messageSet = true
  foo = new Foo()
  equal foo.message, "Hello"
  ok not foo._messageSet
  foo.message = "Goodbye"
  equal foo.$.message.innerHTML, "Goodbye"
  ok foo._messageSet

test "QuetzalElement: property", ->
  class Foo extends QuetzalElement
    @property "message", ( message ) ->
      @_messageSet = true
  foo = new Foo()
  equal foo.message, undefined
  ok not foo._messageSet?
  foo.message = "Hello"
  equal foo._properties.message, "Hello"
  ok foo._messageSet

test "QuetzalElement: ready method", ->
  class Foo extends QuetzalElement
    template: "Hello, world."
    ready: ->
      super
      @_readyCalled = true
    _readyCalled: false
  foo = new Foo()
  ok foo._readyCalled
  renderEqual foo, "Hello, world."

test "QuetzalElement: tagForClass", ->
  class FooBar
  equal QuetzalElement.tagForClass( FooBar ), "foo-bar"

test "QuetzalElement: @register", ->
  ok not window.FooBar?
  ok not CustomElements.registry[ "foo-bar" ]?
  readyCalled = false
  class FooBar extends QuetzalElement
    ready: ->
      super()
      readyCalled = true
    @register()
  registration = CustomElements.registry[ "foo-bar" ]
  ok registration?
  equal registration.ctor, window.FooBar
  equal registration.prototype, window.FooBar.prototype
  fooBar = document.createElement "foo-bar"
  ok fooBar instanceof FooBar # original class
  ok fooBar instanceof window.FooBar # registered (munged) class
  ok readyCalled
  delete window.FooBar
  delete CustomElements.registry[ "foo-bar" ]

test "QuetzalElement: element of registered class sets property in markup", ->
  ok not window.FooBar?
  ok not CustomElements.registry[ "foo-bar" ]?
  class FooBar extends QuetzalElement
    ready: ->
      super()
      debugger
    @property "message", ( message ) ->
      @_messageSet = true
    @register()
  div = document.createElement "div"
  div.innerHTML = "<foo-bar message='Hello'></foo-bar>"
  fooBar = div.childNodes[0]
  ok fooBar instanceof window.FooBar
  ok fooBar._messageSet
  equal fooBar.message, "Hello"
  delete window.FooBar
  delete CustomElements.registry[ "foo-bar" ]

test "QuetzalElement: subclass with registered superclass creates super-instance as named element", ->
  class FooBar extends QuetzalElement
    template: "<content></content>"
    @register()
  class SubClass extends FooBar
    template: "<super><content></content></super>"
  element = new SubClass()
  element.textContent = "Hello"
  renderEqual element, "<foo-bar>Hello</foo-bar>"
  delete window.FooBar
  delete CustomElements.registry.FooBar
