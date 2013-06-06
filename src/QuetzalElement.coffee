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

# Polyfill for Function.name
unless Function::name?
  Object.defineProperty Function::, "name",
    get: ->
      /function\s+([^\( ]*)/.exec( @toString() )[1]

Function::property = ( propertyName, sideEffect, defaultValue, converter ) ->
  Object.defineProperty @prototype, propertyName,
    enumerable: true
    get: ->
      result = @._properties[ propertyName ]
      if result is undefined
        defaultValue
      else
        result
    set: ( value ) ->
      result = if converter
        converter.call @, value
      else
        value
      @._properties[ propertyName ] = result
      sideEffect?.call @, result

Function::propertyBool = ( propertyName, sideEffect, defaultValue ) ->
  @property propertyName, sideEffect, defaultValue, ( value ) ->
      String( value ) == "true"

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

  # Return a new instance of a class supplied as one of the following:
  # * a string name of a global JavaScript class: "FooElement"
  # * a string name of an element class: "foo-element", "div", etc.
  # * a JavaScript class: FooElement
  @create: ( elementClass ) ->
    if elementClass instanceof Function
      # An actual JavaScript class
      classFn = elementClass
    else if typeof elementClass == "string"
      # Either the name of an element or a JavaScript class.
      if CustomElements.registry[ elementClass ]?
        # Registered element class
        tag = elementClass
      else if elementClass.indexOf( "-" ) >= 0
        if CustomElements.registry[ elementClass ]?
          # Element class name with hyphen
          tag = elementClass
      else if window[ elementClass ]?
        # Name of a global JavaScript class
        classFn = window[ elementClass ]
      else
        # Assume its an element class
        tag = elementClass

    if classFn?
      tagForClass = QuetzalElement.tagForClass classFn
      if CustomElements.registry[ tagForClass ]?
        # Prefer using the class' registered tag.
        tag = tagForClass

    if tag?    
      # Create as named element.
      newElement = document.createElement tag
    else if classFn?
      # Invoke constructor directly.
      newElement = new classFn()
      if classFn.name?.length > 0
        # Add class name as a CSS class to simplify debugging.
        newElement.classList.add classFn.name
    else
      throw "QuetzalElement.create(): invalid class"

    newElement

  # Return the element (and children) represented by the given template JSON.
  # If any occurrence of "super" is found, create an instance of the indicated
  # element class' superclass; give the super-instance's properties to the
  # indicated logical parent element.
  @parse: ( json, elementClass, logicalParent ) ->
    if json instanceof Array
      fragment = document.createDocumentFragment()
      for child in json
        fragment.appendChild @parse child, elementClass, logicalParent
      fragment
    else if typeof json == "string"
      document.createTextNode json
    else
      # Plain object
      keys = Object.keys json
      if keys.length > 0
        tag = keys[ 0 ]
        properties = json[ tag ]
        # Convert underscores to hyphens (which aren't allowed in plain JSON keys).
        tag = tag.replace "_", "-"
        element = if tag == "super"
          @_createSuperInstanceForElement elementClass, logicalParent
        else
          document.createElement tag
        if properties instanceof Array or typeof properties == "string" 
          properties = content: properties
        for propertyName, propertyValue of properties
          if propertyName == "content"
            element.appendChild @parse propertyValue, elementClass, logicalParent
          else if typeof propertyValue == "string"
            element[ propertyName ] = propertyValue
          else
            element[ propertyName ] = @parse propertyValue, elementClass, logicalParent
        element
      else
        # No keys
        null

  ready: ->

    # Initialize per-element data.
    @$ = {}             # Holds element references.
    @_properties = {}   # "private" properties referenced by @property.

    # Wire up the contentChanged event.
    # REVIEW: The class should have some way of indicating it actually wants
    # to consume this event so we don't create unnecessary observers.
    # TODO: How to stop listening?
    observer = new MutationObserver =>
      event = document.createEvent "CustomEvent"
      event.initCustomEvent "contentChanged", false, false, null
      @dispatchEvent event
    observer.observe @,
      characterData: true
      childList: true
      subtree: true

    @_createShadow @template if @template?

    # Set inherited properties defined by base class(es).
    @[ key ] = value for key, value of @inherited

    # Extract properties from the element attributes.
    @[ name ] = value for { name, value } in @.attributes

  readyCallback: ->
    # REVIEW: Why does Polymer just invoke readyCallback?
    @ready()

  @tagForClass: ( classFn ) ->
    return null unless classFn.name
    regexWords = /[A-Z][a-z]*/g
    words = classFn.name.match regexWords
    lowercaseWords = ( word.toLowerCase() for word in words )
    lowercaseWords.join "-"

  # Replace the element with a new one of the indicated class, moving the
  # existing element's content over to the new element. Return the new element.
  @transmute: ( oldElement, newClass ) ->
    newElement = QuetzalElement.create newClass
    # Move the content to the new element.
    while oldElement.childNodes.length > 0
      newElement.appendChild oldElement.childNodes[0]
    # Swap the new element in for the old one.
    oldElement.parentNode.replaceChild newElement, oldElement
    newElement

  transmute: ( newClass ) ->
    QuetzalElement.transmute @, newClass

  # Figure out which class in the hierarchy defines a template, so we can figure
  # out which class <super> refers to.
  _classDefiningTemplate: ( elementClass ) ->
    while elementClass?
      if elementClass::hasOwnProperty "template"
        return elementClass
      elementClass = elementClass.__super__?.constructor
    null

  @_copyWithShadow: ( source ) ->
    target = source.cloneNode true
    target.__proto__ = source.__proto__
    if source.webkitShadowRoot?
      target.webkitCreateShadowRoot()
      sourceShadowRoot = source.webkitShadowRoot
      while sourceShadowRoot.childNodes[0]
        target.webkitShadowRoot.appendChild sourceShadowRoot.childNodes[0]
    target

  # Create the shadow DOM and populate it.
  _createShadow: ( template ) ->
    root = @webkitCreateShadowRoot()
    elementClass = @constructor
    classDefiningTemplate = @_classDefiningTemplate elementClass
    if typeof @template == "string"
      # Markup template
      root.innerHTML = @template
      CustomElements.upgradeAll root
      superNode = root.querySelector "super"
      if superNode?
        superInstance = QuetzalElement._createSuperInstanceForElement classDefiningTemplate, @
        # Move contents
        while superNode.childNodes[0]?
          superInstance.appendChild superNode.childNodes[0]
        for { name, value } in superNode.attributes
          @[ name ] = value
        superNode.parentNode.replaceChild superInstance, superNode
    else
      # JSON template
      root.appendChild QuetzalElement.parse @template, classDefiningTemplate, @
      CustomElements.upgradeAll root
    @_generateElementReferences root

  # Create an instance of the indicated class' superclass.
  @_createSuperInstanceForElement: ( elementClass, element ) ->
    baseClass = elementClass.__super__.constructor
    unless baseClass?
      throw "The template for #{elementClass.name} uses <super>, but superclass can't be found."
    superInstance = QuetzalElement.create baseClass
    # The target element acquires the super-instance's per-element data.
    # element.$ = superInstance.$
    # element._properties = superInstance._properties
    # return superInstance
    clone = QuetzalElement._copyWithShadow superInstance
    element._generateElementReferences clone.webkitShadowRoot
    element._properties = superInstance._properties
    clone

  _generateElementReferences: ( subtree ) ->
    @$ ?= {}
    subelementsWithIds = subtree?.querySelectorAll "[id]"
    if subelementsWithIds?.length > 0
      for subelement in subelementsWithIds
        @$[ subelement.id ] = subelement


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
