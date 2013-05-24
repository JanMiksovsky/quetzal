###
Shows a block of a CSS color, either a color name or value. 
###

class ColorSwatch extends QuetzalElement

  style: """
    @host {
      * {
        display: inline-block;
      }
    }

    #swatch {
      box-sizing: border-box;
      min-height: 1.5em;
      min-width: 1.5em;
    }
    #swatch:not(.valid) {
      border: 1px solid lightgray;
    }
  """

  template: """
    <div id="swatch">
      <content></content>
    </div>
  """

  # The color to show as a swatch.
  # TODO: Replace with @getterSetter
  @getter "color", -> @$.swatch.style.backgroundColor
  @setter "color", ( color ) ->

    # To determine whether the color is valid, we first apply white, then the
    # indicated color.
    swatch = @$.swatch
    swatchStyle = swatch.style
    swatchStyle.backgroundColor = "white"
    swatchStyle.backgroundColor = color
    
    
    colorValid = switch color
      when ""
        false  # Empty color value shows the invalid style.
      when "white", "rgb( 255, 255, 255 )"
        true  # White color values are known to be good.
      else        
        # See if the new value "stuck", or is still white.
        colorValue = swatchStyle.backgroundColor
        not ( colorValue is "white" or colorValue is "rgb( 255, 255, 255 )" )
    # TODO: Use something like toggleClass
    if colorValid
      @$.swatch.classList.add "valid"
    else
      @$.swatch.classList.remove "valid"
    this

  @getter "valid", -> @$.swatch.classList.contains "valid"

  @register()
