class MarkupTag extends QuetzalElement

  template: [
    style: """
      @host {
        * {
          font-family: Courier, Courier New, monospace;
        }
      }
    """
  ,
    "<"
  ,
    content: []
  ,
    ">"
  ]

  @register()
