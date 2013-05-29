class LabeledColorSwatch extends QuetzalElement

  style: """
    :not(style) {
      display: inline-block;
      /* vertical-align: middle; */
    }
  """

  template: """
    <color-swatch id="swatch"></color-swatch>
    <content></content>
  """

  ready: ->
    super()
    @addEventListener "contentChanged", ( event ) =>
      @_updateColor()
    @_updateColor()

  _updateColor: ->
    @$.swatch.color = @textContent

  @register()
