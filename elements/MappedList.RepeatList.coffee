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
    "<content select=':nth-child(#{index + 1})'></content>"

  @register()
