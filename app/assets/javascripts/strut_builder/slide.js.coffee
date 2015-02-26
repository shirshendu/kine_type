window.StrutBuilder ||= {}

StrutBuilder.Slide = {}

StrutBuilder.Slide.build = (data, i, bgs) ->
  loop
    bgColor = tinycolor('hsl(0,0.6,0.8)').spin(Math.floor(Math.random() * 360))
    break if bgColor.isLight()
  surfaceColor = bgColor.complement()
  bgs.push(
    klass: 'bg-custom-' + bgColor.toHex(),
    style: bgColor.toHexString()
  )
  bgs.push(
    klass: 'bg-custom-' + surfaceColor.toHex(),
    style: surfaceColor.toHexString()
  )
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
    end: data.end,
    background: 'bg-custom-' + bgColor.toHex(),
    surface: 'bg-custom-' + surfaceColor.toHex()
  }
