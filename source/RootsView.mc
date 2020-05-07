using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Mon;
using RootsConstants as Cst;
using JTBUtils as Helper;

public class RootsJtbView extends Ui.WatchFace {

	//DEBUG
	hidden var showLines = false;
	
	//CONSTANTS	
	hidden const COLOR_TRANSPARENT = Gfx.COLOR_TRANSPARENT;
	hidden const COLOR_BATTERY_LOW = Gfx.COLOR_RED;
	hidden const COLOR_BATTERY_MEDIUM = Gfx.COLOR_YELLOW;
	hidden const COLOR_BATTERY_HIGH = Gfx.COLOR_GREEN;
    hidden const COLOR_STEPSBAR_0=0xFF0000;
	hidden const COLOR_STEPSBAR_25=0xFFAA00;
	hidden const COLOR_STEPSBAR_75=0xAA55FF;
    hidden const COLOR_STEPSBAR_100=0x00FF00;
	hidden const LEFT_X = 35;
	hidden const ICON_PADDING = 3;
	hidden const STEPSBAR_WIDTH = 80;
	hidden const STEPSBAR_HEIGHT = 8;
	hidden const ICON_FONT_CHAR_BLUETOOTH = "0";
	hidden const ICON_FONT_CHAR_ALARM = "1";
	hidden const ICON_FONT_CHAR_NOTIFICATION = "2";
	hidden const ICON_FONT_CHAR_RUNNER = "3";
	hidden const ICON_FONT_CHAR_HEART = "4";
	
	//IINSTANCE VARIABLES 
	//general
	hidden var customFont, fontText01, fontText02, fontIcons = null;
	hidden var colorBackground, colorHour, colorMinute, colorForeground, colorIconNotification, colorIconHeart,colorIconBluetooth, colorIconRunner, colorIconAlarm;
	hidden var icon_heart_width, icon_runner_width;
	hidden var showSeconds, showHR, showNotification, dateFormat, colorMode;
	hidden var sleeping=false;
	hidden var batteryComponent;
	//coordinates
	hidden var co_Screen_Height, co_Screen_Width;
	hidden var co_Battery_y;
	hidden var co_Date_y, co_Clock_x, co_Clock_y, co_Seconds_y;
	hidden var co_IconBT_x,co_IconBT_y;
	hidden var co_IconAlarm_x, co_IconAlarm_y;
	hidden var co_HR_y;
	hidden var co_StepsBar_x,co_StepsBar_y, co_StepsCount_y;
	hidden var co_IconNotif_x, co_IconNotif_y, co_IconNotifText_x;
	//lines
	hidden var Y_L1, Y_L2, Y_L3, Y_L4,Y_L5, Y_L6,Y_LCLOCK_BOTTOM, Y_LCLOCK_TOP;
	
	function initialize (){
		Ui.WatchFace.initialize();
	}
	
    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		fontIcons = Ui.loadResource(Rez.Fonts.fontIcons);
		
		reloadBasics(true);
		computeCoordinates(dc);
		
