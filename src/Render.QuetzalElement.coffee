###
Rendering functions, primarily for unit testing.
These handle shadow subtrees and <content> nodes.
###

QuetzalElement.outerHTML = ( element ) ->
  if element instanceof Array or element instanceof NodeList
    ( QuetzalElement.outerHTML item for item in element ).join ""
  else if element instanceof Text
    element.textContent
  else
    nodeName = element.nodeName.toLowerCase()
    attributes = ( for attribute in element.attributes
      " #{attribute.name}=\"#{attribute.value}\""
    ).join ""
    openTag = "<#{nodeName}#{attributes}>"
    closeTag = "</#{nodeName}>"
    innerHTML = QuetzalElement.innerHTML element
    "#{openTag}#{innerHTML}#{closeTag}"

QuetzalElement.innerHTML = ( element ) ->
  target = element.webkitShadowRoot ? element
  results = ( for child in target.childNodes
    if child instanceof Text
      child.textContent
    else if child instanceof HTMLContentElement
      QuetzalElement.outerHTML child.getDistributedNodes()
    else
      QuetzalElement.outerHTML child
  )
  results.join ""
