using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Mon;
using Toybox.Math as Mt;

class WatchfaceRootsJtbView extends Ui.WatchFace {

	var customFont, microFont = null;
	var iconHeart, iconBT, iconBell, iconEnveloppe, iconRunner = null;
	
	var COLOR_MODE_STANDARD = 0;
	var COLOR_MODE_DISCO = 1;
	var COLOR_MODE_LUCY = 2;
	var COLORS = [Gfx.COLOR_WHITE, Gfx.COLOR_LT_GRAY, Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK, Gfx.COLOR_RED, Gfx.COLOR_DK_RED, Gfx.COLOR_ORANGE, Gfx.COLOR_YELLOW, Gfx.COLOR_GREEN, Gfx.COLOR_DK_GREEN, Gfx.COLOR_BLUE, Gfx.COLOR_DK_BLUE, Gfx.COLOR_PURPLE, Gfx.COLOR_PINK];
	
	var COLOR_TRANSPARENT = Gfx.COLOR_TRANSPARENT;
	var COLOR_FOREGROUND = Gfx.COLOR_WHITE;
	
	var FONT_SMALL = Gfx.FONT_SYSTEM_XTINY;
	var FONT_SECONDS = Gfx.FONT_SYSTEM_SMALL;
	
	var screen_height, screen_width;
	
 	var batt_width = 22;
    var batt_height = 10;
    var batt_dop_width = 2;
    var batt_dop_height = 5;
    var icon_components_padding = 2;
    var batt_x, batt_y, batt_dop_x, batt_dop_y, batt_percent_x,batt_percent_y;
    
    var clock_y, date_y, seconds_y;
    var heartR_x, heartR_y;
    var heartR_icon_width = 18;
    var heartRComp_width = 0;
    var heartRComp_heigth = 0;
	
    var stepsCount_y;
	var stepsBar_width = 80;
	var stepsBar_height = 8;
	
	var iconAdjustment = 2;
	
	var sleeping=false;
	
	//PROPERTIES
	var PROP_COLOR_MODE = 0;
	var PROP_COLOR_BACKGROUND = Gfx.COLOR_BLACK;
	var PROP_COLOR_CLOCK_H = Gfx.COLOR_WHITE;
	var PROP_COLOR_CLOCK_MIN = Gfx.COLOR_RED;
	var PROP_DATE_FORMAT=0;
	var PROP_SHOW_SECONDS = true;
	var PROP_SHOW_HR = true;
	var PROP_HR_KEEP_DISPLAYED=true;

    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		microFont = Ui.loadResource(Rez.Fonts.microFont);
		iconHeart = Ui.loadResource( Rez.Drawables.iconHeart );
		iconBT = Ui.loadResource( Rez.Drawables.iconBT );
		iconBell = Ui.loadResource( Rez.Drawables.iconBell );
		iconEnveloppe = Ui.loadResource( Rez.Drawables.iconEnveloppe );
		iconRunner = Ui.loadResource( Rez.Drawables.iconRunner );
		
		loadProperties();
				
		  //get screen dimensions
		screen_width = dc.getWidth();
        screen_height = dc.getHeight();
    
	     //get battery icon position
        batt_percent_y=15;
		batt_x = (screen_width/ 2)  - (batt_width) - (batt_dop_width) - icon_components_padding;
		batt_y = batt_percent_y + batt_height/2;
        batt_dop_x = batt_x + batt_width;
        batt_dop_y = batt_y + ((batt_height - batt_dop_height) / 2);
        batt_percent_x = (screen_width/ 2) + icon_components_padding;
        
        clock_y=(screen_height/2)-75;
        date_y=clock_y-8;
        seconds_y=clock_y+120;
        
        heartR_x = screen_width/ 2 - heartR_icon_width - icon_components_padding;
        heartR_y = clock_y + 130;
       	heartRComp_width = heartR_icon_width + icon_components_padding + dc.getTextWidthInPixels("000", FONT_SMALL);
    	heartRComp_heigth = dc.getFontHeight(FONT_SMALL);
        
