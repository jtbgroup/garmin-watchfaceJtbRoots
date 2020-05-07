using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Mon;
using JTBUtils as Utils;
using RootsConstants as Cst;

public class RootsJtbView extends Ui.WatchFace {

	//DEBUG
	hidden var showLines = false;
	
	//CONSTANTS
	//positions
	hidden const LEFT_X = 35;
	hidden const RIGHT_X = 35;
	hidden const L1 = 13;
	hidden const L2p = 0.20;
	hidden const L4p = 0.78;
	hidden const L6 = 35;
	
	//colors
	hidden const COLOR_TRANSPARENT = Gfx.COLOR_TRANSPARENT;
	hidden const COLOR_BATTERY_LOW = Gfx.COLOR_RED;
	hidden const COLOR_BATTERY_MEDIUM = Gfx.COLOR_YELLOW;
	hidden const COLOR_BATTERY_HIGH = Gfx.COLOR_GREEN;
    hidden const COLOR_STEPSBAR_0=0xFF0000;
	hidden const COLOR_STEPSBAR_25=0xFFAA00;
	hidden const COLOR_STEPSBAR_75=0xAA55FF;
    hidden const COLOR_STEPSBAR_100=0x00FF00;
	hidden const STEPSBAR_WIDTH = 80;
	hidden const STEPSBAR_HEIGHT = 8;
	hidden const BATTERY_WIDTH = 22;
	hidden const BATTERY_HEIGHT = 10;
	hidden const BATTERY_DOP_WIDTH = 2;
	hidden const BATTERY_DOP_HEIGHT = 5;
	hidden const ICON_PADDING = 3;
	
	hidden const FONT_ICON_CHAR_ALARM="0";
	hidden const FONT_ICON_CHAR_BLUETOOTH="1";
	hidden const FONT_ICON_CHAR_NOTIFICATION="2";
	hidden const FONT_ICON_CHAR_RUNNER="3";
	hidden const FONT_ICON_CHAR_HEART="4";
	
	//IINSTANCE VARIABLES 
	//general
	hidden var fontIcons, customFont, fontTextSmall, fontTextMedium;
	hidden var colorHour, colorMinute, colorForeground, colorBackground;
	hidden var iconColorHeart, iconColorNotification, iconColorAlarm, iconColorRunner, iconColorBluetooth;
	hidden var sleeping=false;
	//coordinates
	hidden var co_Screen_Height, co_Screen_Width;
	hidden var co_Date_y, co_Clock_y, co_Seconds_y;
	hidden var co_IconBT_x,co_IconBT_y;
	hidden var co_IconAlarm_x, co_IconAlarm_y;
	hidden var co_HR_y;
	hidden var co_StepsBar_x,co_StepsBar_y, co_StepsCount_y;
	hidden var co_IconNotif_x, co_IconNotif_y;
	hidden var co_Battery_x, co_Battery_y, co_BatteryDop_x,co_BatteryDop_y, co_Battery_text_x, co_Battery_text_y;
	hidden var co_ClockBottom_y, co_ClockTop_y;
	hidden var fontCustomHeight, fontTextMediumHeight;
	//lines
	hidden var Y_L1, Y_L2, Y_L3, Y_L4,Y_L5, Y_L6;
	
    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		fontIcons = Ui.loadResource(Rez.Fonts.fontIcons);
		
