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
  renderEqual greet, "<div class=\"QuetzalElement wrapper\">Hello, Alice.</div>"

test "QuetzalElement: sub-subclass", ->
  class Greet extends QuetzalElement
    template: "Hello, <content></content>."
  class EmphaticGreet extends Greet
    template: "*<content></content>*"
  div = document.createElement "div"
  div.textContent = "Bob"
  new EmphaticGreet div
  ok div instanceof EmphaticGreet
  ok div instanceof Greet
  ok div instanceof QuetzalElement
  ok div instanceof HTMLDivElement
  renderEqual div, "<div class=\"Greet wrapper\"><div class=\"QuetzalElement wrapper\">Hello, *Bob*.</div></div>"

test "QuetzalElement: set inherited base class property", ->
  class Foo extends QuetzalElement
    @getter "message", ( message ) -> @._message
    @setter "message", ( message ) -> @._message = message
    test: "Hello"
  class Bar extends Foo
    inherited:
      message: "Hello"
  div = document.createElement "div"
  new Bar div
  equal div._message, "Hello"

test "QuetzalElement: element reference", ->
  class Foo extends QuetzalElement
    template: "<span id='message'>Hello</span>"
  div = document.createElement "div"
  new Foo div
  equal div.$.message.textContent, "Hello"

test "QuetzalElement: alias", ->
  class Foo extends QuetzalElement
    template: "<span id='message'>Hello</span>"
    @alias "message", "$.message.innerHTML", ( message ) ->
      @_messageSet = true
  div = document.createElement "div"
  new Foo div
  equal div.message, "Hello"
  ok not div._messageSet
  div.message = "Goodbye"
  equal div.$.message.innerHTML, "Goodbye"
  ok div._messageSet

test "QuetzalElement: property", ->
  class Foo extends QuetzalElement
    @property "message", ( message ) ->
      @_messageSet = true
  div = document.createElement "div"
  new Foo div
  equal div.message, undefined
  ok not div._messageSet
  div.message = "Hello"
  equal div._properties.message, "Hello"
  ok div._messageSet

test "QuetzalElement: ready method", ->
  class Foo extends QuetzalElement
    ready: ->
      @_readyCalled = true
    _readyCalled: false
  div = document.createElement "div"
  new Foo div
  ok div._readyCalled

test "QuetzalElement: tagForClass", ->
  class FooBar
  equal QuetzalElement.tagForClass( FooBar ), "foo-bar"

test "QuetzalElement: @register", ->
  class FooBar extends HTMLDivElement
    @register()
  registration = CustomElements.registry[ "foo-bar" ]
  ok registration?
  equal registration.ctor, window.FooBar
  equal registration.prototype, window.FooBar.prototype
  div = document.createElement "div"
  new window.FooBar div
  ok div instanceof FooBar # original class
  ok div instanceof window.FooBar # registered (munged) class
  window.FooBar = null # Reset for other unit tests

test "QuetzalElement: instantiate registered class", ->
  class FooBar extends QuetzalElement
    @register()
  fooBar = document.createElement "foo-bar"
  ok fooBar instanceof FooBar