        stepsCount_y = screen_height - 30;
    }
    
    function loadProperties(){
    	try{
			PROP_COLOR_CLOCK_H = COLORS[Application.Properties.getValue("PROP_COLOR_CLOCK_HOUR")];
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
		
		try{
			PROP_COLOR_CLOCK_MIN = COLORS[Application.Properties.getValue("PROP_COLOR_CLOCK_MIN")];
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
		
		try{
			PROP_COLOR_BACKGROUND = COLORS[Application.Properties.getValue("PROP_COLOR_BACKGROUND")];
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
		
		try{
			PROP_COLOR_MODE = Application.Properties.getValue("PROP_COLOR_MODE");
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
		
		try{
			PROP_DATE_FORMAT = Application.Properties.getValue("PROP_DATE_FORMAT");
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
			
		try{
			PROP_SHOW_SECONDS = Application.Properties.getValue("PROP_SHOW_SECONDS");
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
		
		
		try{
			PROP_SHOW_HR = Application.Properties.getValue("PROP_SHOW_HR");
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
		
		try{
			PROP_HR_KEEP_DISPLAYED = Application.Properties.getValue("PROP_HR_KEEP_DISPLAYED");
		} catch (e instanceof InvalidKeyException) {
   			System.println(e.getErrorMessage());
		}
    }

    // Update the view
    function onUpdate(dc) {
    	if(PROP_COLOR_MODE == COLOR_MODE_DISCO){
    		var color = getRandomColor(PROP_COLOR_BACKGROUND);
    		PROP_COLOR_CLOCK_H = color;
    		PROP_COLOR_CLOCK_MIN = color;
    	}else if(PROP_COLOR_MODE == COLOR_MODE_LUCY){
    		var color = getRandomColor(null);
    		PROP_COLOR_BACKGROUND = color;
    		PROP_COLOR_CLOCK_H = getRandomColor(color);
    		PROP_COLOR_CLOCK_MIN = getRandomColor(color);
    	}
    
    	dc.clearClip();
    	dc.setColor(COLOR_FOREGROUND, PROP_COLOR_BACKGROUND);
    	dc.clear();
    	
        // Draw the battery icon
        displayBatteryIcon(dc, 0xFF0000, 0xFFAA00, 0x00FF00);
       	displayBatteryPercent(dc);
       	
   		displayClock(dc);
       	displayBtAndAlarm(dc);
        displayDate(dc);
		
		if(!sleeping && PROP_SHOW_HR){
		   displayHr(dc);
        }
        
        var stepsCount = Mon.getInfo().steps;
        displayStepsBar(dc, stepsCount);
        displayStepsCounter(dc, stepsCount);
        
        displayNotifications(dc);
    }
    
  	function onPartialUpdate(dc){
  		if(sleeping && PROP_SHOW_HR && PROP_HR_KEEP_DISPLAYED){
  			var clipX = heartR_x;
  			var clipY = heartR_y;
  			var clipWidth = 22+dc.getTextWidthInPixels("000", FONT_SMALL);
  			var clipHeight = dc.getFontHeight(FONT_SMALL);
	  		dc.setClip(clipX, clipY, clipWidth, clipHeight);
	  		dc.setColor(PROP_COLOR_BACKGROUND, PROP_COLOR_BACKGROUND);
	  		dc.fillRectangle(clipX, clipY, clipWidth, clipHeight);
	  		dc.setColor(COLOR_FOREGROUND, PROP_COLOR_BACKGROUND);
		    dc.drawBitmap(heartR_x, heartR_y + iconAdjustment, iconHeart );
			dc.drawText(screen_width/2 + icon_components_padding, heartR_y, FONT_SMALL, retrieveHeartrateText(), Gfx.TEXT_JUSTIFY_LEFT);
    	}
    }
    
    function getRandomColor(colorToAvoid){
    	var r = Mt.rand() % COLORS.size();
    	var color = COLORS[r];
    	if(null != colorToAvoid && colorToAvoid == color){
    		return getRandomColor(colorToAvoid);
    	}
    	return color;
    }
    
    function displayNotifications(dc){
    	dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
		var notif = System.getDeviceSettings().notificationCount;
		if(notif>0){
		    dc.drawBitmap(35, heartR_y + iconAdjustment , iconEnveloppe);
		    //x = 35 + 25 (enveloppe width) + 4 (gap)
			dc.drawText(64, heartR_y, FONT_SMALL, notif.toString(),Gfx.TEXT_JUSTIFY_LEFT);	    	
		}
    }
    
	function displayBtAndAlarm(dc){
		dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
		
		if(System.getDeviceSettings().phoneConnected){
		    dc.drawBitmap(35, date_y+4 , iconBT);	
		}
	    
	    if(System.getDeviceSettings().alarmCount >= 1){
		    dc.drawBitmap(50, date_y+4 , iconBell);	
		}
	}
   
   	function displayStepsBar(dc, stepsCount){
        dc.drawRectangle(screen_width/2 - stepsBar_width/2, stepsCount_y - 10, stepsBar_width, stepsBar_height);
        
        var stepsCountGoal = Mon.getInfo().stepGoal;
        var goal = (stepsCount * 1.0 / stepsCountGoal * 1.0) ;
                        
        var fillColor = 0xFFAA00;
        var fillSize = (stepsBar_width -2.0) * goal;
        if(goal>=1.0){
	        fillColor=0x00FF00;
	        fillSize=stepsBar_width-2;
        }else if(goal >= 0.75){
        	fillColor=0xAA55FF;
         }else if(goal <= 0.25){
        	fillColor=0xFF0000;
        }
        
        dc.setColor(fillColor, COLOR_TRANSPARENT);
        dc.fillRectangle(screen_width/2 - stepsBar_width/2 + 1, stepsCount_y-8, fillSize, stepsBar_height-4);
   }
   
   function displayStepsCounter(dc, stepsCount){
   		var iconWidthAndPadding = 11.0 + icon_components_padding;
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), FONT_SMALL) + iconWidthAndPadding;
		var start = screen_width/ 2.0 - size/2.0;
		dc.setColor(COLOR_FOREGROUND,COLOR_TRANSPARENT);
		dc.drawBitmap(start,stepsCount_y + iconAdjustment, iconRunner );
	  	dc.drawText(start+iconWidthAndPadding, stepsCount_y,  FONT_SMALL, stepsCount.toString(),Gfx.TEXT_JUSTIFY_LEFT);
	}
    
    function displayHr(dc){
    	dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
		dc.drawBitmap(heartR_x, heartR_y + iconAdjustment, iconHeart );
		dc.drawText(screen_width/2 + icon_components_padding, heartR_y,  FONT_SMALL, retrieveHeartrateText() ,Gfx.TEXT_JUSTIFY_LEFT);
	}
	
    private function retrieveHeartrateText() {
		var hr = Activity.getActivityInfo().currentHeartRate;
		if(null != hr){
			return hr.format("%d");
		}
		return "000";
    }    
    
    function displayClock(dc){
   		var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        if(!Sys.getDeviceSettings().is24Hour){
        	hour=Lang.format("$1$", [hour.format("%02d")]);
        }
        
        dc.setColor(PROP_COLOR_CLOCK_H, COLOR_TRANSPARENT);
		
		var hourToString = hour.toString();
		if(hourToString.length() == 1){
			hourToString="0"+hourToString;
		}
		dc.drawText(dc.getWidth()/2, clock_y, customFont, hourToString ,Gfx.TEXT_JUSTIFY_RIGHT);

        dc.setColor(PROP_COLOR_CLOCK_MIN, COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, clock_y, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]),Gfx.TEXT_JUSTIFY_LEFT);
        
        if(!sleeping && PROP_SHOW_SECONDS){
			dc.drawText(screen_width-40,seconds_y, Gfx.FONT_SYSTEM_SMALL, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);  
		}
    }
    
    function displayBatteryPercent(dc){
	   	var battery = Sys.getSystemStats().battery;
		dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
	   	dc.drawText(batt_percent_x, batt_percent_y, FONT_SMALL, battery.format("%d")+"%", Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function displayBatteryIcon(dc, lowBatteryColor, mediumBatteryColor, fullBatteryColor) {
    	dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
        var battery = Sys.getSystemStats().battery;
      	
      	var fillColor = fullBatteryColor;
      
        if(battery < 25.0){
            fillColor = lowBatteryColor;
        }else if(battery < 50.0){
        	fillColor = mediumBatteryColor;
        }

        dc.setColor(COLOR_FOREGROUND,COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x, batt_y, batt_width, batt_height);
        dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
        dc.drawLine(batt_dop_x-1, batt_dop_y+1, batt_dop_x-1, batt_dop_y + batt_dop_height-1);

        dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
        dc.drawRectangle(batt_dop_x, batt_dop_y, batt_dop_width, batt_dop_height);
        dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
        dc.drawLine(batt_dop_x, batt_dop_y+1, batt_dop_x, batt_dop_y + batt_dop_height-1);

		var fillBar = ((batt_width -2 ) * battery / 100);
		var fillBar2 = Math.round(fillBar);
		System.println("battery=" + battery + " --- prog=" + fillBar +" or "+ fillBar2 );
		
        dc.setColor(fillColor, COLOR_TRANSPARENT);
        dc.fillRectangle(batt_x +1 , batt_y+1, fillBar2, batt_height-2);
    }
    
	function displayDate(dc){
        var dateStr = formatDate();
        dc.setColor(COLOR_FOREGROUND, COLOR_TRANSPARENT);
        dc.drawText(screen_width - 35,date_y, Gfx.FONT_SYSTEM_SMALL, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
    }

	function formatDate(){
		var now = Time.now();
		
		if (PROP_DATE_FORMAT == 1){
			var info = Calendar.info(now, Time.FORMAT_SHORT);
	       return Lang.format("$1$/$2$/$3$", [info.day.format("%02d"), info.month.format("%02d"), info.year]);
		}else if (PROP_DATE_FORMAT == 2){
			var info = Calendar.info(now, Time.FORMAT_SHORT);
	        return Lang.format("$1$/$2$/$3$", [info.month.format("%02d"), info.day.format("%02d"), info.year]);
		}
		
	    var info = Calendar.info(now, Time.FORMAT_MEDIUM);
	   	return  Lang.format("$1$ $2$ $3$", [info.day_of_week,info.day, info.month]);
	}
    
    function onShow() {
	}
    function onHide() {
    }
    function onExitSleep() {
   		sleeping = false;
    }
    
    function onEnterSleep() {
    	sleeping = true;
   		Ui.requestUpdate();
    }
    
 

}
