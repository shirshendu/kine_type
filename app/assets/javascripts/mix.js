'use strict';

var wavesurfer = Object.create(WaveSurfer);

document.addEventListener('DOMContentLoaded', function () {
  wavesurfer.init({
    container: document.querySelector('#waveform'),
    waveColor: 'violet',
    scrollParent: true,
    normalize: true,
    progressColor: 'purple',
    loaderColor  : 'purple',
    cursorColor  : 'navy',
    minimap      : true,
  });

  wavesurfer.load('1.mp3');
  wavesurfer.enableDragSelection({
    color: randomColor(0.1)
  });
  wavesurfer.initMinimap({
    height: 30,
    waveColor: '#ddd',
    progressColor: '#999',
    cursorColor: '#999'
  });

  wavesurfer.on('ready', function () {
    if (localStorage.regions) {
      loadRegions(JSON.parse(localStorage.regions));
    } else {
      wavesurfer.util.ajax({
        responseType: 'json',
        url: 'annotations.json'
      }).on('success', function (data) {
        loadRegions(data);
        saveRegions();
      });
    }
  });

  /* Timeline plugin */
  wavesurfer.on('ready', function () {
    var timeline = Object.create(WaveSurfer.Timeline);
    timeline.init({
      wavesurfer: wavesurfer,
      container: "#wave-timeline"
    });
  });
  wavesurfer.on('region-click', function (region, e) {
    e.stopPropagation();
    // Play on click, loop on shift click
    e.shiftKey ? region.playLoop() : region.play();
  });
  wavesurfer.on('region-click', editAnnotation);
  wavesurfer.on('region-updated', saveRegions);
  wavesurfer.on('region-removed', saveRegions);
  wavesurfer.on('region-in', showNote);
  wavesurfer.on('region-play', function (region) {
    region.once('out', function () {
      wavesurfer.play(region.start);
      wavesurfer.pause();
    });
  });
});

function randomColor(alpha) {
  return 'rgba(' + [
    ~~(Math.random() * 255),
    ~~(Math.random() * 255),
    ~~(Math.random() * 255),
    alpha || 1
  ] + ')';

}
function editAnnotation (region) {
  var form = document.forms.edit;
  form.style.opacity = 1;
  form.elements.start.value = Math.round(region.start * 10) / 10,
  form.elements.end.value = Math.round(region.end * 10) / 10;
  form.elements.note.value = region.data.note || '';
  form.onsubmit = function (e) {
    e.preventDefault();
    region.update({
      start: form.elements.start.value,
      end: form.elements.end.value,
      data: {
        note: form.elements.note.value
      }
    });
    form.style.opacity = 0;
  };
  form.onreset = function () {
    form.style.opacity = 0;
    form.dataset.region = null;
  };
  form.dataset.region = region.id;
}

function saveRegions() {
  localStorage.regions = JSON.stringify(
    Object.keys(wavesurfer.regions.list).map(function (id) {
    var region = wavesurfer.regions.list[id];
    return {
      start: region.start,
      end: region.end,
      data: region.data
    };
  })
  );
}

function loadRegions(regions) {
  regions.forEach(function (region) {
    region.color = randomColor(0.1);
    wavesurfer.addRegion(region);
  });
}

function showNote (region) {
  if (!showNote.el) {
    showNote.el = $('#subtitle');
  }
  showNote.el.html(region.data.note || '–');
}

GLOBAL_ACTIONS['delete-region'] = function () {
  var form = document.forms.edit;
  var regionId = form.dataset.region;
  if (regionId) {
    wavesurfer.regions.list[regionId].remove();
    form.reset();
  }
};

GLOBAL_ACTIONS['export'] = function () {
  window.open('data:application/json;charset=utf-8,' +
              encodeURIComponent(localStorage.regions));
};

