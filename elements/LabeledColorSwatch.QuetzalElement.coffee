class LabeledColorSwatch extends QuetzalElement

  styles: """
    :not(style) {
      display: inline-block;
      /* vertical-align: middle; */
    }
  """

  template: [
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
