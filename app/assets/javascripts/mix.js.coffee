randomColor = (alpha) ->
  'rgba(' + [
    ~ ~(Math.random() * 255)
    ~ ~(Math.random() * 255)
    ~ ~(Math.random() * 255)
    alpha or 1
  ] + ')'

editAnnotation = (region) ->
  form = document.forms.edit
  form.classList.remove 'hide'
  form.elements.start.value = round100(region.start)
  form.elements.end.value = round100(region.end)
  form.elements.note.value = region.data.note or ''
  if region.data.type == 'segment'
    form.elements.note.setAttribute('disabled', 'disabled')
  else
    form.elements.note.removeAttribute('disabled')
  form.elements.type.value = region.data.type or ''

  form.onsubmit = (e) ->
    e.preventDefault()
    region.update
      start: form.elements.start.value
      end: form.elements.end.value
      data:
        note: form.elements.note.value
        type: form.elements.type.value
    form.classList.add 'hide'
    return

  form.onreset = ->
    form.classList.add 'hide'
    form.dataset.region = null
    return

  form.dataset.region = region.id
  return

defaultRegionParams = { texts: [], drag: false, resize: false }

splitRegion = ->
  time = wavesurfer.getCurrentTime()
  # Assume that time is always within a region, since we initialize a region over full audio at start
  splitCandidate = getRegions(time)[0]
  wavesurfer.addRegion { start: splitCandidate.start, end: round100(time), drag: false, resize: false, data: { type: 'segment' } }
  wavesurfer.addRegion { start: round100(time), end: splitCandidate.end, drag: false, resize: false, data: { type: 'segment' } }
  wavesurfer.regions.list[splitCandidate.region_id].remove()
  saveRegions()

getRegions = (time) ->
  region for region in regionsArray() when (region.start <= time && time < region.end)

saveRegions = ->
  localStorage.regions = JSON.stringify(regionsArray())
  return

deleteRegion = ->
  form = document.forms.edit
  regionId = form.dataset.region
  deleteCandidate = wavesurfer.regions.list[regionId]
  if deleteCandidate.data.type == 'segment'
    if deleteCandidate.start == 0
      # set second's start as 0
      wavesurfer.regions.list[regionsArray()[1].region_id].update(start: 0)
    else
      # set prev's end as this end
      replacer = (region for region_id, region of wavesurfer.regions.list when round100(region.end) == round10(deleteCandidate.start))[0]
      wavesurfer.regions.list[replacer.id].update(end: deleteCandidate.end)
  if regionId
    wavesurfer.regions.list[regionId].remove()
    form.reset()
  return

setMarker = ->
  time = wavesurfer.getCurrentTime()
  wavesurfer.addRegion(start: round100(time), drag: true, resize: false, data: { type: 'segment_item' }, color: 'rgba(0,0,0,0.5)')
  saveRegions()

window.regionsArray = ->
  mapped = Object.keys(wavesurfer.regions.list).map((id) ->
    region = wavesurfer.regions.list[id]
    {
      region_id: id
      start: round100(region.start)
      end: round100(region.end)
      data: region.data
      texts: []
      drag: (if region.data.type == 'segment_item' then true else false)
      resize: false
      type: region.type
    }
  )
  mapped.sort (a,b)->
    a.start - b.start

round100 = (input) ->
  Math.round(input * 100)/100

loadRegions = (regions) ->
  regions.forEach (region) ->
    region.color = (if region.data.type == 'segment' then randomColor(0.3) else 'rgba(0,0,0,0.5)')
    wavesurfer.addRegion region
    return
  return

showNote = (region) ->
  if !showNote.el
    showNote.el = $('#subtitle')
  if region.data.type == 'segment_item'
    showNote.el.html region.data.note or '–'
  return

window.wavesurfer = Object.create(WaveSurfer)
$ ->
  wavesurfer.init
    container: document.querySelector('#waveform')
    waveColor: 'violet'
    scrollParent: true
    normalize: true
    progressColor: 'purple'
    loaderColor: 'purple'
    cursorColor: 'navy'
    minimap: true
    minPxPerSec: 100
  wavesurfer.load '1.mp3'
  wavesurfer.initMinimap
    height: 30
    waveColor: '#ddd'
    progressColor: '#999'
    cursorColor: '#999'
  wavesurfer.on 'ready', ->
    if localStorage.regions
      loadRegions JSON.parse(localStorage.regions)
    else
      wavesurfer.addRegion(start: 0, end: round100(wavesurfer.getDuration()), drag: false, resize: false, data: { type: 'segment' })
      saveRegions()
    return

  ### Timeline plugin ###

  wavesurfer.on 'ready', ->
    timeline = Object.create(WaveSurfer.Timeline)
    timeline.init
      wavesurfer: wavesurfer
      container: '#wave-timeline'
    return
  wavesurfer.on 'region-click', (region, e) ->
    if e.shiftKey
      e.stopPropagation()
      region.play()
    return
  wavesurfer.on 'region-click', editAnnotation
  #wavesurfer.on('region-dblclick', splitRegion);
  wavesurfer.on 'region-updated', saveRegions
  wavesurfer.on 'region-removed', saveRegions
  wavesurfer.on 'region-in', showNote
  wavesurfer.on 'region-play', (region) ->
    region.once 'out', ->
      wavesurfer.play region.start
      wavesurfer.pause()
      return
    return
  return

window.GLOBAL_ACTIONS['delete-region'] = ->
  deleteRegion()

window.GLOBAL_ACTIONS['split-region'] = ->
  splitRegion()

window.GLOBAL_ACTIONS['mark-word'] = ->
  setMarker()

window.GLOBAL_ACTIONS['export'] = ->
  window.open 'data:application/json;charset=utf-8,' + encodeURIComponent(localStorage.regions)
  return
