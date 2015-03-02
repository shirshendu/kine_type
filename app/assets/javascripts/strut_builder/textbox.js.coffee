window.StrutBuilder ||= {}

StrutBuilder.Textbox = {}

StrutBuilder.Textbox.build = (data, i) ->
  {
    TextBox: {}, 
    x: 341,
    y: 65 * (i+1),
    scale: {"x":1, "y":1},
    type: "TextBox",
    text: "<font data-position=\"" + data.position + "\" data-animation=\"" + data.animation + "\" data-duration=\"" + data.duration + "\">" + data.text + "</font>",
    size: 72,
    selected:false
  }
