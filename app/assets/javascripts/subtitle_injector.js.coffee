inject = (data) ->
  for segment in data
    wavesurfer.splitRegion(segment.startTime/1000)
    words = segment.text.split(/\n| /)
    splitTime = segment.endTime - segment.startTime
    splitItemTime = Math.round(splitTime / words.length)
    for word, i in words
      wavesurfer.setMarker((splitItemTime * i + segment.startTime)/1000, word)
  window.saveRegions()

document.addEventListener 'DOMContentLoaded', ->
  # Drag'n'Drop
  toggleActive = (e, toggle) ->
    e.stopPropagation()
    e.preventDefault()
    if toggle then e.target.classList.add('subtitle-dragover') else e.target.classList.remove('subtitle-dragover')
    return

  handlers =
    drop: (e) ->
      toggleActive e, false
      # Load the file into wavesurfer
      if e.dataTransfer.files.length
        subFileDropped = true
        reader = new FileReader()
        reader.addEventListener 'loadend', ->
          localStorage.sub = reader.result
          inject(parser.fromSrt(reader.result, true))
        reader.readAsBinaryString(e.dataTransfer.files[0].slice())
      else
        console.log 'not a file'
      return
    dragover: (e) ->
      toggleActive e, true
      return
    dragleave: (e) ->
      toggleActive e, false
      return
  dropTarget = document.querySelector('#drop-subtitles')
  Object.keys(handlers).forEach (event) ->
    dropTarget.addEventListener event, handlers[event]
    return
  return


