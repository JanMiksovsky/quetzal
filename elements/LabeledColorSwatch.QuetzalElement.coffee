class LabeledColorSwatch extends QuetzalElement

  style: """
    *:not(style) {
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
    observer = new MutationObserver => @_updateColor()
    observer.observe @,
      characterData: true
      childList: true
      subtree: true
    @_updateColor()

  _updateColor: ->
    @$.swatch.color = @textContent

  @register()
