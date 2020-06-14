using Toybox.WatchUi as Ui;
using Toybox.Graphics;

class arcBar extends Ui.Drawable {
	const BAR_WIDTH = 5;
	const BAR_LENGTH_DEG = 90;

	hidden var location;
	hidden var total = 100;
	hidden var completed = 45;
	
	function initialize(params) {
		Drawable.initialize(params);
		location = params.get(:location);
	}
	
	function draw(dc) {
		dc.setPenWidth(BAR_WIDTH);
		var width = dc.getWidth();
		var height = dc.getHeight();
		var radius = 0;
		if (width < height) {
			radius = width/2 - BAR_WIDTH;
		} else {
			radius = height/2 - BAR_WIDTH;
		}
		// default for left bar:
		var barStart = 180 + BAR_LENGTH_DEG/2;
		var barDir = Graphics.ARC_CLOCKWISE;
		var dirSign = -1;
		if (location == 1) { // right bar
			barStart = 360 - BAR_LENGTH_DEG/2;
			barDir = Graphics.ARC_COUNTER_CLOCKWISE;
			dirSign = 1;
		}  
		// draw bar background
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawArc(width/2, height/2, radius, barDir, barStart, barStart + (dirSign * BAR_LENGTH_DEG));

		// draw bar foreground
		var completedLengthDeg = BAR_LENGTH_DEG;
		var completedColor = Graphics.COLOR_DK_GREEN;
		if (completed < total) {
			completedLengthDeg = BAR_LENGTH_DEG * completed/total;
			completedColor = Graphics.COLOR_YELLOW; // Graphics.COLOR_LT_GRAY
		}
		dc.setColor(completedColor, Graphics.COLOR_BLACK);
		dc.drawArc(width/2, height/2, radius, barDir, barStart, barStart + (dirSign * completedLengthDeg));
	}
	
	function setTotalAndCompleted(newTotal, newCompleted) {
		total = newTotal;
		completed = newCompleted;
	}
}