		reloadBasics();
		computeCoordinates(dc);
    }
    
    function computeCoordinates(dc){
    	//get screen dimensions
		co_Screen_Width = dc.getWidth();
        co_Screen_Height = dc.getHeight();
        
		Y_L1=L1;
		Y_L2=co_Screen_Height*L2p;
		Y_L3=co_Screen_Height/2;
		Y_L4=co_Screen_Height*L4p;
		Y_L6=co_Screen_Height-L6;
		
		co_Battery_x = co_Screen_Width / 2 ;
    	co_Battery_y = Y_L1;
		
		co_Battery_text_x = co_Screen_Width/2;
		co_Battery_text_y = Y_L1;

    	co_IconBT_x = LEFT_X;
    	co_IconBT_y = Y_L2;
    	
    	var w = dc.getTextWidthInPixels(FONT_ICON_CHAR_BLUETOOTH, fontIcons);
    	co_IconAlarm_x = LEFT_X + w + ICON_PADDING;
    	co_IconAlarm_y = Y_L2;

    	fontCustomHeight = dc.getFontHeight(customFont);
    	fontTextMediumHeight = dc.getFontHeight(fontTextMedium);
    	co_ClockTop_y = co_Screen_Height/2 - fontCustomHeight/2;
    	co_ClockBottom_y = co_Screen_Height/2 + fontCustomHeight/2;
    	co_Clock_y = Y_L3;
    	
    	co_Seconds_y = co_ClockBottom_y;
    	co_Date_y =  co_ClockTop_y - fontTextMediumHeight;
    	
    	co_IconNotif_x = LEFT_X;
    	co_IconNotif_y = Y_L4;
    	
    	co_HR_y = Y_L4;
    	
		co_StepsBar_x = co_Screen_Width/2 - STEPSBAR_WIDTH/2;
    	co_StepsBar_y = Y_L6;
    	co_StepsCount_y = co_StepsBar_y+18;
    	
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
    	
        displayBattery(dc);
   		displayClock(dc);
       	displayBtAndAlarm(dc);
        displayDate(dc);
		
		if(!sleeping && Utils.getPropertyValue(Cst.PROP_SHOW_HR)){
		   displayHr(dc);
        }
        
      	displaySteps(dc);
      	
      	if(Utils.getPropertyValue(Cst.PROP_SHOW_NOTIFICATION)){
        	displayNotifications(dc);
        }
        
        // This is useful for Ui debugging
        if(showLines){
		    drawGridLines(dc);
	    }
    }
    
    function drawGridLines(dc){
		dc.setColor(colorForeground, colorBackground);
        dc.drawLine(0, Y_L1, co_Screen_Width, Y_L1);
        dc.drawLine(0, Y_L2, co_Screen_Width, Y_L2);
        dc.drawLine(0, Y_L3, co_Screen_Width, Y_L3);
        dc.drawLine(0, Y_L4, co_Screen_Width, Y_L4);
        dc.drawLine(0, Y_L6, co_Screen_Width, Y_L6);
        
        dc.drawLine(0, co_ClockBottom_y, co_Screen_Width, co_ClockBottom_y);
        dc.drawLine(0, co_ClockTop_y, co_Screen_Width, co_ClockTop_y);
    }
    
    function onPartialUpdate(dc){
    	var showHr = Utils.getPropertyValue(Cst.PROP_SHOW_HR);
    	var keepDisp = Utils.getPropertyValue(Cst.PROP_HR_KEEP_DISPLAYED);
    	var width = dc.getTextWidthInPixels(FONT_ICON_CHAR_HEART, fontIcons);
    
  		if(sleeping && showHr && keepDisp){
  			var clipWidth = width + ICON_PADDING+dc.getTextWidthInPixels("0000", fontTextSmall);
  			var clipHeight = dc.getFontHeight(fontIcons);
			if(fontTextMediumHeight > clipHeight){
	  			clipHeight = fontTextMediumHeight;
			}
  			var clipX = co_Screen_Width/2-clipWidth/2;
  			var clipY = co_HR_y - clipHeight/2;
	  		dc.setClip(clipX, clipY, clipWidth, clipHeight);
	  		dc.setColor(colorBackground, colorBackground);
	  		dc.fillRectangle(clipX, clipY, clipWidth, clipHeight);
	  		
		    var iconWidthAndPadding = width + ICON_PADDING;
			var hrText = retrieveHeartrateText();	  		
	  		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextSmall) + iconWidthAndPadding;
			var start = co_Screen_Width/ 2.0 - size/2.0;
	  		dc.setColor(iconColorHeart, colorBackground);
		    dc.drawText(start, co_HR_y, fontIcons, FONT_ICON_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
			dc.setColor(colorForeground, colorBackground);
			dc.drawText(start+iconWidthAndPadding, co_HR_y-ICON_PADDING, fontTextSmall, hrText, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    	}
    }
    
 	function reloadBasics(){
    	reloadBasicColors();
    	reloadFonts();
    }
    
    function reloadFonts(){
   		fontTextSmall = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_TXT01);
   		fontTextMedium = Utils.getPropertyAsFont(Cst.PROP_FONT_SIZE_TXT02);
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
    }
    
	function loadColorModeColors(){
       	if(Utils.getPropertyValue(Cst.PROP_MODE_COLOR) == Cst.OPTION_MODE_COLOR_DISCO){
    		var color = Utils.getRandomColor(colorBackground);
    		colorHour = color;
    		colorMinute = color;
    	}else if(Utils.getPropertyValue(Cst.PROP_MODE_COLOR) == Cst.OPTION_MODE_COLOR_LUCY){
    		var color = Utils.getRandomColor(null);
    		colorBackground = color;
    		colorHour = Utils.getRandomColor(color);
    		colorMinute = Utils.getRandomColor(color);
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
   		var iconWidthAndPadding = dc.getTextWidthInPixels(FONT_ICON_CHAR_RUNNER, fontIcons) + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), fontTextSmall) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;
		dc.setColor(iconColorRunner,COLOR_TRANSPARENT);
		dc.drawText(start, co_StepsCount_y, fontIcons, FONT_ICON_CHAR_RUNNER, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,COLOR_TRANSPARENT);
	  	dc.drawText(start+iconWidthAndPadding, co_StepsCount_y,  fontTextSmall, stepsCount.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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
			dc.drawText(co_IconNotif_x + w + ICON_PADDING, co_IconNotif_y, fontTextSmall, notif.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);	    	
		}
    }

