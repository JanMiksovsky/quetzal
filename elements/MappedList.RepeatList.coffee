class MappedList extends RepeatList

  # TODO: Inherit style
  style: """
    :not(style) {
      display: block;
    }
  """

  @getter "count", -> @children?.length

  @getter "increment", -> false

  contentForNthElement: ( index ) ->
    contentElement = document.createElement "content"
    contentElement.select = ":nth-child(#{index + 1})"
    contentElement

  ready: ->
    super()
    # @addEventListener "contentChanged", ( event ) =>
    #   debugger

  @register()
