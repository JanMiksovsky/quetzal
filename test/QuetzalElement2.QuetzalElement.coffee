test "QuetzalElement2: class with <super>", ->
  class Greet extends QuetzalElement2
    template: "Hello, <content></content>."
  class EmphaticGreet extends Greet
    template: "<super>*<content></content>*</super>"
  div = document.createElement "div"
  div.textContent = "Alice"
  new EmphaticGreet div
  renderEqual div, "<span>Hello, *Alice*.</span>"
