using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using JTBUtils as Utils;
using RootsConstants as Cst;

public class RootsJtbView extends Ui.WatchFace {

	//DEBUG
	hidden var showLines = true;
	
	//CONSTANTS
	//positions
	hidden const LEFT_x = 35;
	hidden const RIGHT_x = 35;
	hidden const SPAN_y = 3;
	hidden const L1 = 15;
	hidden const L2p = 0.20;
	hidden const L4p = 0.78;
	hidden const L6 = 35;
	hidden const HOUR_H_PERCENT = 0.50;
	
	//colors
	hidden const COLOR_TRANSPARENT = Gfx.COLOR_TRANSPARENT;

	hidden const ICON_PADDING = 3;
	hidden const FONT_ICON_CHAR_ALARM="0";
	hidden const FONT_ICON_CHAR_BLUETOOTH="1";
	hidden const FONT_ICON_CHAR_NOTIFICATION="2";
	hidden const FONT_ICON_CHAR_RUNNER="3";
	hidden const FONT_ICON_CHAR_HEART="4";
	hidden const FONT_ICON_CHAR_CALORIES="5";
	hidden const FONT_ICON_CHAR_DISTANCE="6";
	
	//IINSTANCE VARIABLES 
	//general
	hidden var fontIcons, customFont, fontTextHR, fontTextNotification, fontTextDate, fontTextSeconds, fontTextBattery, fontTextSteps,fontTextCalories, fontTextDistance;
	hidden var colorHour, colorMinute, colorForeground, colorBackground;
	hidden var iconColorHeart, iconColorNotification, iconColorAlarm, iconColorRunner, iconColorBluetooth,iconColorCalories, iconColorDistance;
	hidden var showAlarm, showDate, showBluetooth, showSeconds, keepSecondsDisplayed, keepHRDisplayed, showNotification, showBatteryText;
	//coordinates
	hidden var co_Screen_Height, co_Screen_Width;
	hidden var co_Date_y, co_Clock_y;
	hidden var co_Seconds_y, co_Seconds_x;
	hidden var co_IconBT_x,co_IconBT_y;
	hidden var co_IconAlarm_x, co_IconAlarm_y;
	hidden var co_HR_y;
	hidden var co_IconNotif_x, co_IconNotif_y;
	hidden var co_Battery_y;
	hidden var fontCustomHeight;
	hidden var zone04, zone01,zone02, zone03, zone05, zone06, zone07, zone08;
	hidden var clipSeconds, clipHR;
	
	//components
	hidden var zone8CompId, zone1CompId, zone6CompId;
	hidden var zone1Component, zone8Component, zone6Component;
	hidden var computeCoordinatesRequired = false;
	hidden var colorMode, dateFormat;

	hidden var sleeping=false;
	
    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		fontIcons = Ui.loadResource(Rez.Fonts.fontIcons);
		
		reloadBasics(false);
		computeCoordinates(dc);
		
