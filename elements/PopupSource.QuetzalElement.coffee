class PopupSource extends QuetzalElement

  template: [
    quetzal_popup: id: "popup", content: [
      content: select: "property[name='popup']"
    ]
  ,
    div: id: "container", content: [
      content: []
    ]
  ]

  open: -> @$.popup.open()

  # Position the popup with respect to the content. By default, this will
  # position the popup below the content if the popup will fit on the page,
  # otherwise show the popup above the content. Similarly, align the popup with
  # the content's left edge if the popup will fit on the page, otherwise right-
  # align it.
  # 
  # Subclasses can override this for custom positioning.
  positionPopup: ->

    console?.log "positionPopup"
    # offset = @offset()
    # position = @position()
    top = @offsetTop # Math.round offset.top
    left = @offsetLeft # Math.round offset.left
    height = @offsetHeight # @outerHeight()
    width = @offsetWidth # @outerWidth()
    bottom = top + height
    right = left + width
    # $popup = @$PopupSource_popup()
    popup = @$.popup
    popupHeight = popup.offsetHeight # $popup.outerHeight true
    popupWidth = popup.offsetWidth # $popup.outerWidth true
    # TODO: account for scrolling
    # scrollTop = $( document ).scrollTop()
    # scrollLeft = $( document ).scrollLeft()
    # windowHeight = $( window ).height()
    # windowWidth = $( window ).width()
    scrollTop = 0
    scrollLeft = 0
    viewportHeight = window.innerHeight
    viewportWidth = window.innerWidth
    
    # Vertically position below (preferred) or above the content.
    popupFitsBelow = ( bottom + popupHeight <= viewportHeight + scrollTop )
    popupFitsAbove = ( top - popupHeight >= scrollTop )
    popupAppearsBelow = ( popupFitsBelow or not popupFitsAbove )

    popupTop = if popupAppearsBelow
      "" # Use default top
    else
      top - popupHeight # Show above content
    
    # Horizontally left (preferred) or right align w.r.t. content.
    popupFitsLeftAligned = ( left + popupWidth <= viewportWidth + scrollLeft )
    popupFitsRightAligned = ( right - popupWidth >= scrollLeft )
    popupAlignLeft = ( popupFitsLeftAligned or not popupFitsRightAligned )

    popupLeft = if popupAlignLeft
      "" # Use default left
    else
      left + width - popupWidth # Right align

    popup.style.top = popupTop
    popup.style.left = popupLeft
    classList = popup.classList
    classList.toggle "popupAppearsAbove", not popupAppearsBelow
    classList.toggle "popupAppearsBelow", popupAppearsBelow
    classList.toggle "popupAlignLeft", popupAlignLeft
    classList.toggle "popupAlignRight", not popupAlignLeft
    
  ready: ->
    super()
    @$.container.addEventListener "click", =>
      console?.log "open"
      @open()
    @$.popup.addEventListener "closed", => console?.log "close"
    @$.popup.addEventListener "canceled", => console?.log "cancel"
    @$.popup.positionPopup = => @positionPopup()

  @register()
