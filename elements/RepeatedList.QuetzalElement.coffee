class RepeatedList extends QuetzalElement

  @property "count", -> @_refresh()

  @property "increment", -> @_refresh()

  @property "itemclass", -> @_refresh()

  ready: ->
    super()
    @increment = true

  contentForNthElement: ( index ) ->
    # TODO: Use QuetzalElement helper to turn itemclass into a class.
    @repeatContent ? @itemclass?.name ? @itemclass

  @property "repeatContent", -> @_refresh()

  # TODO: Give elements like this one a way to force creation of shadow root.
  template: ""

  _refresh: ->
    count = parseInt @count
    itemclass = @itemclass
    return unless count? and itemclass?
    @_emptyShadow()
    for i in [ 1 .. count ]
      element = QuetzalElement.create itemclass
      elementContent = @contentForNthElement i
      if @increment
        elementContent += " #{i}"
      element.textContent = elementContent
      @webkitShadowRoot.appendChild element

  _emptyShadow: ->
    while @webkitShadowRoot.childNodes[0]?
      @webkitShadowRoot.childNodes[0].remove()

  @register()
