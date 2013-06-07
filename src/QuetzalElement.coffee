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
class QuetzalElement extends HTMLDivElement

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

  # Parse the given "json" dictionary as a template for the present element.
  # If any occurrence of "super" is found, create an instance of the indicated
  # element class' superclass; give the super-instance's properties to the
  # present element.
  parse: ( json, elementClass ) ->
    elementClass ?= @constructor
    if json instanceof Array
      fragment = document.createDocumentFragment()
      for child in json
        fragment.appendChild @parse child, elementClass
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
        element = document.createElement tag
        if tag == "super"
          # TODO: For <super>, should properties be set as attributes?
          @_populateSuperElement element, elementClass
          target = @
        else
          target = element
        if properties instanceof Array or typeof properties == "string" 
          properties = content: properties
        for propertyName, propertyValue of properties
          if propertyName == "content"
            element.appendChild @parse propertyValue, elementClass
          else if typeof propertyValue == "string"
            target[ propertyName ] = propertyValue
          else
            target[ propertyName ] = @parse propertyValue, elementClass
        element
      else
        # No keys
        null

  # Utility that parses a JSON template and returns the resulting element.
  @parse: ( json ) ->
    element = new QuetzalElement()
    parsed = element.parse [ json ]
    parsed.childNodes[0]

  # Initialize a new Quetzal element.
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

    if @template?
      @_createShadowWithTemplate @, @constructor

    # Set inherited properties defined by base class(es).
    @[ key ] = value for key, value of @inherited

    # Extract properties from the element attributes.
    @[ name ] = value for { name, value } in @.attributes

  # Respond to the lifecycle event.
  readyCallback: ->
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

  # Create a shadow root for the given element and populate it with the template
  # of the given element class. Any elements in the template which have IDs will
  # have automatic element references added to "this.$". N.B., the indicated
  # element will either be the same as "this" or, when instantiating <super>,
  # will be the <super> element.
  _createShadowWithTemplate: ( element, elementClass ) ->
    root = element.webkitCreateShadowRoot()
    classDefiningTemplate = @_classDefiningTemplate elementClass
    return unless classDefiningTemplate?
    template = classDefiningTemplate::template
    if typeof template == "string"
      # Markup template
      root.innerHTML = template
      superElement = root.querySelector "super"
      if superElement?
        @_populateSuperElement superElement, elementClass
        @[ name ] = value for { name, value } in superElement.attributes
    else
      # JSON template
      root.appendChild @parse template, elementClass
    CustomElements.upgradeAll root
    @_generateElementReferences root

  # Search through the indicated tree looking for elements with IDs. Automatic
  # element references for each element #foo will be added as this.$.foo.
  _generateElementReferences: ( subtree ) ->
    @$ ?= {}
    subelementsWithIds = subtree?.querySelectorAll "[id]"
    if subelementsWithIds?.length > 0
      for subelement in subelementsWithIds
        @$[ subelement.id ] = subelement

  # Create an instance of the indicated class' superclass.
  _populateSuperElement: ( element, elementClass ) ->
    baseClass = elementClass.__super__?.constructor
    unless baseClass?
      throw "The template for #{elementClass.name} uses <super>, but superclass can't be found."
    unless ( baseClass:: ) instanceof QuetzalElement
      throw "The template for #{elementClass.name} uses <super>, but only subclasses of QuetzalElement can do that."
    element.classList.add QuetzalElement.tagForClass baseClass
    @_createShadowWithTemplate element, baseClass


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


# Implements a hypothetical <super> element.
# This can be used within a template to fill in something that looks like an
# instance of the element's base class, but without the overhead or
# complexity of actually instantiating the base class.
class Super extends QuetzalElement
  @register()

# Implements a hypothetical <property> element.
class Property extends QuetzalElement
  @register()
