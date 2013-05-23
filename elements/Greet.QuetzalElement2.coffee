class window.Greet extends QuetzalElement2
  template: "Hello, <content></content>."
  @property "punctuation", ( punctuation ) ->
    console?.log "set punctuation: #{punctuation}"

class window.EmphaticGreet extends Greet
  template: """
    <super punctuation='!'>*<content></content>*</super>
  """
