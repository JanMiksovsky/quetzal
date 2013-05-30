class MarkupTag extends QuetzalElement

  styles: """
    @host {
      * {
        font-family: Courier, Courier New, monospace;
      }
    }
  """

  template: [ "<" , content: [], ">" ]

  @register()
