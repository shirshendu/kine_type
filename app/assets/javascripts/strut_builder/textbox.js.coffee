window.StrutBuilder ||= {}

StrutBuilder.Textbox = {}
faces = [ 'Lato', 'League Gothic, sans-serif', 'Droid Sans Mono, monospace', 'Ubuntu, sans-serif', 'Abril Fatface, cursive', 'Hammersmith One, sans-serif', 'Fredoka One, cursive', 'Gorditas, cursive', 'PressStart2P, cursive' ]
randomFace = ->
  faces[Math.floor(Math.random() * faces.length)]
StrutBuilder.Textbox.build = (data, i) ->
  face = randomFace()
  text = if Math.random() > 0.5
    '<b>' + data.text + '</b>'
  else
    data.text
  text = if Math.random() > 0.5
    '<i>' + text + '</i>'
  else
    text
  loop
    color = tinycolor('hsl(0,0.9,0.3)').spin(Math.floor(Math.random() * 360))
    break if color.isDark()
  {
    TextBox: {}, 
    x: 341,
    y: 65 * (i+1),
    scale: {"x":1, "y":1},
    type: "TextBox",
    text: "<font data-position=\"" + data.position + "\" data-animation=\"" + data.animation + "\" data-duration=\"" + data.duration + "\" color='" + color.toHex() + "' face='" + face + "'>" + data.text + "</font>",
    size: 72,
    selected:false
  }
