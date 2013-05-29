class TestElement extends QuetzalElement

  template: """
    <quetzal-button><content select=":nth-child(1)"></content></quetzal-button>
    <quetzal-button><content select=":nth-child(2)"></content></quetzal-button>
    <quetzal-button><content select=":nth-child(3)"></content></quetzal-button>
    <quetzal-button><content select=":nth-child(4)"></content></quetzal-button>
    <quetzal-button><content select=":nth-child(5)"></content></quetzal-button>
  """

  @register()
