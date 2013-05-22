class window.QuetzalButton extends QuetzalElement

  style: """
    .wrapper {
      display: inline-block;
    }

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

  # template: [
  #   button:
  #     content: []
  # ]

  ready: ->
    console?.log "QuetzalButton: ready"

  @register()

# window.QuetzalButton = document.register "quetzal-button",
#   prototype: QuetzalButton::
#   extends: "div"
