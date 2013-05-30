class window.SampleJson extends QuetzalElement

  template: [
    style:
      "@host":
        "*":
          color: "red"
        span:
          fontWeight: "bold"
  ,
    super: [
      img: src: "{{icon}}"
    ,
      span: [
        content: []
      ]
    ]
  ]

  @register()
