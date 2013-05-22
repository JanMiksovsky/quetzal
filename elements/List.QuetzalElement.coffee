class window.List extends QuetzalElement

  @property "elementClass", ( elementClass ) ->
    @_render()

  @property "items", ( items ) ->
    @_render()

  @register()

  _render: ->
    return unless @items
    wrapper = @wrapper List
    for child in wrapper.children
      wrapper.removeChild child
    elementClass = @elementClass
    for item in @items
      child = document.createElement "div"
      if elementClass?
        new elementClass child
      child.innerHTML = item
      wrapper.appendChild child
