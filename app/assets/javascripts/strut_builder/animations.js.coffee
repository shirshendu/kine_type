window.StrutBuilder ||= {}

StrutBuilder.Animations = {}

StrutBuilder.Animations.entrances = [
  'bounceIn',
  'bounceInDown',
  'bounceInLeft',
  'bounceInRight',
  'bounceInUp',

  'fadeIn',
  'fadeInDown',
  'fadeInDownBig',
  'fadeInLeft',
  'fadeInLeftBig',
  'fadeInRight',
  'fadeInRightBig',
  'fadeInUp',
  'fadeInUpBig',

  'flipInX',
  'flipInY',

  'lightSpeedIn',

  'rotateIn',
  'rotateInDownLeft',
  'rotateInDownRight',
  'rotateInUpLeft',
  'rotateInUpRight',

  'slideInDown',
  'slideInLeft',
  'slideInRight',
  'slideInUp',

  'rollIn',

  'zoomIn',
  'zoomInDown',
  'zoomInLeft',
  'zoomInRight',
  'zoomInUp',
]

StrutBuilder.Animations.entrances.random = ->
  StrutBuilder.Animations.entrances[Math.floor(Math.random() * (StrutBuilder.Animations.entrances.length - 1))]
