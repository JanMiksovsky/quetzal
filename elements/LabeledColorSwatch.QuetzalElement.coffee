class LabeledColorSwatch extends QuetzalElement

  template: """
    <color-swatch id="swatch"></color-swatch>
    <content></content>
  """

  ready: ->
    super()
    @$.swatch.color = "green"

  @register()
