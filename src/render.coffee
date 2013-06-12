###
Render the element's inner HTML, accounting for (at most) one shadow subtree and
any <content> nodes.
This utility function is provided primarily for unit testing.
###
QuetzalElement.innerHTML = ( element ) ->
  root = element.webkitShadowRoot ? element
  @outerHTML root.childNodes

###
Render the element's outer HTML.
###
QuetzalElement.outerHTML = ( element ) ->
  if element instanceof Array or element instanceof NodeList
    ( @outerHTML item for item in element ).join ""
  else if element instanceof Text
    element.textContent
  else if element instanceof HTMLContentElement
    @outerHTML element.getDistributedNodes()
  else if element instanceof HTMLShadowElement
    @outerHTML ( element.olderShadowRoot ? element.childNodes )
  else if element instanceof DocumentFragment
    @outerHTML element.childNodes
  else
    nodeName = element.nodeName.toLowerCase()
    attributes = ( for attribute in element.attributes
      " #{attribute.name}=\"#{attribute.value}\""
    ).join ""
    openTag = "<#{nodeName}#{attributes}>"
    closeTag = "</#{nodeName}>"
    innerHTML = @innerHTML element
    "#{openTag}#{innerHTML}#{closeTag}"
