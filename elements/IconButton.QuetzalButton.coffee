class window.IconButton extends QuetzalButton

  template: [
    style: """
      @host {
        * {
          font-weight: bold;
        }        
      }
    """
  ,
    super: [
      img: id: "icon"
    ,
      " "
    ,
      content: []
    ]
  ]

  @alias "icon", "$.icon.src"
  @register()
