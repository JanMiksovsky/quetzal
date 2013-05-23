test "QuetzalElement2: class with <super>", ->
  class Greet extends QuetzalElement2
    template: "Hello, <content></content>."
  class EmphaticGreet extends Greet
    template: "<super>*<content></content>*</super>"
  div = document.createElement "div"
  div.textContent = "Alice"
  new EmphaticGreet div
  renderEqual div, "<span>Hello, *Alice*.</span>"

test "QuetzalElement2: <super> with attribute sets property on super element", ->
  class Foo extends QuetzalElement2
    @property "message", ( message ) ->
      this._message = message
  class Bar extends Foo
    template: """"
      <super message="Hello"></super>
    """
  div = document.createElement "div"
  new Bar div
  equal div._message, "Hello"