		createZone1Component(zone1CompId);
		createZone6Component(zone6CompId);
		createZone8Component(zone8CompId);
    }
    
    
    function createBatteryComponent(x, y, width, height){
    	return new BatteryComponent({
			:locX=>x,
			:locY=>y,
			:width=>width,
			:height=>height,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:textFont=>fontTextBattery,
			:showText=>showBatteryText
		});
    }
    
    function createCaloriesComponent(x, y, width, height){
    	return new CaloriesComponent({
			:locX=>x,
			:locY=>y,
			:width=>width,
			:height=>height,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:textFont=>fontTextCalories,
			:iconFont=>fontIcons,
			:iconChar=>FONT_ICON_CHAR_CALORIES,
			:iconColor=>iconColorCalories,
		});
    }
    
    function createDistanceComponent(x, y, width, height){
    	return new DistanceComponent({
			:locX=>x,
			:locY=>y,
			:width=>width,
			:height=>height,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:textFont=>fontTextDistance,
			:iconFont=>fontIcons,
			:iconChar=>FONT_ICON_CHAR_DISTANCE,
			:iconColor=>iconColorDistance,
		});
    }
    
     function createStepsComponent(x, y, width, height){
    	return new StepsComponent({
			:locX=>x,
			:locY=>y,
			:width=>width,
			:height=>height,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:textFont=>fontTextSteps,
			:iconFont=>fontIcons,
			:iconChar=>FONT_ICON_CHAR_RUNNER,
			:iconColor=>iconColorRunner,
		});
    }
    
     function createHeartRateComponent(x, y, width, height){
    	return new HeartRateComponent({
			:locX=>x,
			:locY=>y,
			:width=>width,
			:height=>height,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:textFont=>fontTextHR,
			:iconFont=>fontIcons,
			:iconChar=>FONT_ICON_CHAR_HEART,
			:iconColor=>iconColorHeart,
			:keepDisplayedOnSleep=>keepHRDisplayed
		});
    }
    
    function createZoneComponent(componentId, x, y, w, h){
		if(componentId == Cst.OPTION_ZONE_STEPS){
    		return createStepsComponent(x, y, w, h);
		}else if(componentId == Cst.OPTION_ZONE_CALORIES){
			return createCaloriesComponent(x, y, w, h);
		}else if(componentId == Cst.OPTION_ZONE_BATTERY){
			return createBatteryComponent(x, y, w, h);
		}else if(componentId == Cst.OPTION_ZONE_DISTANCE){
			return createDistanceComponent(x, y, w, h);
		}else if(componentId == Cst.OPTION_ZONE_HEARTRATE){
			return createHeartRateComponent(x, y, w, h);
		}
    }
    
    function createZone1Component(componentId){
		zone1Component = createZoneComponent(componentId, zone01[0], zone01[1], zone01[2], zone01[3]);
    }
    
    function createZone6Component(componentId){
		zone6Component = createZoneComponent(componentId, zone06[0], zone06[1], zone06[2], zone06[3]);
    }
    
    function createZone8Component(componentId){
		zone8Component = createZoneComponent(componentId, zone08[0], zone08[1], zone08[2], zone08[3]);
    }
    
    function computeCoordinates(dc){
    	//get screen dimensions
		co_Screen_Width = dc.getWidth();
        co_Screen_Height = dc.getHeight() - 2*SPAN_y;
                
          //row 3
        var zone04_cy = co_Screen_Height / 2;
        var zone04_x = 0 ;
        var zone04_y = zone04_cy - co_Screen_Height * HOUR_H_PERCENT / 2;
        var zone04_w = co_Screen_Width;
        var zone04_h = co_Screen_Height * HOUR_H_PERCENT;
        zone04 = [zone04_x, zone04_y, zone04_w, zone04_h, zone04_cy];
        
        var row01_h = zone04_y * 0.30;
        var row02_h = zone04_y * 0.70;
        var row04_h = (co_Screen_Height / 2 - zone04_h/2) * 0.40;
        var row05_h = (co_Screen_Height / 2 - zone04_h/2) * 0.60;
        
        var fontCustomHeight = dc.getFontHeight(customFont);
        var co_ClockTop_y = zone04[4] - fontCustomHeight/2;
    	var co_ClockBottom_y = zone04[4] + fontCustomHeight/2;
        
        //row 1
        var zone01_x = 0;
        var zone01_y = SPAN_y;
        var zone01_w = co_Screen_Width;
        var zone01_h = row01_h;
        var zone01_cy = zone01_y + zone01_h/2;
        zone01 = [zone01_x, zone01_y, zone01_w, zone01_h, zone01_cy];
        
        //row 2
        var zone02_x = 0;
        var zone02_y = zone01_h;
        var zone02_w = co_Screen_Width * 0.33;
        var zone02_h = row02_h;
        var zone02_cy = zone02_y + zone02_h / 2;
        zone02 = [zone02_x, zone02_y, zone02_w, zone02_h, zone02_cy];
        
       
        var zone03_x = zone02_w;
        var zone03_h = row02_h;
        var zone03_y = co_ClockTop_y - zone03_h;
        var zone03_w = co_Screen_Width * 0.67;
        var zone03_cy = zone03_y + zone03_h / 2;
        zone03 = [zone03_x, zone03_y, zone03_w, zone03_h, zone03_cy];
        
        //row 4 
        var zone05_x = 0;
        var zone05_y = zone04_y + zone04_h;
        var zone05_w = co_Screen_Width * 0.32;
        var zone05_h = row04_h;
        var zone05_cy = zone05_y + zone05_h / 2;
        zone05 = [zone05_x, zone05_y, zone05_w, zone05_h, zone05_cy];
        
        var zone06_x = zone05_w;
        var zone06_y = zone05_y;
        var zone06_w = co_Screen_Width * 0.36;
        var zone06_h = row04_h;
        var zone06_cy = zone06_y + zone06_h / 2;
        zone06 = [zone06_x, zone06_y, zone06_w, zone06_h, zone06_cy];
        
        var zone07_x = zone05_w + zone06_w;
        var zone07_y = co_ClockBottom_y;
        var zone07_w = co_Screen_Width * 0.32;
        var zone07_h = row04_h;
        var zone07_cy = zone07_y + zone07_h / 2;
        zone07 = [zone07_x, zone07_y, zone07_w, zone07_h, zone07_cy];
        
        //row 5
        var zone08_x = 0;
        var zone08_y = zone05_y + row04_h;
        var zone08_w = co_Screen_Width;
        var zone08_h = row05_h;
        var zone08_cy = zone08_y + zone08_h / 2;
        zone08 = [zone08_x, zone08_y, zone08_w, zone08_h, zone08_cy];
		
		
		
		// Computing coordinates
    	co_Battery_y = zone01[4];
		
    	co_IconBT_x = LEFT_x;
    	co_IconBT_y = zone02[4];
    	
    	var w = dc.getTextWidthInPixels(FONT_ICON_CHAR_BLUETOOTH, fontIcons);
    	co_IconAlarm_x = LEFT_x + w + ICON_PADDING;
    	co_IconAlarm_y = zone02[4];

    	fontCustomHeight = dc.getFontHeight(customFont);
    	co_Clock_y = zone04[04];
    	
    	co_Seconds_x = zone07[0]+15;
    	co_Seconds_y = zone07[4];
		clipSeconds = [zone07[0], zone07[1], zone07[2], zone07[3]];
    	
    	var fontDateH = dc.getFontHeight(fontTextDate);
    	co_Date_y =  zone03[4];
    	
    	co_IconNotif_x = LEFT_x;
    	co_IconNotif_y = zone05[4];
    	
    	co_HR_y = zone05[4];
    	clipHR = [zone06[0], zone06[1], zone06[2], zone06[3]];
   
	    computeCoordinatesRequired=false;
    }

