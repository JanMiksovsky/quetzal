class window.IconButton extends QuetzalButton

  style: """
    @host {
      * {
        color: red;
        font-weight: bold;
      }
    }
  """

  template: """
    <super>
      <img id="icon"/>
      <content></content>
    </super>
  """

  # template: [
  #   img:
  #     id: "icon"
  # ,
  #   content: []
  # ]

  @alias "icon", "$.icon.src"
  @register()
