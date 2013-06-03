# ###
# Base class for popups, menus, dialogs, things that appear temporarily over other
# things.
# ###

class QuetzalPopup extends QuetzalElement

  template: [
    style: """
      #container {
        position: absolute;
        z-index: 1;
      }

      #container:not(.opened) {
        display: none;
      }

      /* Generic appearance */
      /* &.generic { */
      * {
        background: white;
        border: 1px solid rgba(0, 0, 0, 0.2);
        box-shadow: 0 2px 4px rgba( 0, 0, 0, 0.2 );
        box-sizing: border-box;
        padding: .25em;
        -webkit-user-select: none;
        user-select: none;
      }
    """
  ,
    div: id: "container", content: [
      content: []
    ]
  ]

#   inherited:
#     generic: true

#   # True if the user can cancel an open popup by pressing the Escape key.
#   # Default is true.
#   cancelOnEscapeKey: Control.property.bool( null, true )
  
#   # True if the popup should be canceled if the user clicks outside it.
#   # Default is true. See also the modal() property.
#   cancelOnOutsideClick: Control.property.bool( null, true )
  
#   # True if the popup should be canceled if the window loses focus.
#   # Default is true.
#   cancelOnWindowBlur: Control.property.bool( null, true )
  
#   # True if the popup should be canceled if the window changes size.
#   # Default is true.
#   cancelOnWindowResize: Control.property.bool( null, true )
  
#   # True if the popup should be canceled if the window is scrolled.
#   # Default is true.
#   cancelOnWindowScroll: Control.property.bool( null, true )
  
#   # True if the popup should be closed normally if the user clicks inside
#   # it. Default is true.
#   closeOnInsideClick: Control.property.bool( null, true )
  
#   # Cancel the popup. This is just like closing it, but raises a "canceled"
#   # event instead.
#   # 
#   # This has no effect if the popup is already closed.
#   cancel: ->
#     @_close "canceled"
  
#   # Close the popup (dismiss it). This raises a "closed" event.
#   # 
#   # This has no effect if the popup is already closed.
#   close: ->
#     @_close "closed"

  ready: ->
    super()
    @overlayclass ?= "quetzal-overlay"
    @$.container.classList.add "foo"
  
  # Open the popup (show it). This raises an "opened" event.
  # This has no effect if the popup is already opened.
  open: ->
    return if @opened
    if @overlayclass?
      @overlay = QuetzalElement.create @overlayclass
      @overlay.target = @
    # @_eventsOn()
    @opened = true
    #   .trigger("opened")
    #   .checkForSizeChange() # In case popup wants to resize anything now that it's visible.
    #   .positionPopup()      # Position the popup after the layout recalc.

  # Open the popup.
  # opened: Control.chain "applyClass/opened"

  # TODO: Make opened="true" an attribute <-----

  @getter "opened", -> @$.container.classList.contains "opened"
  @setter "opened", ( opened ) ->
    @$.container.classList.toggle "opened", opened
  
  # The overlay element behind the popup absorbing mouse clicks.
  @property "overlay"
  
  # The class used to render the overlay behind the popup. The default
  # value is the QuetzalOverlay class.
  @property "overlayclass"
  
#   # A function called to position the popup when it is opened. By default
#   # this has no effect. This can be overridden by subclasses for custom
#   # positioning.
#   positionPopup: ->
  
#   # Take care of hiding the popup, its overlay, and raising the indicated event.
#   _close: ( closeEventName ) ->
    
#     # There may be cases where this function is called more than once.
#     # As a defensive measure, we clean things up even if we think we're
#     # already closed.
#     if @_overlay()?
#       @_overlay().remove()
#       @_overlay null
#     @_eventsOff()
#     if @opened()
#       if closeEventName
#         @trigger closeEventName
#       @opened false
#     @
  
#   # Wire up events.
#   _eventsOn: ->
    
#     # Create the handlers as functions we can save in control properties.
#     handlerDocumentKeydown = (event) =>
#       if @cancelOnEscapeKey() and event.which is 27 # Escape
#         # Pressing ESC cancels popup.
#         @cancel()
#         event.stopPropagation()