/**
	------------------------
	BLUETOOTH & ALARM
	------------------------
*/
	function displayBtAndAlarm(dc){
		
		if(System.getDeviceSettings().phoneConnected){
			dc.setColor(iconColorBluetooth,COLOR_TRANSPARENT);
		    dc.drawText(co_IconBT_x, co_IconBT_y, fontIcons, FONT_ICON_CHAR_BLUETOOTH, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		}
	    
	    if(System.getDeviceSettings().alarmCount >= 1){
	   	 	dc.setColor(iconColorAlarm,COLOR_TRANSPARENT);
		    dc.drawText(co_IconAlarm_x, co_IconAlarm_y, fontIcons, FONT_ICON_CHAR_ALARM, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		}
	}


/**
	------------------------
	HEARTH RATE
	------------------------
*/
    function displayHr(dc){
	    var width = dc.getTextWidthInPixels(FONT_ICON_CHAR_HEART, fontIcons);
		var hrText = retrieveHeartrateText();
	    var iconWidthAndPadding = width + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextSmall) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;

		dc.setColor(iconColorHeart,COLOR_TRANSPARENT);
		dc.drawText(start, co_HR_y, fontIcons, FONT_ICON_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
		dc.drawText(start+iconWidthAndPadding, co_HR_y, fontTextSmall, hrText, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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
        
        //draw sec
        if(!sleeping && Utils.getPropertyValue(Cst.PROP_SHOW_SECONDS)){
			dc.drawText(co_Screen_Width - RIGHT_X, co_Seconds_y, fontTextMedium, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);  
		}
    }

/**
	------------------------
	BATTERY
	------------------------
*/
	function displayBattery(dc){
		displayBatteryIcon(dc, COLOR_BATTERY_LOW, COLOR_BATTERY_MEDIUM, COLOR_BATTERY_HIGH);
       	displayBatteryPercent(dc);
	}
	
    function displayBatteryPercent(dc){
	   	var battery = Sys.getSystemStats().battery;
		dc.setColor(colorForeground, COLOR_TRANSPARENT);
	   	dc.drawText(co_Battery_text_x, co_Battery_text_y, fontTextSmall, battery.format("%d")+"%", Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
    
    function displayBatteryIcon(dc, lowBatteryColor, mediumBatteryColor, fullBatteryColor) {
    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
        var battery = Sys.getSystemStats().battery;
      	
      	var fillColor = fullBatteryColor;
      
        if(battery < 25.0){
            fillColor = lowBatteryColor;
        }else if(battery < 50.0){
        	fillColor = mediumBatteryColor;
        }

        dc.setColor(colorForeground,COLOR_TRANSPARENT);
        var startX = co_Battery_x - BATTERY_WIDTH - BATTERY_DOP_WIDTH - ICON_PADDING;
        var startY = co_Battery_y - BATTERY_HEIGHT / 2;
        dc.drawRectangle(startX, startY, BATTERY_WIDTH, BATTERY_HEIGHT);
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
//        dc.drawLine(co_BatteryDop_x-1, co_BatteryDop_y+1, co_BatteryDop_x-1, co_BatteryDop_y + BATTERY_DOP_HEIGHT-1);

        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.fillRectangle(startX + BATTERY_WIDTH, co_Battery_y - BATTERY_DOP_HEIGHT / 2, BATTERY_DOP_WIDTH, BATTERY_DOP_HEIGHT);
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
//        dc.drawLine(co_BatteryDop_x, co_BatteryDop_y+1, co_BatteryDop_x, co_BatteryDop_y + BATTERY_DOP_HEIGHT-1);

		var fillBar = ((BATTERY_WIDTH -2 ) * battery / 100);
		var fillBar2 = Math.round(fillBar);
		//System.println("battery=" + battery + " --- prog=" + fillBar +" or "+ fillBar2 );
		
        dc.setColor(fillColor, COLOR_TRANSPARENT);
        dc.fillRectangle(startX + 1, startY + 1, fillBar2, BATTERY_HEIGHT-2);
    }

/**
	------------------------
	DATE
	------------------------
*/
	function displayDate(dc){
        var dateStr = formatDate();
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawText(co_Screen_Width - RIGHT_X,co_Date_y, fontTextMedium, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
    }

	function formatDate(){
		var now = Time.now();
		
		if (Utils.getPropertyValue(Cst.PROP_DATE_FORMAT) == Cst.OPTION_DATE_FORMAT_DAYNUM_MONTHNUM_YEARNUM){
			var info = Calendar.info(now, Time.FORMAT_SHORT);
	       return Lang.format("$1$/$2$/$3$", [info.day.format("%02d"), info.month.format("%02d"), info.year]);
		}else if (Utils.getPropertyValue(Cst.PROP_DATE_FORMAT) == Cst.OPTION_DATE_FORMAT_MONTH_NUM_DAYNUM_YEARNUM){
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
