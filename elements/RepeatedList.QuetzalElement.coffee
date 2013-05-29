class RepeatedList extends QuetzalElement

  style: """
    @host {
      * {
        display: block;
      }
    }
  """

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
    @_emptyShadowRoot()
    for i in [ 0 .. count-1 ]
      element = QuetzalElement.create itemclass
      elementContent = @contentForNthElement i
      if @increment
        elementContent += " #{i + 1}"
      element.innerHTML = elementContent
      @webkitShadowRoot.appendChild element

  _emptyShadowRoot: ->
    # Remove everything but the <style> node in the 0th position.
    while @webkitShadowRoot.childNodes[1]?
      @webkitShadowRoot.childNodes[1].remove()

  @register()
