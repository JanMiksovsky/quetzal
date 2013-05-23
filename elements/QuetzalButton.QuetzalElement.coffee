class window.QuetzalButton extends QuetzalElement

  style: """
    @host {
      div {
        display: inline-block;
      }
    }
    
    button {
      margin: 0;
      padding: 1em;
    }
  """

  template: """
    <button>
      <content></content>
    </button>
  """

  @register()
