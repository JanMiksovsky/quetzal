class DemoTile extends QuetzalElement

  template: [
    style: """
      @host {
        * {
          color: #444;
          font-size: 0.9em;
        }
      }

      #container {
        display: inline-block;
        max-width: 300px;
        vertical-align: top;
      }

      h3 {
        border-top: 2px solid gray;
        color: black;
        font-size: 1.2em;
        padding-top: 0.5em;
      }

      #code {
        margin: 0;
        white-space: pre-wrap;
        word-wrap: break-word;
      }
    """
  ,
    div: id: "container", content: [
      h3: [
        markup_tag: [
          content: select: "property[name='classname']"
        ]
      ]
    ,
      p: [
        content: select: "property[name='description']"
      ]
    ,
      content: select: "property[name='demo']"
    ,
      pre: id: "code"
    ]
  ]

  ready: ->
    super()
    @addEventListener "contentChanged", ( event ) =>
      @_showDemoCode()
    @_showDemoCode()

  _showDemoCode: ->
    demo = @querySelector "property[name='demo']"
    @$.code.textContent = demo?.innerHTML ? ""

  @register()
