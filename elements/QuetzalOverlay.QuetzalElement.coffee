###
An element that covers the entire viewport, typically to swallow clicks.
###

class window.QuetzalOverlay extends QuetzalElement

  template: [
    style: """
      @host {
        * {
          background: black;
          bottom: 0;
          cursor: default;
          left: 0;
          opacity: 0.25;
          position: fixed;
          right: 0;
          top: 0;
        }
      }
    """
  ]

  # inherited:
  #   generic: true

  # The target of the overlay is the element which will end up visually
  # in front of the overlay.
  # 
  # Setting the target adds the overlay to the DOM (or moves it, if already
  # in the DOM) to come before the target element. The result of this is that
  # the overlay will sit visually behind the target.
  # 
  # If there are elements with a z-index in the same stacking context as the
  # target, the target should also have a z-index applied to it. The
  # overlay will pick up this same z-index. As long as the target element
  # visually appears in front of the other elements, so too will the overlay.
  @property "target", ( target ) ->
    
    if target is null
      # Clearing target; nothing to do right now.
      return
    targetZIndex = parseInt target.style.zIndex
    
    if targetZIndex
      # Overlay gets same z-index as target.
      @style.zIndex = targetZIndex

    target.parentNode.insertBefore @, target

  @register()
