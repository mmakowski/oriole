using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Time.Gregorian;

class orioleView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the time
        var timeLabel = View.findDrawableById("Time");
        timeLabel.setColor(Application.getApp().getProperty("ForegroundColor"));
        timeLabel.setText(timeString);

		// format the date
		var dayInfo = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$ $2$", [dayInfo.day_of_week, dayInfo.day]);

		// Update the bottom detail (date for now)
		var bottomDetailLabel = View.findDrawableById("BottomDetail");
		bottomDetailLabel.setText(dateString);
		
		// Update the left bar (steps for now)
		var info = ActivityMonitor.getInfo();
		var leftBar = View.findDrawableById("LeftBar");
		leftBar.setTotalAndCompleted(info.stepGoal, info.steps);
		
		// Update the right bar (floors climbed for now)
		var rightBar = View.findDrawableById("RightBar");
		rightBar.setTotalAndCompleted(info.floorsClimbedGoal, info.floorsClimbed);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
