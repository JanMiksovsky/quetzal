###
Render the element's inner HTML, accounting for (at most) one shadow subtree and
any <content> nodes.
This utility function is provided primarily for unit testing.
###
QuetzalElement.innerHTML = ( element ) ->
  root = element.webkitShadowRoot ? element
  @outerHTML root.childNodes

###
Render the element's outer HTML. See notes at innerHTML.
###
QuetzalElement.outerHTML = ( element ) ->
  switch element.constructor
    when Array, NodeList
      ( @outerHTML item for item in element ).join ""
    when Text
      element.textContent
    when HTMLContentElement
      @outerHTML element.getDistributedNodes()
    else
      nodeName = element.nodeName.toLowerCase()
      attributes = ( for attribute in element.attributes
        " #{attribute.name}=\"#{attribute.value}\""
      ).join ""
      openTag = "<#{nodeName}#{attributes}>"
      closeTag = "</#{nodeName}>"
      innerHTML = @innerHTML element
      "#{openTag}#{innerHTML}#{closeTag}"