		batteryComponent = new BatteryComponent({
			:locX => co_Screen_Height/2,
			:locY => co_Battery_y,
			:fgc => colorForeground,
			:bgc => COLOR_TRANSPARENT,
			:dc => dc,
			:font => fontText01
		});
    }
    
    function computeCoordinates(dc){
    	//get screen dimensions
		co_Screen_Width = dc.getWidth();
        co_Screen_Height = dc.getHeight();
        
		Y_L1=15;
		Y_L2=co_Screen_Height*0.20;
		Y_L3=co_Screen_Height/2;
		Y_L4=co_Screen_Height*0.78;
		Y_L6=co_Screen_Height-30;
		Y_LCLOCK_TOP=co_Screen_Height/2-dc.getFontHeight(customFont)/2;
		Y_LCLOCK_BOTTOM=co_Screen_Height/2+dc.getFontHeight(customFont)/2;
		
		co_Battery_y = Y_L1;
		
    	co_IconBT_x = LEFT_X;
    	co_IconBT_y = Y_L2;
    	
    	var icon_bt_width = dc.getTextWidthInPixels(ICON_FONT_CHAR_BLUETOOTH, fontIcons);
    	co_IconAlarm_x = LEFT_X + icon_bt_width + ICON_PADDING;
    	co_IconAlarm_y = Y_L2;

    	co_Date_y = Y_LCLOCK_TOP - dc.getFontHeight(fontText02) ;
		
		co_Clock_x = co_Screen_Width/2;
    	co_Clock_y = Y_L3;
    	co_Seconds_y = Y_LCLOCK_BOTTOM;
    	
    	var icon_notification_width = dc.getTextWidthInPixels(ICON_FONT_CHAR_NOTIFICATION, fontIcons);
    	co_IconNotif_x = LEFT_X;
    	co_IconNotif_y = Y_L4;
    	co_IconNotifText_x = co_IconNotif_x + icon_notification_width + ICON_PADDING;
    	
    	co_HR_y=Y_L4;
    	icon_heart_width = dc.getTextWidthInPixels(ICON_FONT_CHAR_HEART, fontIcons);
    	
    	icon_runner_width = dc.getTextWidthInPixels(ICON_FONT_CHAR_RUNNER, fontIcons);
		co_StepsBar_x = co_Screen_Width/2 - STEPSBAR_WIDTH/2;
    	co_StepsBar_y = Y_L6;
    	co_StepsCount_y = co_StepsBar_y + 3 + dc.getFontHeight(fontIcons);
    	
    	// This is only to make UI debugging easier
		if(showLines){
	        System.println("screen height="+co_Screen_Height+", L1="+Y_L1+", L2="+Y_L2+", L3="+Y_L3+", L4="+Y_L4+", L6="+Y_L6);
	    }
    }

