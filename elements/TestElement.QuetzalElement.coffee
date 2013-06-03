class TestElement extends QuetzalElement

  template: [
    style: """
      button {
        padding: 1em;
      }
      :hover {
        background: red;
      }
    """
  ,
    button: [
      content: []
    ]
  ]

  @register()
