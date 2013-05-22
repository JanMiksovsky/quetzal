class window.QuetzalElement2 extends HTMLElement

  constructor: ( element ) ->

    elementClass = @constructor

    # Make element become an "instanceof" the desired class.
    element.__proto__ = elementClass::

    if elementClass::hasOwnProperty "template"
      root = element.webkitCreateShadowRoot()
      root.innerHTML = elementClass::template
      for superElement in root.querySelectorAll "super"
        baseClass = elementClass.__super__.constructor
        upgraded = document.createElement "div"
        upgraded.innerHTML = superElement.innerHTML
        new baseClass upgraded
        superElement.parentNode.replaceChild upgraded, superElement
