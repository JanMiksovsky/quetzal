class PopupButton extends PopupSource

  template: [
    super: [
      property: name: "popup", [
        content: select: "property[name='popup']"
      ]
    ,
      quetzal_button: id: "button", content: [
        content: []
      ]
    ]
  ]

  @register()
