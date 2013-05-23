###
Quetzal
###

###
Sugar to allow quick creation of element properties.
###
Function::alias = ( propertyName, accessChain, sideEffect ) ->
    processChain = ( obj, propertyName, accessChain, sideEffect, value ) ->
      result = obj
      keys = accessChain.split "."
      setter = ( value isnt undefined) 
      for key, index in keys
        if index == keys.length - 1 and setter
          result[ key ] = value
          result = value
        else
          result = result[ key ]
      if setter and sideEffect?
        sideEffect.call obj, value
      result
    Object.defineProperty @prototype, propertyName,
      enumerable: true
      get: -> processChain @, propertyName, accessChain, sideEffect
      set: ( value ) -> processChain @, propertyName, accessChain, sideEffect, value

Function::getter = ( propertyName, get ) ->
  Object.defineProperty @prototype, propertyName, { get, configurable: true, enumerable: true }

Function::property = ( propertyName, sideEffect ) ->
  Object.defineProperty @prototype, propertyName,
    enumerable: true
    get: -> @._properties[ propertyName ]
    set: ( value ) ->
      @._properties[ propertyName ] = value
      sideEffect?.call @, value

Function::setter = ( propertyName, set ) ->
  Object.defineProperty @prototype, propertyName, { set, configurable: true, enumerable: true }


###
Base Quetzal element class
###
class window.QuetzalElement extends HTMLDivElement

  # This constructor is only used with Quetzal element classes which are not
  # registered via Polymer's document.register().
  constructor: ->
    # Create a basic div and turn it into an instanceof the present class.
    prototype = @.__proto__
    element = document.createElement "div"
    element.__proto__ = prototype

    # Now do our own setup.
    element.ready()

    return element

  # Holds element references.
  $: {}

  @tagForClass: ( classFn ) ->
    regexWords = /[A-Z][a-z]*/g
    words = classFn.name.match regexWords
    lowercaseWords = ( word.toLowerCase() for word in words )
    lowercaseWords.join "-"

  ready: ->

    elementClass = @constructor

    # Holds "private" properties referenced by @property.
    @_properties = {}
    
    # TODO: restore styling
    # if elementClass::hasOwnProperty "style"
    #   style = document.createElement "style"
    #   if elementClass::hasOwnProperty "style"
    #     style.innerHTML = elementClass::style
    #   root.appendChild style

    if @template?
      root = @webkitCreateShadowRoot()
      root.innerHTML = @template
      superElement = root.querySelector "super"
      if superElement?
        classDefiningTemplate = @_classDefiningTemplate elementClass
        baseClass = classDefiningTemplate.__super__.constructor
        unless baseClass?
          throw "Used <super> in #{classDefiningTemplate.name}, but couldn't find superclass."
        superInstance = new baseClass()
        superInstance.innerHTML = superElement.innerHTML
        superElement.parentNode.replaceChild superInstance, superElement
        for { name, value } in superElement.attributes
          @[ name ] = value
      for subelement in root.querySelectorAll "[id]"
        @$[ subelement.id ] = subelement
    # else if elementClass isnt QuetzalElement
    #   root = @webkitCreateShadowRoot()
    #   root.appendChild document.createElement "shadow"

    # @_wrappers[ elementClass.name ] = wrapper

    for key, value of elementClass::inherited
      @[ key ] = value

  readyCallback: ->
    # REVIEW: Why does Polymer just invoke ready?
    @ready()

  wrapper: ( elementClass ) ->
    @_wrappers[ elementClass.name ]

  # Figure out which class in the hierarchy defines a template, so we can figure
  # out which class <super> refers to.
  _classDefiningTemplate: ( elementClass ) ->
    while elementClass?
      if elementClass::hasOwnProperty "template"
        return elementClass
      elementClass = elementClass.__super__?.constructor
    null

  # Holds wrapper for each class.
  _wrappers: {}


###
Allow registration of Quetzal element classes with browser.

This defines a window global with the class' name. If the class is already
global, this will *redefine* the global class to point to the registered class.
When using Polymer's document.register() polyfill, the registered class is a
munged version of the original. Assertions about instanceof should remain true
even after munging, however.
###
Function::register = ->
  originalClass = @
  className = originalClass.name
  tag = QuetzalElement.tagForClass originalClass
  registeredClass = document.register tag,
    prototype: originalClass::
  # The registered class wraps the original class. Copy public class methods
  # from the original to the wrapped class, and forward the implementations.
  for own methodName, originalImplementation of originalClass when methodName[0] != "_"
    registeredClass[ methodName ] = originalImplementation
  window[ className ] = registeredClass

# Register <quetzal> as an element class
QuetzalElement.register()
