var loadPresentation = function() {
	var presentation = localStorage.getItem('preview-string');
	var config = JSON.parse(localStorage.getItem('preview-config'));

	if (presentation) {
    document.body.innerHTML = presentation;
    document.querySelector('#impress').setAttribute('data-transition-duration', 300);
	//	document.body.className = config.surface + " " + document.body.className;
	}
};
