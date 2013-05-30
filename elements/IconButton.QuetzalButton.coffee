class window.IconButton extends QuetzalButton

  style: """
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
