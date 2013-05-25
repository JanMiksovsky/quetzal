class window.ListElement extends QuetzalElement

  @property "itemclass", ( elementClass ) ->
    # @_transmuteChildren()

  ready: ->
    super()
    # @addEventListener "contentChanged", ( event ) =>
    #   @_transmuteChildren()
    # @_transmuteChildren()

  _transmuteChildren: ->
    itemclass = @itemclass
    return unless itemclass
    children = @childNodes
    for child, index in children
      # child = document.createElement "div"
      # if elementClass?
      #   new elementClass child
      # child.innerHTML = item
      # wrapper.appendChild child
      QuetzalElement.transmute children[ index ], itemclass

  @register()