/**
	------------------------
	UPDATE THE VIEW
	------------------------
*/
    function onUpdate(dc) {
    	loadColorModeColors();
    
    	dc.clearClip();
    	dc.setColor(colorForeground, colorBackground);
    	dc.clear();
    	
        displayBattery();
   		displayClock(dc);
       	displayBtAndAlarm(dc);
        displayDate(dc);
		
		if(!sleeping && showHR){
		   displayHr(dc);
        }
        
      	displaySteps(dc);
      	
      	if(showNotification){
        	displayNotifications(dc);
        }
        
        // This is useful for Ui debugging
       if(showLines){
		    drawGridLines(dc);
	    }
    }
    
    (:debug) function drawGridLines(dc){
		dc.setColor(colorForeground, colorBackground);
        dc.drawLine(0, Y_L1, co_Screen_Width, Y_L1);
        dc.drawLine(0, Y_L2, co_Screen_Width, Y_L2);
        dc.drawLine(0, Y_L3, co_Screen_Width, Y_L3);
        dc.drawLine(0, Y_L4, co_Screen_Width, Y_L4);
        dc.drawLine(0, Y_L6, co_Screen_Width, Y_L6);
		dc.drawLine(0, Y_LCLOCK_TOP, co_Screen_Width, Y_LCLOCK_TOP);
		dc.drawLine(0, Y_LCLOCK_BOTTOM, co_Screen_Width, Y_LCLOCK_BOTTOM);
    }
    
    function onPartialUpdate(dc){
    	var keepDisp = Helper.getPropertyValue(Cst.PROP_HR_KEEP_DISPLAYED);
    
  		if(sleeping && showHR && keepDisp){
  			var clipWidth = icon_heart_width + ICON_PADDING+dc.getTextWidthInPixels("000", fontTextSmall);
  			var clipHeight = dc.getFontHeight(fontIcons);
  			var clipX = co_Screen_Width/2-clipWidth/2;
  			var clipY = co_HR_y;
	  		dc.setClip(clipX, clipY, clipWidth, clipHeight);
	  		dc.setColor(colorBackground, colorBackground);
	  		dc.fillRectangle(clipX, clipY, clipWidth, clipHeight);
	  		
		    var iconWidthAndPadding = icon_heart_width + ICON_PADDING;
			var hrText = retrieveHeartrateText();	  		
	  		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextSmall) + iconWidthAndPadding;
			var start = co_Screen_Width/ 2.0 - size/2.0;
	  	
			dc.setColor(colorIconHeart, COLOR_TRANSPARENT);
			dc.drawText(start, co_HR_y, fontIcons, ICON_FONT_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
			
	  		dc.setColor(colorForeground, colorBackground);
			dc.drawText(start+iconWidthAndPadding, co_HR_y, fontTextSmall, hrText ,Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    	}
    }
    
 	function reloadBasics(initialLoad){
    	reloadBasicColors();
    	reloadOtherBasics();
    	if(! initialLoad){
    		reloadComponents();
    	}
    }
    
    function reloadComponents(){
    	batteryComponent.setForegroundColor(colorForeground);
    	batteryComponent.setFont(fontText01);
    }
     
    function reloadOtherBasics(){
    	showSeconds = Helper.getPropertyValue(Cst.PROP_SHOW_SECONDS);
    	showHR = Helper.getPropertyValue(Cst.PROP_SHOW_HR);
    	showNotification = Helper.getPropertyValue(Cst.PROP_SHOW_NOTIFICATION);
    	colorMode = Helper.getPropertyValue(Cst.PROP_MODE_COLOR);
    	dateFormat = Helper.getPropertyValue(Cst.PROP_DATE_FORMAT);
    	
    	fontText01 = Helper.getPropertyAsFont(Cst.PROP_FONT_SIZE_TXT01);
    	fontText02 = Helper.getPropertyAsFont(Cst.PROP_FONT_SIZE_TXT02);
    }
/**
	------------------------
	COLORS
	------------------------
*/
    function reloadBasicColors(){
    	colorBackground =  Helper.getPropertyAsColor(Cst.PROP_COLOR_BACKGROUND);
	    colorHour =  Helper.getPropertyAsColor(Cst.PROP_COLOR_CLOCK_HOUR);
    	colorMinute = Helper.getPropertyAsColor(Cst.PROP_COLOR_CLOCK_MIN);
    	colorForeground = Helper.getPropertyAsColor(Cst.PROP_COLOR_FOREGROUND);
    	colorIconHeart = Helper.getPropertyAsColor(Cst.PROP_ICON_COLOR_HEART);
    	colorIconNotification = Helper.getPropertyAsColor(Cst.PROP_ICON_COLOR_NOTIFICATION);
    	colorIconBluetooth = Helper.getPropertyAsColor(Cst.PROP_ICON_COLOR_BLUETOOTH);
    	colorIconAlarm = Helper.getPropertyAsColor(Cst.PROP_ICON_COLOR_ALARM);
    	colorIconRunner = Helper.getPropertyAsColor(Cst.PROP_ICON_COLOR_RUNNER);
    }
    
	function loadColorModeColors(){
       	if(colorMode == Cst.OPTION_MODE_COLOR_DISCO){
    		var color = Helper.getRandomColor([colorBackground]);
    		colorHour = color;
    		colorMinute = color;
    	}else if(colorMode == Cst.OPTION_MODE_COLOR_LUCY){
    		var color = Helper.getRandomColor([colorBackground]);
    		colorBackground = color;
    		colorForeground = Helper.getRandomColor([colorBackground]);
    		colorHour = Helper.getRandomColor([colorBackground]);
    		colorMinute = Helper.getRandomColor([colorBackground, colorMinute]);
    		
    		colorIconHeart = Helper.getRandomColor([colorBackground]);
    		colorIconNotification = Helper.getRandomColor([colorBackground]);
    		colorIconBluetooth = Helper.getRandomColor([colorBackground]);
    		colorIconAlarm = Helper.getRandomColor([colorBackground]);
    		colorIconRunner = Helper.getRandomColor([colorBackground]);
    	}
    }
    
/**
	------------------------
	STEPS
	------------------------
*/
    function displaySteps(dc){
		var stepsCount = Mon.getInfo().steps;
        displayStepsBar(dc, stepsCount);
        displayStepsCounter(dc, stepsCount);
    }
    
    function displayStepsBar(dc, stepsCount){
        dc.drawRectangle(co_StepsBar_x, co_StepsBar_y, STEPSBAR_WIDTH, STEPSBAR_HEIGHT);
        
        var stepsCountGoal = Mon.getInfo().stepGoal;
        var goal = (stepsCount * 1.0 / stepsCountGoal * 1.0) ;
                        
        var fillColor = COLOR_STEPSBAR_25;
        var fillSize = (STEPSBAR_WIDTH -2.0) * goal;
        if(goal>=1.0){
	        fillColor=COLOR_STEPSBAR_100;
	        fillSize=STEPSBAR_WIDTH-2;
        }else if(goal >= 0.75){
        	fillColor=COLOR_STEPSBAR_75;
         }else if(goal <= 0.25){
        	fillColor=COLOR_STEPSBAR_0;
        }
        
        dc.setColor(fillColor, COLOR_TRANSPARENT);
        dc.fillRectangle(co_StepsBar_x + 1, co_StepsBar_y+2, fillSize, STEPSBAR_HEIGHT-4);
   }
   
   function displayStepsCounter(dc, stepsCount){
   		var iconWidthAndPadding = icon_runner_width + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), fontText01) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;
		dc.setColor(colorForeground,COLOR_TRANSPARENT);
	  	dc.drawText(start+iconWidthAndPadding, co_StepsCount_y,  fontText01, stepsCount.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	  	dc.setColor(colorIconRunner, COLOR_TRANSPARENT);
		dc.drawText(start, co_StepsCount_y, fontIcons, ICON_FONT_CHAR_RUNNER ,Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
    
/**
	------------------------
	NOTIFICATIONS
	------------------------
*/
    function displayNotifications(dc){
		var notif = System.getDeviceSettings().notificationCount;
		if(notif>0){
			dc.setColor(colorIconNotification, COLOR_TRANSPARENT);
			dc.drawText(co_IconNotif_x, co_IconNotif_y, fontIcons, ICON_FONT_CHAR_NOTIFICATION, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
			dc.drawText(co_IconNotifText_x, co_IconNotif_y, fontText01, notif.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);	    	
		}
    }

/**
	------------------------
	BLUETOOTH & ALARM
	------------------------
*/
	function displayBtAndAlarm(dc){
		dc.setColor(colorForeground, COLOR_TRANSPARENT);
		
		if(System.getDeviceSettings().phoneConnected){
			dc.setColor(colorIconBluetooth, COLOR_TRANSPARENT);
			dc.drawText(co_IconBT_x, co_IconBT_y, fontIcons, ICON_FONT_CHAR_BLUETOOTH, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		}
	    
	    if(System.getDeviceSettings().alarmCount >= 1){
		    dc.setColor(colorIconAlarm, COLOR_TRANSPARENT);
			dc.drawText(co_IconAlarm_x, co_IconAlarm_y, fontIcons, ICON_FONT_CHAR_ALARM, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);	
		}
	}


/**
	------------------------
	HEART RATE
	------------------------
*/
    function displayHr(dc){
		var hrText = retrieveHeartrateText();
	    var iconWidthAndPadding = icon_heart_width + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(hrText.toString(), fontText01) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;

    	dc.setColor(colorIconHeart, COLOR_TRANSPARENT);
		dc.drawText(start, co_HR_y, fontIcons, ICON_FONT_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		
		dc.setColor(colorForeground, COLOR_TRANSPARENT);
		dc.drawText(start+iconWidthAndPadding, co_HR_y, fontText01, hrText ,Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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
			dc.drawText(dc.getWidth()/2-hourWidth, (co_Screen_Height/2)-aOrPHeight, Gfx.FONT_SYSTEM_XTINY, aOrP, Gfx.TEXT_JUSTIFY_RIGHT);
			dc.drawText(dc.getWidth()/2-hourWidth, (co_Screen_Height/2), Gfx.FONT_SYSTEM_XTINY, "M", Gfx.TEXT_JUSTIFY_RIGHT);
		}
		dc.drawText(co_Clock_x, co_Clock_y, customFont, hourToString ,Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
		
		//draw min
        dc.setColor(colorMinute, COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, co_Clock_y, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]),Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
        
        //draw sec
        if(!sleeping && showSeconds){
			dc.drawText(co_Screen_Width-40,co_Seconds_y, fontText02, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);  
		}
    }

/**
	------------------------
	BATTERY
	------------------------
*/
	function displayBattery(){
		batteryComponent.draw();
	}
	

/**
	------------------------
	DATE
	------------------------
*/
	function displayDate(dc){
        var dateStr = formatDate();
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawText(co_Screen_Width - 35,co_Date_y, fontText02, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
    }

//TODO: THis must be reviewed to gain performance and not querying the properties every refresh
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
