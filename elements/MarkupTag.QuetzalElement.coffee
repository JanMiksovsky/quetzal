class MarkupTag extends QuetzalElement

  style: """
    @host {
      * {
        font-family: Courier, Courier New, monospace;
      }
    }
  """

  template: [ "<" , content: [], ">" ]

  @register()
