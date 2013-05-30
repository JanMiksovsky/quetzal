class window.SampleJson extends QuetzalElement

  styles:
    "@host":
      "*":
        color: "red"
      span:
        font_weight: "bold"

  template: 
    super: [
      img: src: "{{icon}}"
    ,
      span: [
        content: []
      ]
    ]

  @register()
