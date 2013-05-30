class RepeatList extends QuetzalElement

  styles: """
    :not(style) {
      display: block;
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
    textNode = document.createTextNode()
    textNode.textContent = @repeatcontent ? @itemclass?.name ? @itemclass
    textNode

  @property "repeatcontent", -> @_refresh()

  # TODO: Give elements like this one a way to force creation of shadow root.
  template: []

  _refresh: ->
    count = parseInt @count
    itemclass = @itemclass
    return unless count? and itemclass?
    @_emptyShadowRoot()
    for index in [ 0 .. count-1 ]
      element = QuetzalElement.create itemclass
      contentElement = @contentForNthElement index
      if @increment
        contentElement.textContent += " #{index + 1}"

      # child = @.children[ index ]
      # if child?
      #   observer = new MutationObserver ( event ) =>
      #     event = document.createEvent "CustomEvent"
      #     event.initCustomEvent "contentChanged", false, false, null
      #     contentElement.dispatchEvent event
      #   observer.observe child,
      #     characterData: true
      #     childList: true
      #     subtree: true

      element.appendChild contentElement
      @webkitShadowRoot.appendChild element

  _emptyShadowRoot: ->
    # Remove everything but the <style> node in the 0th position.
    while @webkitShadowRoot.childNodes[1]?
      @webkitShadowRoot.childNodes[1].remove()

  @register()
