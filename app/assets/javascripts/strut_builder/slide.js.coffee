window.StrutBuilder ||= {}

StrutBuilder.Slide = {}

StrutBuilder.Slide.build = (data, i) ->
  {
    components: (StrutBuilder.Textbox.build(textdata, j) for textdata, j in data.texts),
    z: 0,
    impScale: 3,
    rotateX: 0,
    rotateY: 0,
    rotateZ: 0,
    index: i,
    selected: false,
    active: i == 0,
    x: 180 + 280 * i,
    y: 180,
    start: data.start,
    end: data.end
  }
