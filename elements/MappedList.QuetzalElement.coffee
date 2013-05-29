class MappedList extends RepeatedList

  style: """
    @host {
      * {
        display: block;
      }
    }
  """
  
  @getter "count", -> @children?.length

  @getter "increment", -> false

  contentForNthElement: ( index ) ->
    "<content select=':nth-child(#{index + 1})'></content>"

  @register()
