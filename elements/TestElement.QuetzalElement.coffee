class TestElement extends QuetzalElement

  template: [
    quetzal_button: id: "button", content: "Click for overlay"
  ,
    quetzal_popup: id: "popup", content: "Hello"
  ]

  ready: ->
    super()
    @$.button.addEventListener "click", =>
      console?.log "open"
      @$.popup.open()
    @addEventListener "closed", => console?.log "close"
    @addEventListener "canceled", => console?.log "cancel"

  @register()
