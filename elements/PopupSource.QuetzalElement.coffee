class PopupSource extends QuetzalElement

  template: [
    quetzal_popup: id: "popup", content: [
      content: select: "property[name='popup']"
    ]
  ,
    div: id: "container", content: [
      content: []
    ]
  ]

  ready: ->
    super()
    @$.container.addEventListener "click", =>
      console?.log "open"
      @$.popup.open()
    @$.popup.addEventListener "closed", => console?.log "close"
    @$.popup.addEventListener "canceled", => console?.log "cancel"

  @register()
