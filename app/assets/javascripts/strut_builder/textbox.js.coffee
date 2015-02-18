window.StrutBuilder ||= {}

StrutBuilder.Textbox = {}

StrutBuilder.Textbox.build = (data, i) ->
  {
    TextBox: {}, 
    x: 341.3333333333333, 
    y: 65 * (i+1),
    scale: {"x":1, "y":1},
    type: "TextBox",
    text: "<font>" + data.text + "</font>",
    size: 72,
    selected:false
  }
