loadPpt = ->
  pptData = StrutBuilder.build(JSON.parse(localStorage.regions))
    #[
      #{ #slide 1
        #start: 0,
        #end: 2.5,
        #texts: [
                 #{text: 'Hum', position: 1.2},
                 #{text: 'bewafaa', position: 1.7}
               #]
      #},
      #{ #slide 2
        #start: 2.5,
        #end: 4.3,
        #texts: [
                 #{text: 'Hargiz', position: 3.3},
                 #{text: 'na they', position: 3.8}
               #]
      #}
    #]
  localStorage['strut-presentation-unnamed.strut'] = JSON.stringify(pptData)
  $('#editor').attr('src', '/editor/')

$ ->
  $('#ppt-loader').on 'click', loadPpt
