var loadPresentation = function() {
	var presentation = localStorage.getItem('preview-string');
	var config = JSON.parse(localStorage.getItem('preview-config'));

	if (presentation) {
		document.querySelector('#kine_ppt').innerHTML = presentation;
	//	document.body.className = config.surface + " " + document.body.className;
	}
};
