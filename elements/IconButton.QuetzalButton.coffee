class window.IconButton extends QuetzalButton

  style: """
    .wrapper {
      display: inline-block;
    }

    * {
      font-weight: bold;
    }
  """

  template: """
    <img id="icon"/>
    <content></content>
  """

  # template: [
  #   img:
  #     id: "icon"
  # ,
  #   content: []
  # ]

  @alias "icon", "$.icon.src"
  @register()
