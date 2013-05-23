class window.QuetzalButton extends QuetzalElement

  style: """
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
