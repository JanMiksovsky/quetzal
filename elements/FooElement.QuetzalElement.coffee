class FooElement extends QuetzalElement
  style: "@host { * { color: red } }"
  template: "<content></content>"
  @register()

class BarElement extends FooElement
  template: "<super><content></content></style>"
  @register()