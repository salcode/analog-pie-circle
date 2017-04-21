using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class analogPieCircleView extends Ui.WatchFace {

	hidden const GOLDEN_RATIO        = 1.6180339887;
	// The hour hand is 50% of the radius (i.e. max hand length).
	hidden const HOUR_HAND_FRACTION  = 0.60;
	hidden const MINUTES_PER_HOUR    = 60.0;
	hidden const SECONDS_PER_MINUTE  = 60.0;
	hidden const MINUTES_IN_12_HOURS = 12.0 * 60.0;
	hidden const ANGLE_INCREMENT     = Math.PI / 30.0;  // One sixtyth of a rotation.
	hidden const ANGLE_BETWEEN_HOURS = Math.PI / 6.0;   // One twelfth of a rotation.
	hidden const FOREGROUND_COLOR    = Gfx.COLOR_WHITE;
	hidden const BACKGROUND_COLOR    = Gfx.COLOR_BLACK;
	hidden const HOUR_HAND_COLOR     = Gfx.COLOR_ORANGE;
	hidden const HOUR_HAND_WIDTH     = 4;
	hidden const SECOND_HAND_FRACTION = 0.95;
	hidden const SECOND_HAND_COLOR   = Gfx.COLOR_RED;
	hidden const SECOND_HAND_WIDTH   = 2;
	hidden const MINUTE_HAND_COLOR   = Gfx.COLOR_WHITE;
	hidden const DIAL_MARKER_COLOR   = Gfx.COLOR_LT_GRAY;
	hidden const DIAL_MARKER_HOUR_LENGTH   = 10;
	hidden const DIAL_MARKER_MINUTE_LENGTH = 3;
	hidden const DIAL_MARKER_WIDTHS        = 2;
	hidden const BATTERY_HEIGHT            = 12;
	hidden const BATTERY_FG_COLOR          = Gfx.COLOR_WHITE;
	hidden const BATTERY_BG_COLOR          = Gfx.COLOR_LT_GRAY;
	
	
	hidden var radius, centerX, centerY, minX, minY, maxX, maxY, isAwake;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        minX = 0;
    	maxX = dc.getWidth(); // 205
    	minY = 0;    	
    	maxY = dc.getHeight(); // 148
    	// for now work with a sq screen rather than rectangle
    	minX = ( maxX - maxY ) / 2;
    	maxX = minX + maxY;
        centerX = ( ( maxX - minX ) / 2 ) + minX;
        centerY = ( ( maxY - minY ) / 2 ) + minY;
        radius = centerX > centerY ? centerY : centerX;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    // Clear the screen
    hidden function clear(dc) {
        dc.setColor(FOREGROUND_COLOR, BACKGROUND_COLOR);
        dc.clear();
    }

    // Update the view
    function onUpdate(dc) {
    	clear(dc);
    	var time = Sys.getClockTime();
    	drawMinuteHand(dc, time.min);
    	drawHourHand(dc, time.hour, time.min);
    	if ( isAwake ) {
    		drawSecondHand(dc, time.sec);
    	}
    	drawDial(dc);
    	drawBattery(dc);    	
    }
    
    hidden function drawBattery(dc) {
    	var paddingFromBottom = 5;
    	var batteryEndWidth   = 3;
    	var batteryPercent    = Sys.getSystemStats().battery;
    	var height = BATTERY_HEIGHT;
    	var width  = BATTERY_HEIGHT * GOLDEN_RATIO;
    	var x      = minX - width;
    	var y      = maxY - height - paddingFromBottom; 
    	dc.setColor(BATTERY_BG_COLOR, BACKGROUND_COLOR);
    	
    	// Battery background.
    	dc.fillRectangle(x, y, width, height);                             // Battery body.
    	dc.fillRectangle(x + width - 1, y + 2, batteryEndWidth, height-4); // Battery end.
    	
    	// Charged part of Battery.
    	dc.setColor(BATTERY_FG_COLOR, BACKGROUND_COLOR);
    	dc.fillRectangle(x, y, width * ( batteryPercent / 100 ), height);    
    }
    
    hidden function drawDial(dc) {
    	var edgePt, innerPt, innerPtRadius;
    	var angle = 0;
    	
    	dc.setColor(DIAL_MARKER_COLOR, BACKGROUND_COLOR);
    	
    	for (var i = 0; i < 60; i++) {
    		dc.setPenWidth(DIAL_MARKER_WIDTHS);
    		innerPtRadius = radius - DIAL_MARKER_MINUTE_LENGTH;
    		if ( 0 == i % 5 ) {
    			dc.setPenWidth(4);
    			innerPtRadius = radius - DIAL_MARKER_HOUR_LENGTH;
    		}
    		edgePt  = getPointOnCircle( angle, radius );
    		innerPt = getPointOnCircle( angle, innerPtRadius );
    		dc.drawLine(
    			edgePt[0], edgePt[1],
    			innerPt[0], innerPt[1]
    		);	
    		angle += ANGLE_INCREMENT;
    	}
    }
    
    hidden function drawHourHand(dc, hours, minutes) {
    	var minutesInto12HourRotation = 0;
    	if ( hours > 11 ) {
    		// If we're in the PM hours, subtract 12.
    		hours -= 12;
    	}
    	minutesInto12HourRotation += hours * MINUTES_PER_HOUR;
    	minutesInto12HourRotation += minutes;
        var angle  = getAngle( minutesInto12HourRotation, MINUTES_IN_12_HOURS );
        var coords = getPointOnCircle( angle, radius * HOUR_HAND_FRACTION );
        
     	dc.setColor(HOUR_HAND_COLOR, BACKGROUND_COLOR);
        dc.setPenWidth(HOUR_HAND_WIDTH);
        dc.drawLine(
            centerX, centerY,
            coords[0], coords[1]
        );
    }
    
    hidden function drawSecondHand(dc, seconds) {
    	var angle  = getAngle( seconds, SECONDS_PER_MINUTE );
    	var coords = getPointOnCircle( angle, radius * SECOND_HAND_FRACTION );
     	dc.setColor(SECOND_HAND_COLOR, BACKGROUND_COLOR);
        dc.setPenWidth(SECOND_HAND_WIDTH);
        dc.drawLine(
            centerX, centerY,
            coords[0], coords[1]
        );
    	 
    }
    
    
    hidden function drawMinuteHand(dc, minutes) {
    	var angle = getAngle(minutes, MINUTES_PER_HOUR);
    	var coords = getPointOnCircle(angle, radius);
    	
    	dc.setColor(MINUTE_HAND_COLOR, BACKGROUND_COLOR);
        
        var points = [
        	[centerX, minY],    // 12 o'clock, top center point
        	[centerX, centerY]  // center
        ];
        
        // Add point for current minute.
        points.add( getPointOnCircle(angle, radius) );
        
        // Fill out polygon with faux circle going back to zero minutes.
        for ( angle = angle; angle > 0; angle -= ANGLE_INCREMENT ) {
        	points.add( getPointOnCircle(angle, radius) );
        }
    	
    	// Draw pie 
    	dc.fillPolygon( points );
    }
    
    /**
     * Get point on circle based on angle and radius
     *
     * We also use the global values centerX, centerY
     * @return array [ pointX, pointY ]
     */     
    hidden function getPointOnCircle( angle, radius ) {
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        var pointX = centerX + (sin * radius);
        var pointY = centerY - (cos * radius);
    	return [ pointX, pointY ];
    }
    
    /**
     * Get Angle in radians
     */
    hidden function getAngle(value, maxValue) {
    	return ( value / maxValue ) * Math.PI * 2.0;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	isAwake = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        isAwake = false;
        Ui.requestUpdate();
    }

}