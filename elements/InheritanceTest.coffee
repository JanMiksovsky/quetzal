class window.InheritanceTest extends HTMLDivElement

  constructor: ->
    prototype = @.__proto__
    div = document.createElement "div"
    div.__proto__ = prototype
    return div