/**
	------------------------
	UPDATE THE VIEW
	------------------------
*/
    function onUpdate(dc) {
		if(computeCoordinatesRequired){
    		computeCoordinates(dc);
    	}
    	
    	loadColorModeColors();
    
    	dc.clearClip();
    	dc.setColor(colorForeground, colorBackground);
    	dc.clear();
    	
   		displayClock(dc);
   		
        if(!sleeping && showSeconds){
			displaySeconds(dc);  
		}
   		
       	displayBtAndAlarm(dc);
       	
       	if(showDate){
	        displayDate(dc);
       	}
        
        if(null!= zone1Component){
	      	zone1Component.draw(dc);
        }
        
        if(null!= zone6Component){
	      	zone6Component.draw(dc);
        }
        if(null!= zone8Component){
	      	zone8Component.draw(dc);
        }
      	
      	if(showNotification){
        	displayNotifications(dc);
        }
        
        // This is useful for Ui debugging
        if(showLines){
		    drawGridLines(dc);
	    }
    }
    
    function drawGridLines(dc){
        
        dc.setColor(Gfx.COLOR_GREEN, colorBackground);
       	drawRectangleGrid(dc, zone01);
   		drawRectangleGrid(dc, zone02);
  		drawRectangleGrid(dc, zone03);
  		drawRectangleGrid(dc, zone04);
  		drawRectangleGrid(dc, zone05);
  		drawRectangleGrid(dc, zone06);
  		drawRectangleGrid(dc, zone07);
  		drawRectangleGrid(dc, zone08);
       					
        dc.setColor(Gfx.COLOR_BLUE, colorBackground);
        drawLineGrid(dc, zone01);
        drawLineGrid(dc, zone02);
        drawLineGrid(dc, zone03);
        drawLineGrid(dc, zone04);
        drawLineGrid(dc, zone05);
        drawLineGrid(dc, zone06);
 		drawLineGrid(dc, zone07);
 		drawLineGrid(dc, zone08);
    }
    
    function drawRectangleGrid(dc, zone){
    	dc.drawRectangle(zone[0], zone[1], zone[2], zone[3]);
    }
    
    function drawLineGrid(dc, zone){
    	dc.drawLine(zone[0], zone[4], zone[0]+zone[2], zone[4]);
    }
    
    
    function onPartialUpdate(dc){
    	if(computeCoordinatesRequired){
    		computeCoordinates(dc);
    	}
    	
		dc.clearClip();
  		
  		if(null != zone6Component && zone6Component.canBeHiddenOnSleep()){
	  		dc.setClip(zone06[0], zone06[1], zone06[2], zone06[3]);
	  		dc.setColor(colorBackground,colorBackground);
			dc.clear();
			if(zone6Component.isKeptDisplayedOnSleep()){
				zone6Component.draw(dc);
			}
  		}
    	
    	if(showSeconds && keepSecondsDisplayed){
    		dc.setClip(clipSeconds[0], clipSeconds[1], clipSeconds[2], clipSeconds[3]);
    		dc.setColor(colorBackground,colorBackground);
			dc.clear();
    		
			displaySeconds(dc);
		} 
    }
    
 	function reloadBasics(reloadComponents){
    	reloadBasicColors();
    	reloadFonts();
    	reloadShows();
    	if(reloadComponents){
	    	reloadComponents();
    	}
    	computeCoordinatesRequired=true;
    	Ui.requestUpdate();
    }
    
    function reloadShows(){
    	showBatteryText = Utils.getPropertyValue(Cst.PROP_SHOW_BATTERY_TEXT);
  		showAlarm = Utils.getPropertyValue(Cst.PROP_SHOW_ALARM);
  		showDate = Utils.getPropertyValue(Cst.PROP_SHOW_DATE);
  		showBluetooth = Utils.getPropertyValue(Cst.PROP_SHOW_BLUETOOTH);
  		showNotification = Utils.getPropertyValue(Cst.PROP_SHOW_NOTIFICATION);
  		showSeconds = Utils.getPropertyValue(Cst.PROP_SHOW_SECONDS);
  		
  		keepHRDisplayed = Utils.getPropertyValue(Cst.PROP_HR_KEEP_DISPLAYED);
  		keepSecondsDisplayed = Utils.getPropertyValue(Cst.PROP_SECONDS_KEEP_DISPLAYED);
  		
  		dateFormat = Utils.getPropertyValue(Cst.PROP_DATE_FORMAT);
  		
  		zone1CompId = Utils.getPropertyValue(Cst.PROP_ZONE_1);
  		zone6CompId = Utils.getPropertyValue(Cst.PROP_ZONE_6);
  		zone8CompId = Utils.getPropertyValue(Cst.PROP_ZONE_8);
    }
    
    function reloadComponents(){
		createZone1Component(zone1CompId);
		createZone6Component(zone6CompId);
		createZone8Component(zone8CompId);
    }
    
    function reloadFonts(){
   		fontTextHR = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_HR);
   		fontTextNotification = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_NOTIFICATION);
   		fontTextBattery = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_BATTERY);
    	fontTextDate = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_DATE);
    	fontTextSeconds = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_SECONDS);
   		fontTextSteps = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_STEPS);
   		fontTextCalories = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_CALORIES);
   		fontTextDistance = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_DISTANCE);
    }
    
