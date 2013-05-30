class LabeledColorSwatch extends QuetzalElement

  template: [
    style: """
      :not(style) {
        display: inline-block;
      }
    """
  ,
    color_swatch: id: "swatch"
  ,
    " "
  ,
    content: []
  ]

  ready: ->
    super()
    @addEventListener "contentChanged", ( event ) =>
      @_updateColor()
    @_updateColor()

  _updateColor: ->
    @$.swatch.color = @textContent

  @register()
