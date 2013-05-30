###
Placeholder image from LoremPixel.com
###

class window.LoremPixel extends QuetzalElement

  template:
    img: id: "image"

  @alias "height", "$.image.height", ( height ) ->
    @_reload()

  ready: ->
    super()
    if @$.image.src == ""
      @height = 300
      @width = 400

  @alias "width", "$.image.width", ( width ) ->
    @_reload()

  _reload: ->
    if @height > 0 and @width > 0
      @$.image.src = "http://lorempixel.com/#{@width}/#{@height}/nature"

  @register()
 