/**
	------------------------
	COLORS
	------------------------
*/
    function reloadBasicColors(){
    	colorBackground = Utils.getPropertyAsColor(Cst.PROP_COLOR_BACKGROUND);
	    colorHour = Utils.getPropertyAsColor(Cst.PROP_COLOR_CLOCK_HOUR);
    	colorMinute = Utils.getPropertyAsColor(Cst.PROP_COLOR_CLOCK_MIN);
    	colorForeground = Utils.getPropertyAsColor(Cst.PROP_COLOR_FOREGROUND);
    	
    	iconColorHeart = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_HEART);
    	iconColorNotification = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_NOTIFICATION);
    	iconColorAlarm = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_ALARM);
    	iconColorRunner = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_RUNNER);
    	iconColorBluetooth = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_BLUETOOTH);
    	iconColorCalories = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_CALORIES);
    	iconColorDistance = Utils.getPropertyAsColor(Cst.PROP_ICON_COLOR_DISTANCE);
    	
    	colorMode = Utils.getPropertyValue(Cst.PROP_MODE_COLOR);
    }
    
	function loadColorModeColors(){
       	if(colorMode == Cst.OPTION_MODE_COLOR_DISCO){
    		var color = Utils.getRandomColor([colorBackground]);
    		colorHour = color;
    		colorMinute = color;
    	}else if(colorMode == Cst.OPTION_MODE_COLOR_LUCY){
    		var color = Utils.getRandomColor(null);
    		colorBackground = color;
    		colorHour = Utils.getRandomColor([colorBackground]);
    		colorMinute = Utils.getRandomColor([colorBackground, colorHour]);
    		colorForeground = Utils.getRandomColor([colorBackground]);
    		iconColorHeart = Utils.getRandomColor([colorBackground]);
    		iconColorNotification = Utils.getRandomColor([colorBackground]);
    		iconColorAlarm = Utils.getRandomColor([colorBackground]);
    		iconColorBluetooth = Utils.getRandomColor([colorBackground]);
    		
    		if(null != zone1Component){
    			zone1Component.setIconColor(Utils.getRandomColor([colorBackground]));
    			zone1Component.setForegroundColor(Utils.getRandomColor([colorBackground]));
			}
			
			if(null != zone8Component){
    			zone8Component.setIconColor(Utils.getRandomColor([colorBackground]));
    			zone8Component.setForegroundColor(Utils.getRandomColor([colorBackground]));
    		}
    	}
    }
    

