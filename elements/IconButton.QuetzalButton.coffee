class window.IconButton extends QuetzalButton

  styles: """
    span {
      font-weight: bold;
    }
  """

  template:
    super: [
      img: id: "icon"
    ,
      " "
    ,
      span: [
        content: []
      ]
    ]

  @alias "icon", "$.icon.src"
  @register()
