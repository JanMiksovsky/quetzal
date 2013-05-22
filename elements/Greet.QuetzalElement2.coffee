class window.Greet extends QuetzalElement2
  template: "Hello, <content></content>."

class window.EmphaticGreet extends Greet
  template: "<super>*<content></content>*</super>"
