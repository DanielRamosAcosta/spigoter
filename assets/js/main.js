$(function() {
	$(".button-collapse").sideNav();

	var $root = $('html, body');
	$('a').click(function() {
		var href = $.attr(this, 'href');
		$root.animate({
			scrollTop: $(href).offset().top
		}, 300, function () {
			window.location.hash = href;
		});
		return false;
	});

	var maxheight = 0;
	if( $("#card-compile").height() > maxheight )
		maxheight = $("#card-compile").height();

	if( $("#card-start").height() > maxheight )
		maxheight = $("#card-start").height();

	if( $("#card-update").height() > maxheight )
		maxheight = $("#card-update").height();

	$("#card-compile").height(maxheight);
	$("#card-start").height(maxheight);
	$("#card-update").height(maxheight);

	$.get("github.com/DanielRamosAcosta/spigoter/releases/latest", function(data) {
		console.log(data);
	});
});