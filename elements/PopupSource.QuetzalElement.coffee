class PopupSource extends QuetzalElement

  template: [
    div: id: "container", content: [
      content: []
    ]
  ,
    quetzal_popup: id: "popup", content: "Popup goes here"
  ]

  ready: ->
    super()
    @$.container.addEventListener "click", =>
      console?.log "open"
      @$.popup.open()
    @$.popup.addEventListener "closed", => console?.log "close"
    @$.popup.addEventListener "canceled", => console?.log "cancel"

  @register()
