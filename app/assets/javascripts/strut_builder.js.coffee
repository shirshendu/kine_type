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
  slidesdata = (slide for slide in data when slide.data.type == 'segment')
  itemdata = (item for item in data when item.data.type == 'segment_item')
  for slidedata in slidesdata
    items = for item, i in itemdata when (slidedata.start <= item.start and item.start < slidedata.end)
      text: item.data.note
      position: item.start
      animation: StrutBuilder.Animations.entrances.random()
      duration: if itemdata[i + 1] then (itemdata[i+1].start - itemdata[i].start - 0.2) else (slidedata.end - itemdata[i].start - 0.3)
    slidedata.texts = items

  bgs = []
  slides = for slide, i in slidesdata
    StrutBuilder.Slide.build(slide, i, bgs)
  {
    slides: slides,
    activeSlide: slides[0],
    fileName: 'presentation-unnamed',
    customStylesheet: '',
    deckVersion: '1.0',
    customBackgrounds: { bgs: bgs }
  }
