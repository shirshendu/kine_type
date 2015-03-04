stepCounter = 0
introOptions = {}
startIntro = ->
  intro = introJs()
  intro.setOptions(introOptions)
  intro.onafterchange (element) ->
    introOptions.steps[stepCounter].behaviour && introOptions.steps[stepCounter].behaviour()
    stepCounter++
  localStorage.clear()
  intro.start()

document.addEventListener 'DOMContentLoaded', ->
  introOptions =
    tooltipPosition: 'auto'
    steps: [
      {
        intro: 'Welcome to KineType, an online platform for creating kinetic typography.'
      },
      {
        element: '#step2',
        intro: 'Drop mp3 and subtitle files from your file manager to import them. We\'ll load a demo mp3 for you now.'
      },
      {
        element: '#step3'
        intro: 'This is the waveform of the loaded mp3.'
        behaviour: ->
          getSound = new XMLHttpRequest()
          getSound.open "GET", "snowflake_-_Holiday_Funky_Blues.mp3", true
          getSound.responseType = "blob"
          progressDiv = document.querySelector('#progress-bar')
          progressBar = document.querySelector('.progress-bar')
          getSound.onprogress = (e) ->
            if e.lengthComputable
              percentComplete = (e.loaded/e.total) * 100
              progressDiv.style.display = 'block'
              progressBar.style.width = percentComplete + '%'
          getSound.onload = (e) ->
            progressDiv.style.display = 'none'
            if(this.status == 200)
              blob = this.response
              wavesurfer.loadBlob blob
              window.inputAudio = blob
          getSound.send()
      },
      {
        element: '#waveform > wave:last-child'
        intro: 'Click here to seek anywhere in the song.'
        behaviour: ->
          wavesurfer.seekAndCenter(0.635865)
      },
      {
        element: '#waveform > wave:first-child'
        intro: 'Click here to seek in the neighbourhood of the currently playing position. Clicking on an unmarked region like this...'
        behaviour: ->
          wavesurfer.seekTo(0.652)
          $('region')[0].click()
      },
      {
        element: '#region-actions'
        intro: '...shows buttons that will you to split or merge it.'
      },
      {
        element: '#waveform > wave:first-child'
        intro: '<b>Splitting Regions:</b> Simply put, you should have one region for every sentence in the song'
        behaviour: ->
          wavesurfer.seekTo(0.635865)
          wavesurfer.splitRegion()
          wavesurfer.seekTo(0.652)
          reg = wavesurfer.splitRegion()
          reg.play()
      },
      {
        element: '#waveform > wave:first-child'
        intro: '<b>Merging Regions:</b> Upon merging, a region is combined into the region before it.'
        behaviour: ->
          wavesurfer.seekTo(0.66)
          wavesurfer.deleteRegion(wavesurfer.getRegionsAt()[0].id)
      },
      {
        element: '#btn-mark'
        intro: 'After splitting out a sentence, you would want to mark the words in it.'
        behaviour: ->
          wavesurfer.seekTo(0.652)
          window.reg = wavesurfer.splitRegion()
      },
      {
        element: '#step3'
        intro: 'Word markers are draggable. Be careful to sync the markers properly with the words.'
        behaviour: ->
          wavesurfer.seekTo(0.635962)
          wavesurfer.setMarker(undefined, 'No')
          wavesurfer.seekTo(0.64006)
          wavesurfer.setMarker(undefined, 'time')
          wavesurfer.seekTo(0.6433949)
          wavesurfer.setMarker(undefined, 'for')
          wavesurfer.seekTo(0.644408)
          wavesurfer.setMarker(undefined, 'losers')
          reg.play()
      },
      {
        element: '#ppt-loader'
        intro: 'Once done splitting regions and marking words, open the presentation editor. On repeat clicks, this will overwrite any existing slides.'
      },
      {
        element: '#editor'
        intro: 'Move around, edit, rotate, change colours of the text and backgrounds in the slides.'
        behaviour: ->
          saveRegions()
          $('#ppt-loader').click()
      },
      {
        element: '#editor'
        intro: 'Click <b>Overview</b> at top right to switch to overview mode.'
      },
      {
        element: '#editor'
        intro: 'In this mode, you can scale, move around and rotate slides in all 3 dimensions. (Think Prezi™, but in 3-D)'
        behaviour: ->
          document.querySelector('#editor').contentDocument.body.querySelector('li.mode-buttons > div:nth-child(2)').click()
      },
      {
        element: '#editor'
        intro: 'Finally, click <b>Impress</b> at top-right to generate your kinetic typography'
      }
    ]

  if(document.cookie.indexOf('skip_intro=true') == -1)
    startIntro()
  #document.cookie = 'skip_intro=true' TODO  startIntro()

