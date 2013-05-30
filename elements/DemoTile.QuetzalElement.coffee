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
        width: 300px;
        vertical-align: top;
      }

      h3 {
        border-top: 2px solid gray;
        color: black;
        font-size: 1.2em;
        padding-top: 0.5em;
      }
    """
  ,
    div: id: "container", content: [
      h3: [
        markup_tag: [
          content: select: "property"
        ]
      ]
    ,
      content: []
    ]
  ]

  @register()