#     handlerDocumentClick = (event) =>
#       outsideClick = @_isElementOutsideControl event.target
#       if outsideClick and @cancelOnOutsideClick()
#         # User clicked outside popup; implicitly cancel it.
#         @cancel()
#       else if not outsideClick and @closeOnInsideClick()
#         # User clicked inside popup; implicitly close it.
#         @close()

#     handlerWindowBlur = (event) =>
#       if @cancelOnWindowBlur()
#         # Cancel popup when window loses focus.
#         @cancel()

#     handlerWindowResize = (event) =>
#       if @cancelOnWindowResize()
#         # Cancel popup when window changes size.
#         @cancel()

#     handlerWindowScroll = (event) =>
#       outsideScroll = @_isElementOutsideControl(event.target)
#       if outsideScroll and @cancelOnWindowScroll()
#         # User scrolled outside the popup; implicitly cancel it.
#         @cancel()

#     $( document ).on "keydown", handlerDocumentKeydown
#     $( window ).on
#       blur: handlerWindowBlur
#       resize: handlerWindowResize
#       scroll: handlerWindowScroll
    
#     # Wire up document click handler in a timeout. We do this because a
#     # popup is often invoked in response to a click. That triggering
#     # click hasn't reached the document yet. If we bound the document click
#     # event right now, the triggering click would soon reach the document,
#     # immediately triggering cancelation of the popup. The use of a timeout
#     # gives the triggering click a chance to bubble all the way up to the
#     # document before we wire up the document click handler.
#     window.setTimeout( =>
#       if @opened()
#         # Don't bind event if we managed to get closed during the timeout.
#         $( document ).on "click", handlerDocumentClick
#     , 100 )
    
#     # Save references to the event handlers so we can unbind them later.
#     @_handlerDocumentClick( handlerDocumentClick )
#       ._handlerDocumentKeydown( handlerDocumentKeydown )
#       ._handlerWindowBlur( handlerWindowBlur )
#       ._handlerWindowResize( handlerWindowResize )
#       ._handlerWindowScroll( handlerWindowScroll )

#   # Unbind the event handlers we bound earlier.
#   _eventsOff: ->
    
#     # Do checks before unbinding in case this function happens to get
#     # called more than once.
#     handlerDocumentClick = @_handlerDocumentClick()
#     if handlerDocumentClick
#       $( document ).off "click", handlerDocumentClick
#       @_handlerDocumentClick null
#     handlerDocumentKeydown = @_handlerDocumentKeydown()
#     if handlerDocumentKeydown
#       $( document ).off "keydown", handlerDocumentKeydown
#       @_handlerDocumentKeydown null
#     handlerWindowBlur = @_handlerWindowBlur()
#     if handlerWindowBlur
#       $( window ).off "blur", handlerWindowBlur
#       @_handlerWindowBlur null
#     handlerWindowResize = @_handlerWindowResize()
#     if handlerWindowResize
#       $( window ).off "resize", handlerWindowResize
#       @_handlerWindowResize null
#     handlerWindowScroll = @_handlerWindowScroll()
#     if handlerWindowScroll
#       $( window ).off "scroll", handlerWindowScroll
#       @_handlerWindowScroll null
#     @
  
#   # Handler for the document click event
#   _handlerDocumentClick: Control.property()
  
#   # Handler for the keydown event
#   _handlerDocumentKeydown: Control.property()
  
#   # Handler for the window blur event
#   _handlerWindowBlur: Control.property()
  
#   # Handler for the window resize event
#   _handlerWindowResize: Control.property()
  
#   # Handler for the window scroll event
#   _handlerWindowScroll: Control.property()
  
#   # Return true if the indicated element is outside this control.
#   _isElementOutsideControl: (element) ->
#     elementIsControl = ( @index( element ) >= 0 )
#     elementInsideControl = ( $( element ).parents().filter( this ).length > 0 )
#     not elementIsControl and not elementInsideControl
  
#   # Hint for documentation tools.
#   _requiredClasses: [ "Overlay" ]

  @register()
