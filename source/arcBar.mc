using Toybox.Application;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;

class arcBar extends Ui.Drawable {
	hidden const STYLE_GUTTER = 0;
	hidden const STYLE_LIMITS = 1;
	hidden const STYLE_BARE = 2;
	hidden const BAR_LENGTH_DEG = 90;
	hidden const LIMITS_LENGTH_DEG = 3;

	hidden var location;
	hidden var total = 100;
	hidden var completed = 0;
	
	function initialize(params) {
		Drawable.initialize(params);
		location = params.get(:location);
	}
	
	function draw(dc) {
		var app = Application.getApp();
		var style = app.getProperty("BarStyle");
		var width = app.getProperty("BarWidth");
		var centreX = dc.getWidth()/2;
		var centreY = dc.getHeight()/2;
		var radius = calcRadius(dc, width);

		// default for left bar:
		var barStart = 180 + BAR_LENGTH_DEG/2;
		var barDir = Graphics.ARC_CLOCKWISE;
		var dirSign = -1;
		if (location == 1) { // right bar
			barStart = 360 - BAR_LENGTH_DEG/2;
			barDir = Graphics.ARC_COUNTER_CLOCKWISE;
			dirSign = 1;
		}  
		var barEnd = barStart + (dirSign * BAR_LENGTH_DEG);
		
		dc.setPenWidth(width);

		if (style == STYLE_GUTTER && completed < total) {
			// draw gutter background
			var bgColor = app.getProperty("BarBackgroundColor");
			dc.setColor(bgColor, Graphics.COLOR_BLACK);
			dc.drawArc(centreX, centreY, radius, barDir, barStart, barEnd);
		}
		
		if (completed >= total) {
			// draw complete bar
			var fgColor = app.getProperty("BarForegroundColorComplete");
			dc.setColor(fgColor, Graphics.COLOR_BLACK);
			dc.drawArc(centreX, centreY, radius, barDir, barStart, barEnd);
		} else {
			// draw incomplete bar
			var completedLengthDeg = BAR_LENGTH_DEG * completed/total;
			if (completedLengthDeg > 0) {
				var fgColor = app.getProperty("BarForegroundColorIncomplete");
				dc.setColor(fgColor, Graphics.COLOR_BLACK);
				dc.drawArc(centreX, centreY, radius, barDir, barStart, barStart + (dirSign * completedLengthDeg));
			}
		}
		
		if (style == STYLE_LIMITS) {
			// draw limits
			var bgColor = app.getProperty("BarBackgroundColor");
			dc.setColor(bgColor, Graphics.COLOR_BLACK);
			dc.drawArc(centreX, centreY, radius, barDir, barStart, barStart + (dirSign * LIMITS_LENGTH_DEG));
			dc.drawArc(centreX, centreY, radius, barDir, barEnd - (dirSign * LIMITS_LENGTH_DEG), barEnd);
		}
	}
	
	function setTotalAndCompleted(newTotal, newCompleted) {
		total = newTotal;
		completed = newCompleted;
	}
	
	hidden function calcRadius(dc, barWidth) {
		var radius = 0;
		var width = dc.getWidth();
		var height = dc.getHeight();		
		if (width < height) {
			radius = width/2 - barWidth;
		} else {
			radius = height/2 - barWidth;
		}
		return radius;
	}
}
