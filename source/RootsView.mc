using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
//using Toybox.ActivityMonitor as Mon;
using JTBUtils as Utils;
using RootsConstants as Cst;

public class RootsJtbView extends Ui.WatchFace {

	//DEBUG
	hidden var showLines = true;
	
	//CONSTANTS
	//positions
	hidden const LEFT_x = 35;
	hidden const RIGHT_x = 35;
	hidden const L1 = 15;
	hidden const L2p = 0.20;
	hidden const L4p = 0.78;
	hidden const L6 = 35;
	hidden const HOUR_H_PERCENT = 0.50;
	
	//colors
	hidden const COLOR_TRANSPARENT = Gfx.COLOR_TRANSPARENT;
//    hidden const COLOR_STEPSBAR_0=0xFF0000;
//	hidden const COLOR_STEPSBAR_25=0xFFAA00;
//	hidden const COLOR_STEPSBAR_75=0xAA55FF;
//    hidden const COLOR_STEPSBAR_100=0x00FF00;
//	hidden const STEPSBAR_WIDTH = 80;
//	hidden const STEPSBAR_HEIGHT = 8;

	hidden const ICON_PADDING = 3;
	hidden const FONT_ICON_CHAR_ALARM="0";
	hidden const FONT_ICON_CHAR_BLUETOOTH="1";
	hidden const FONT_ICON_CHAR_NOTIFICATION="2";
	hidden const FONT_ICON_CHAR_RUNNER="3";
	hidden const FONT_ICON_CHAR_HEART="4";
	hidden const FONT_ICON_CHAR_CALORIES="5";
	
	//IINSTANCE VARIABLES 
	//general
	hidden var fontIcons, customFont, fontTextHR, fontTextNotification, fontTextDate, fontTextSeconds, fontTextBattery, fontTextSteps;
	hidden var colorHour, colorMinute, colorForeground, colorBackground;
	hidden var iconColorHeart, iconColorNotification, iconColorAlarm, iconColorRunner, iconColorBluetooth;
	hidden var showAlarm, showDate, showBluetooth, showHR, showSeconds, keepSecondsDisplayed, keepHRDisplayed, showNotification, showBatteryText;
	//coordinates
	hidden var co_Screen_Height, co_Screen_Width;
	hidden var co_Date_y, co_Clock_y;
	hidden var co_Seconds_y, co_Seconds_x, co_clip_Seconds_x, co_clip_Seconds_y,co_clip_Seconds_Width, co_clip_Seconds_Height;
	hidden var co_IconBT_x,co_IconBT_y;
	hidden var co_IconAlarm_x, co_IconAlarm_y;
	hidden var co_HR_y, co_clip_HR_x, co_clip_HR_y, co_clip_HR_Width, co_clip_HR_Height;
	hidden var co_StepsBar_x,co_StepsBar_y, co_StepsCount_y;
	hidden var co_IconNotif_x, co_IconNotif_y;
	hidden var co_ClockBottom_y, co_ClockTop_y;
	hidden var co_Battery_y;
	hidden var fontCustomHeight;
	hidden var zone01_x, zone01_y, zone01_w, zone01_h, zone01_cy;
	hidden var zone02_x, zone02_y, zone02_w, zone02_h, zone02_cy;
	hidden var zone03_x, zone03_y, zone03_w, zone03_h, zone03_cy;
	hidden var zone04_x, zone04_y, zone04_w, zone04_h, zone04_cy;
	hidden var zone05_x, zone05_y, zone05_w, zone05_h, zone05_cy;
	hidden var zone06_x, zone06_y, zone06_w, zone06_h, zone06_cy;
	hidden var zone07_x, zone07_y, zone07_w, zone07_h, zone07_cy;
	hidden var zone08_x, zone08_y, zone08_w, zone08_h, zone08_cy;
	hidden var row01_h, row02_h, row04_h, row05_h;
	
	//lines
//	hidden var Y_L1, Y_L2, Y_L3, Y_L4,Y_L5, Y_L6;
	//components
	hidden var batteryComponent, stepsComponent, caloriesComponent;
	hidden var computeCoordinatesRequired = false;
	hidden var colorMode, dateFormat;

	hidden var sleeping=false;
	
    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		fontIcons = Ui.loadResource(Rez.Fonts.fontIcons);
		
		reloadBasics(false);
		computeCoordinates(dc);
		
		batteryComponent = new BatteryComponent({
			:locX=>co_Screen_Width/2,
			:locY=>co_Battery_y,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:dc=>dc,
			:font=>fontTextBattery,
			:showText=>showBatteryText
		});
		
		stepsComponent = new StepsComponent({
			:dc=>dc,
			:locX=>zone08_x,
			:locY=>zone08_y,
			:height=>zone08_h,
			:width=>zone08_w,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:dc=>dc,
			:textFont=>fontTextSteps,
			:iconFont=>fontIcons,
			:iconChar=>FONT_ICON_CHAR_RUNNER,
			:iconColor=>iconColorRunner,
		});
		
