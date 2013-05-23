class FooElement extends QuetzalElement
  style: "@host { * { color: red } }"
  template: "<content></content>"

class BarElement extends FooElement
  template: "<super><content></content></style>"
