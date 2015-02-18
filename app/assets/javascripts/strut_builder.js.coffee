window.StrutBuilder ||= {}

# [
#   { #slide 1
#     start: 0,
#     end: 2.5,
#     texts: [
#              {text: 'Hum', position: 1.2},
#              {text: 'bewafaa', position: 1.7}
#            ]
#   },
#   { #slide 2
#     start: 2.5,
#     end: 4.3,
#     texts: [
#              {text: 'Hargiz', position: 3.3},
#              {text: 'na they', position: 3.8}
#            ]
#   }
# ]
StrutBuilder.build = (data) ->
  slides = for slide, i  in data
    StrutBuilder.Slide.build(slide, i)
  {
    slides: slides,
    activeSlide: slides[0],
    fileName: 'presentation-unnamed',
    customStylesheet: '',
    deckVersion: '1.0',
    customBackgrounds: { bgs: [] }
  }