/**
	------------------------
	NOTIFICATIONS
	------------------------
*/
    function displayNotifications(dc){
		var notif = System.getDeviceSettings().notificationCount;
		if(notif>0){
			dc.setColor(iconColorNotification,COLOR_TRANSPARENT);
		    dc.drawText(co_IconNotif_x, co_IconNotif_y, fontIcons, FONT_ICON_CHAR_NOTIFICATION, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    		dc.setColor(colorForeground, COLOR_TRANSPARENT);
    		var w = dc.getTextWidthInPixels(FONT_ICON_CHAR_NOTIFICATION, fontIcons);
			dc.drawText(co_IconNotif_x + w + ICON_PADDING, co_IconNotif_y, fontTextNotification, notif.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);	    	
		}
    }

/**
	------------------------
	BLUETOOTH & ALARM
	------------------------
*/
	function displayBtAndAlarm(dc){
		
		if(showBluetooth && System.getDeviceSettings().phoneConnected){
			dc.setColor(iconColorBluetooth,COLOR_TRANSPARENT);
		    dc.drawText(co_IconBT_x, co_IconBT_y, fontIcons, FONT_ICON_CHAR_BLUETOOTH, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		}
	    
	    if(showAlarm && System.getDeviceSettings().alarmCount >= 1){
	   	 	dc.setColor(iconColorAlarm,COLOR_TRANSPARENT);
		    dc.drawText(co_IconAlarm_x, co_IconAlarm_y, fontIcons, FONT_ICON_CHAR_ALARM, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		}
	}


/**
	------------------------
	HEARTH RATE
	------------------------
*/
//    function displayHR(dc){
//	    var width = dc.getTextWidthInPixels(FONT_ICON_CHAR_HEART, fontIcons);
//		var hrText = retrieveHeartrateText();
//	    var iconWidthAndPadding = width + ICON_PADDING;
//   		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextHR) + iconWidthAndPadding;
//		var start = co_Screen_Width/ 2.0 - size/2.0;
//
//		dc.setColor(iconColorHeart,COLOR_TRANSPARENT);
//		dc.drawText(start, co_HR_y, fontIcons, FONT_ICON_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
//    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
//		dc.drawText(start+iconWidthAndPadding, co_HR_y, fontTextHR, hrText, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
//	}
//	
//    private function retrieveHeartrateText() {
//		var hr = Activity.getActivityInfo().currentHeartRate;
//		if(null != hr){
//			return hr.format("%d");
//		}
//		return "000";
//    }    
    
 
 /**
	------------------------
	CLOCK
	------------------------
*/
    function displayClock(dc){
    	//draw hour
        dc.setColor(colorHour, COLOR_TRANSPARENT);
   		var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        if(!Sys.getDeviceSettings().is24Hour){
        	if(hour == 0 ){
        		hour = 12;	
        	}else if(hour > 12){
        		hour = hour - 12;
        	}
        }

        var hourToString = hour.format("%02d");
		if(!Sys.getDeviceSettings().is24Hour){
			var hourWidth = dc.getTextWidthInPixels(hourToString, customFont);
			var aOrP = "A";
			if(clockTime.hour>=12){
				aOrP = "P";
			}
			var aOrPHeight = dc.getFontHeight(Gfx.FONT_SYSTEM_XTINY);
			var x =dc.getWidth()/2-hourWidth - ICON_PADDING;
			dc.drawText(x, (co_Screen_Height/2)-aOrPHeight, Gfx.FONT_SYSTEM_XTINY, aOrP, Gfx.TEXT_JUSTIFY_RIGHT);
			dc.drawText(x, (co_Screen_Height/2), Gfx.FONT_SYSTEM_XTINY, "M", Gfx.TEXT_JUSTIFY_RIGHT);
		}
		dc.drawText(co_Screen_Width/2 - ICON_PADDING*2, co_Clock_y, customFont, hourToString ,Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
		
		//draw min
        dc.setColor(colorMinute, COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2 + ICON_PADDING*2, co_Clock_y, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]),Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
    }
    
    function displaySeconds(dc){
    	dc.setColor(colorMinute, COLOR_TRANSPARENT);
		dc.drawText(co_Seconds_x, co_Seconds_y, fontTextSeconds, System.getClockTime().sec.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }


/**
	------------------------
	DATE
	------------------------
*/
	function displayDate(dc){
        var dateStr = formatDate();
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawText(co_Screen_Width - RIGHT_x,co_Date_y, fontTextDate, dateStr, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
    }

	function formatDate(){
		var now = Time.now();
		
		if (dateFormat == Cst.OPTION_DATE_FORMAT_DAYNUM_MONTHNUM_YEARNUM){
			var info = Calendar.info(now, Time.FORMAT_SHORT);
	       return Lang.format("$1$/$2$/$3$", [info.day.format("%02d"), info.month.format("%02d"), info.year]);
		}else if (dateFormat == Cst.OPTION_DATE_FORMAT_MONTH_NUM_DAYNUM_YEARNUM){
			var info = Calendar.info(now, Time.FORMAT_SHORT);
	        return Lang.format("$1$/$2$/$3$", [info.month.format("%02d"), info.day.format("%02d"), info.year]);
		}		
	    var info = Calendar.info(now, Time.FORMAT_MEDIUM);
	   	return  Lang.format("$1$ $2$ $3$", [info.day_of_week,info.day, info.month]);
	}


/**
	------------------------
	WATCH ACTIVITY
	------------------------
*/
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
