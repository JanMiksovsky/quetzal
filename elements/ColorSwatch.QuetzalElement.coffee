###
Shows a block of a CSS color, either a color name or value. 
###

class ColorSwatch extends QuetzalElement

  style: """
    swatch {
      min-height: 1.5em;
      min-width: 1.5em;
    }
  """

  template: """
    <div id="swatch">
      <content></content>
    </div>
  """

  ready: ->
    super()
    @color = "gray"

  # The color to show as a swatch.
  # TODO: Replace with @getterSetter
  @getter "color", -> @_swatchColor
  @setter "color", ( color ) ->
    console?.log "setting color: #{color}"
    @_swatchColor = color
    # @css "background-color", "white"  # Apply white first
    # @css "background-color", color    # Apply new color
    
    # # Validate the color value. 
    # colorValid = undefined
    # if color is "" or color is null
    #   colorValid = false
    # else if color is "white" or color is "rgb( 255, 255, 255 )"
    #   # White color values are known to be good.
    #   colorValid = true
    # else        
    #   # See if the new value "stuck", or is still white.
    #   colorValue = @css "background-color"
    #   colorValid = not ( colorValue is "white" or colorValue is "rgb( 255, 255, 255 )" )
    # @toggleClass "none", not colorValid

  @alias "_swatchColor", "$.swatch.style.backgroundColor"

  @register()