		caloriesComponent = new CaloriesComponent({
			:dc=>dc,
			:locX=>zone08_x,
			:locY=>zone08_y,
			:height=>zone08_h,
			:width=>zone08_w,
			:bgc=>COLOR_TRANSPARENT,
			:fgc=>colorForeground,
			:dc=>dc,
			:textFont=>fontTextSteps,
			:iconFont=>fontIcons,
			:iconChar=>FONT_ICON_CHAR_CALORIES,
			:iconColor=>iconColorRunner,
		});
    }
    
    function computeCoordinates(dc){
    	//get screen dimensions
		co_Screen_Width = dc.getWidth();
        co_Screen_Height = dc.getHeight();
        
          //row 3
        zone04_cy = co_Screen_Height / 2;
        zone04_x = 0;
        zone04_y = zone04_cy - co_Screen_Height * HOUR_H_PERCENT / 2;
        zone04_w = co_Screen_Width;
        zone04_h = co_Screen_Height * HOUR_H_PERCENT;
        
        
        row01_h = zone04_y * 0.30;
        row02_h = zone04_y * 0.70;
        row04_h = (co_Screen_Height / 2 - zone04_h/2) * 0.40;
        row05_h = (co_Screen_Height / 2 - zone04_h/2) * 0.60;
        //row 1
        zone01_x = 0;
        zone01_y = 0;
        zone01_w = co_Screen_Width;
        zone01_h = row01_h;
        zone01_cy = zone01_y + zone01_h/2;
        
        //row 2
        zone02_x = 0;
        zone02_y = zone01_h;
        zone02_w = co_Screen_Width * 0.33;
        zone02_h = row02_h;
        zone02_cy = zone02_y + zone02_h / 2;
        
        zone03_x = zone02_w;
        zone03_y = zone01_h;
        zone03_w = co_Screen_Width * 0.67;
        zone03_h = row02_h;
        zone03_cy = zone03_y + zone03_h / 2;
              
        
        //row 4 
        zone05_x = 0;
        zone05_y = zone04_y + zone04_h;
        zone05_w = co_Screen_Width * 0.32;
        zone05_h = row04_h;
        zone05_cy = zone05_y + zone05_h / 2;
        
        zone06_x = zone05_w;
        zone06_y = zone05_y;
        zone06_w = co_Screen_Width * 0.36;
        zone06_h = row04_h;
        zone06_cy = zone06_y + zone06_h / 2;
        
        zone07_x = zone05_w + zone06_w;
        zone07_y = zone05_y;
        zone07_w = co_Screen_Width * 0.32;
        zone07_h = row04_h;
        zone07_cy = zone07_y + zone07_h / 2;
        
        //row 5
        zone08_x = 0;
        zone08_y = zone05_y + row04_h;
        zone08_w = co_Screen_Width;
        zone08_h = row05_h;
        zone08_cy = zone08_y + zone08_h / 2;
		
    	co_Battery_y = zone01_cy;
		
    	co_IconBT_x = LEFT_x;
    	co_IconBT_y = zone02_cy;
    	
    	var w = dc.getTextWidthInPixels(FONT_ICON_CHAR_BLUETOOTH, fontIcons);
    	co_IconAlarm_x = LEFT_x + w + ICON_PADDING;
    	co_IconAlarm_y = zone02_cy;

    	fontCustomHeight = dc.getFontHeight(customFont);
    	co_ClockTop_y = co_Screen_Height/2 - fontCustomHeight/2;
    	co_ClockBottom_y = co_Screen_Height/2 + fontCustomHeight/2;
    	co_Clock_y = zone04_cy;
    	

    	co_clip_Seconds_Width = dc.getTextWidthInPixels("44", fontTextSeconds);
    	co_clip_Seconds_Height =  dc.getFontHeight(fontTextSeconds);
    	co_Seconds_x = co_Screen_Width - RIGHT_x;
    	co_Seconds_y = co_ClockBottom_y + co_clip_Seconds_Height / 2;
    	co_clip_Seconds_x = co_Screen_Width- RIGHT_x - co_clip_Seconds_Width;
    	co_clip_Seconds_y = co_Seconds_y - co_clip_Seconds_Height/2;
    	
    	var fontDateH = dc.getFontHeight(fontTextDate);
    	co_Date_y =  co_ClockTop_y - fontDateH;
    	
    	co_IconNotif_x = LEFT_x;
    	co_IconNotif_y = zone05_cy;
    	
    	co_HR_y = zone05_cy;
    	co_clip_HR_Width = dc.getTextWidthInPixels(FONT_ICON_CHAR_HEART, fontTextHR) + ICON_PADDING + dc.getTextWidthInPixels("4444", fontTextHR);
    	co_clip_HR_Height =  dc.getFontHeight(fontIcons);
		if(dc.getFontHeight(fontIcons) > co_clip_HR_Height){
	  		co_clip_HR_Height = dc.getFontHeight(fontIcons);
		}
    	co_clip_HR_x = co_Screen_Width/2 - co_clip_HR_Width/2;
    	co_clip_HR_y = co_HR_y - co_clip_HR_Height/2;
    	
   
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
    	
		batteryComponent.draw(dc);
   		displayClock(dc);
   		
        if(!sleeping && showSeconds){
			displaySeconds(dc);  
		}
   		
       	displayBtAndAlarm(dc);
       	
       	if(showDate){
	        displayDate(dc);
       	}
		
		if(!sleeping && showHR){
		   displayHR(dc);
        }
        
//      	stepsComponent.draw(dc);
      	caloriesComponent.draw(dc);
      	
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
        dc.drawRectangle(zone01_x, zone01_y, zone01_w, zone01_h);
        dc.drawRectangle(zone02_x, zone02_y, zone02_w, zone02_h);
        dc.drawRectangle(zone03_x, zone03_y, zone03_w, zone03_h);
       	dc.drawRectangle(zone04_x, zone04_y, zone04_w, zone04_h);
  		dc.drawRectangle(zone05_x, zone05_y, zone05_w, zone05_h);
		dc.drawRectangle(zone06_x, zone06_y, zone06_w, zone06_h);
    	dc.drawRectangle(zone07_x, zone07_y, zone07_w, zone07_h);
    	dc.drawRectangle(zone08_x, zone08_y, zone08_w, zone08_h);
       	
       	 
        dc.setColor(Gfx.COLOR_BLUE, colorBackground);
        dc.drawLine(zone01_x, zone01_cy, zone01_x+zone01_w, zone01_cy);
        dc.drawLine(zone02_x, zone02_cy, zone02_x+zone02_w, zone02_cy);
        dc.drawLine(zone03_x, zone03_cy, zone03_x+zone03_w, zone03_cy);
        dc.drawLine(zone04_x, zone04_cy, zone04_x+zone04_w, zone04_cy);
 		dc.drawLine(zone05_x, zone05_cy, zone05_x+zone05_w, zone05_cy);
       	dc.drawLine(zone06_x, zone06_cy, zone06_x+zone06_w, zone06_cy);
       	dc.drawLine(zone07_x, zone07_cy, zone07_x+zone07_w, zone07_cy);
       	dc.drawLine(zone08_x, zone08_cy, zone08_x+zone08_w, zone08_cy);
    }
    
    function onPartialUpdate(dc){
    	if(computeCoordinatesRequired){
    		computeCoordinates(dc);
    	}
    	
		dc.clearClip();
  		
  		if(showHR && keepHRDisplayed){
	  		dc.setClip(co_clip_HR_x, co_clip_HR_y, co_clip_HR_Width, co_clip_HR_Height);
	  		dc.setColor(colorBackground,colorBackground);
			dc.clear();
	  		
			displayHR(dc);
    	}
    	
    	if(showSeconds && keepSecondsDisplayed){
    		dc.setClip(co_clip_Seconds_x, co_clip_Seconds_y, co_clip_Seconds_Width, co_clip_Seconds_Height);
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
  		showHR = Utils.getPropertyValue(Cst.PROP_SHOW_HR);
  		showSeconds = Utils.getPropertyValue(Cst.PROP_SHOW_SECONDS);
  		
  		keepHRDisplayed = Utils.getPropertyValue(Cst.PROP_HR_KEEP_DISPLAYED);
  		keepSecondsDisplayed = Utils.getPropertyValue(Cst.PROP_SECONDS_KEEP_DISPLAYED);
  		
  		dateFormat = Utils.getPropertyValue(Cst.PROP_DATE_FORMAT);
    }
    
    function reloadComponents(){
  		batteryComponent.setFont(fontTextBattery);
		batteryComponent.setForegroundColor(colorForeground);
		batteryComponent.setShowText(showBatteryText);
    }
    
    function reloadFonts(){
   		fontTextHR = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_HR);
   		fontTextNotification = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_NOTIFICATION);
   		fontTextBattery = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_BATTERY);
    	fontTextDate = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_DATE);
    	fontTextSeconds = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_SECONDS);
   		fontTextSteps = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_STEPS);
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
    		iconColorRunner = Utils.getRandomColor([colorBackground]);
    		iconColorBluetooth = Utils.getRandomColor([colorBackground]);
    		
    		batteryComponent.setForegroundColor(colorForeground);
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
    function displayHR(dc){
	    var width = dc.getTextWidthInPixels(FONT_ICON_CHAR_HEART, fontIcons);
		var hrText = retrieveHeartrateText();
	    var iconWidthAndPadding = width + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextHR) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;

		dc.setColor(iconColorHeart,COLOR_TRANSPARENT);
		dc.drawText(start, co_HR_y, fontIcons, FONT_ICON_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
		dc.drawText(start+iconWidthAndPadding, co_HR_y, fontTextHR, hrText, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
	
    private function retrieveHeartrateText() {
		var hr = Activity.getActivityInfo().currentHeartRate;
		if(null != hr){
			return hr.format("%d");
		}
		return "000";
    }    
    
 
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
		dc.drawText(co_Seconds_x, co_Seconds_y, fontTextSeconds, System.getClockTime().sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
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
