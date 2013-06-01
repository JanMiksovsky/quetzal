class MarkupTag extends QuetzalElement

  template: [
    style: """
      @host {
        :scope {
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
