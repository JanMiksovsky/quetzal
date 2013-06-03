class TestElement extends QuetzalElement

  template: [
    quetzal_button: content: "Click for overlay"
  ,
    quetzal_popup: id: "popup", content: "Hello"
  ]

  ready: ->
    super()
    @addEventListener "click", =>
      @$.popup.open()

  @register()
