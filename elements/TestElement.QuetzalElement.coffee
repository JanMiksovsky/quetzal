class TestElement extends QuetzalElement

  template: [
    "Content: "
  ,
    content: select: ":not(property)"
  ,
    p: [
      i: [
        "Foo:"
      ,
        content: select: "property[name='foo']"
      ]
    ]
  ]

  @register()
