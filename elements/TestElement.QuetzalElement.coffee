class TestElement extends QuetzalElement

  template: """
    <ol>
      <li><content select="*:first"></content></li>
      <li><content select="*:first"></content></li>
      <li><content select="*:first"></content></li>
    </ol>
  """

  @register()
