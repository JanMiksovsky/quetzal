class window.IconButton extends QuetzalButton

  template: [
    style: """
      span {
        font-weight: bold;
      }
    """
  ,
    super: [
      img: id: "icon"
    ,
      " "
    ,
      span: [
        content: []
      ]
    ]
  ]

  @alias "icon", "$.icon.src"
  @register()
