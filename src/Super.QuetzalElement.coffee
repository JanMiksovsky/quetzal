# Implements a hypothetical <super> element.
# This can be used within a template to fill in something that looks like an
# instance of the element's base class, but without the overhead or
# complexity of actually instantiating the base class.
class Super extends QuetzalElement
  @register()
