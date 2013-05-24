class LabeledColorSwatch extends QuetzalElement

  style: """
    *:not(style) {
      display: inline-block;
      vertical-align: middle;
    }
  """

  template: """
    <color-swatch id="swatch"></color-swatch>
    <span id="colorName"></span>
  """

  @alias "color", "$.colorName.textContent", ( color ) ->
    @$.swatch.color = color

  @register()
