class window.IconButton extends QuetzalButton

  style: """
    @host {
      * {
        color: red;
      }
    }
    span {
      font-weight: bold;
    }
  """

  template: """
    <super>
      <img id="icon"/>
      <span>
        <content></content>
      </span>
    </super>
  """

  @alias "icon", "$.icon.src"
  @register()
