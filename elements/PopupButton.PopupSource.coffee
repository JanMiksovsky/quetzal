class PopupButton extends PopupSource

  template: [
    style: """
      @host {
        * {
          display: inline-block;
        }
      }
    """
  ,
    super: [
      property: name: "popup", [
        content: select: "property[name='popup']"
      ]
    ,
      quetzal_button: id: "button", content: [
        content: []
      ,
        content: select: "property[name='indicator']", content: "▼"
      ]
    ]
  ]

  # ready: ->
  #   super()
  #   debugger

  @register()
