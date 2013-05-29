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

deregister = ( classFn ) ->
  className = classFn.name
  tagName = QuetzalElement.tagForClass classFn
  delete window[ className ]
  delete CustomElements.registry[ tagName ]

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
  deregister FooBar

test "QuetzalElement: element of registered class sets property in markup", ->
  ok not window.FooBar?
  ok not CustomElements.registry[ "foo-bar" ]?
  class FooBar extends QuetzalElement
    @property "message", ( message ) ->
      @_messageSet = true
    @register()
  div = document.createElement "div"
  div.innerHTML = "<foo-bar message='Hello'></foo-bar>"
  fooBar = div.childNodes[0]
  CustomElements.upgrade fooBar
  ok fooBar instanceof window.FooBar
  ok fooBar._messageSet
  equal fooBar.message, "Hello"
  deregister FooBar

test "QuetzalElement: subclass with registered superclass creates super-instance as named element", ->
  class FooBar extends QuetzalElement
    template: "<content></content>"
    @register()
  class SubClass extends FooBar
    template: "<super><content></content></super>"
  element = new SubClass()
  element.textContent = "Hello"
  renderEqual element, "<foo-bar>Hello</foo-bar>"
  deregister FooBar

test "QuetzalElement: template for one class hosts instance of another class", ->
  class GreetElement extends QuetzalElement
    template: "Hello, <content></content>."
    @register()
  class GreetHost extends QuetzalElement
    template: "<greet-element>Alice</greet-element>"
  greetHost = new GreetHost()
  renderEqual greetHost, "<greet-element>Hello, Alice.</greet-element>"
  deregister GreetElement

asyncTest "QuetzalElement: contentChanged event", ->
  expect 2
  class Foo extends QuetzalElement
    ready: ->
      super()
      @addEventListener "contentChanged", ( event ) =>
        equal @textContent, "Hello"
        start()
  foo = new Foo()
  equal foo.textContent, ""
  fixture = document.querySelector "#qunit-fixture"
  fixture.appendChild foo
  foo.textContent = "Hello"

test "QuetzalElement: create", ->
  div = QuetzalElement.create "div"
  ok div instanceof HTMLDivElement
  ok not ( div instanceof QuetzalElement )
  class FooElement extends QuetzalElement
    template: "Foo: <content></content>"
  foo = QuetzalElement.create FooElement
  foo.textContent = "Hello"
  ok foo instanceof FooElement
  renderEqual foo, "Foo: Hello"
  throws =>
    QuetzalElement.create "foo-element" # Class not registered; should fail.
  class BarElement extends QuetzalElement
    template: "Bar: <content></content>"
    @register()
  bar1 = QuetzalElement.create "bar-element"
  bar1.textContent = "One"
  ok bar1 instanceof window.BarElement
  renderEqual bar1, "Bar: One"
  bar2 = QuetzalElement.create "BarElement"
  bar2.textContent = "Two"
  ok bar2 instanceof window.BarElement
  renderEqual bar2, "Bar: Two"
  deregister FooElement
  deregister BarElement

test "QuetzalElement: parse empty element", ->
  element = QuetzalElement.parse
    div: []
  equal element.outerHTML, "<div></div>"

test "QuetzalElement: parse element with text content", ->
  element = QuetzalElement.parse
    span: "Hello"
  equal element.outerHTML, "<span>Hello</span>"

test "QuetzalElement: parse element with element array", ->
  element = QuetzalElement.parse
    div: [
      span: "Hello"
    ,
      span: "Goodbye"
    ]
  equal element.outerHTML, "<div><span>Hello</span><span>Goodbye</span></div>"

test "QuetzalElement: parse element with content psuedo-property", ->
  element = QuetzalElement.parse
    div: content: [
      span: "Hello"
    ,
      span: "Goodbye"
    ]
  equal element.outerHTML, "<div><span>Hello</span><span>Goodbye</span></div>"

test "QuetzalElement: parse element with attribute", ->
  element = QuetzalElement.parse
    input: type: "text"
  equal element.outerHTML, "<input type=\"text\">"
