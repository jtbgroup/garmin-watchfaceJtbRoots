using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Mon;
using RootsConstants as Cst;
using JTBHelper as Helper;

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
	hidden const FONT_SMALL = Gfx.FONT_SYSTEM_XTINY;
	hidden const FONT_SECONDS = Gfx.FONT_SYSTEM_SMALL;
	hidden const FONT_DATE = Gfx.FONT_SYSTEM_SMALL;
	hidden const LEFT_X = 35;
	hidden const ICON_BT_WIDTH = 10;
	hidden const ICON_BT_HEIGHT = 20;
	hidden const ICON_PADDING = 3;
	hidden const ICON_NOTIFICATION_WIDTH = 29;
	hidden const ICON_HEARTH_WIDTH = 18;
	hidden const ICON_HEARTH_HEIGHT = 16;
	hidden const ICON_RUNNER_WIDTH = 11.0;
	hidden const STEPSBAR_WIDTH = 80;
	hidden const STEPSBAR_HEIGHT = 8;
	hidden const BATTERY_WIDTH = 22;
	hidden const BATTERY_HEIGHT = 10;
	hidden const BATTERY_DOP_WIDTH = 2;
	hidden const BATTERY_DOP_HEIGHT = 5;
	
	//IINSTANCE VARIABLES 
	//general
	hidden var customFont, microFont = null;
	hidden var colorBackground, colorHour, colorMinute, colorForeground;
	hidden var iconHeart, iconBT, iconAlarm, iconNotification, iconRunner = null;
<<<<<<< HEAD
	hidden var showSeconds, showHR, showNotification, dateFormat, colorMode;
=======
>>>>>>> refs/heads/1.5.0-branch
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
	//lines
	hidden var Y_L1, Y_L2, Y_L3, Y_L4,Y_L5, Y_L6;
	
	
	
	function initialize (){
		Ui.WatchFace.initialize();
	}
	
    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		microFont = Ui.loadResource(Rez.Fonts.microFont);
		
		reloadBasics();
		computeCoordinates(dc);
    }
    
    function computeCoordinates(dc){
    	//get screen dimensions
		co_Screen_Width = dc.getWidth();
        co_Screen_Height = dc.getHeight();
        
		Y_L1=10;
		Y_L2=co_Screen_Height*0.15;
		Y_L3=co_Screen_Height/2;
		Y_L4=co_Screen_Height*0.75;
		Y_L6=co_Screen_Height-38;
		
		co_Battery_x = (co_Screen_Width/ 2)  - (BATTERY_WIDTH) - (BATTERY_DOP_WIDTH) - ICON_PADDING;
    	co_Battery_y = Y_L1;
    	co_BatteryDop_x = co_Battery_x + BATTERY_WIDTH;
		co_BatteryDop_y = co_Battery_y + ((BATTERY_HEIGHT - BATTERY_DOP_HEIGHT) / 2);
		
		co_Battery_text_x = (co_Screen_Width/ 2) + ICON_PADDING;
		co_Battery_text_y = Y_L1 - 6;
		

    	co_IconBT_x = LEFT_X;
    	co_IconBT_y = Y_L2;
    	
    	co_IconAlarm_x = LEFT_X + ICON_BT_WIDTH + ICON_PADDING;
    	co_IconAlarm_y = Y_L2;

    	co_Date_y = Y_L2 ;

    	co_Clock_y = Y_L3;
    	co_Seconds_y = Y_L4;
    	
    	co_IconNotif_x = LEFT_X;
    	co_IconNotif_y = Y_L4;
    	
    	co_HR_y=Y_L4;
    	
		co_StepsBar_x = co_Screen_Width/2 - STEPSBAR_WIDTH/2;
    	co_StepsBar_y = Y_L6;
    	co_StepsCount_y = co_StepsBar_y+10;
    	
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
    }
    
    function onPartialUpdate(dc){
    	var keepDisp = Helper.getPropertyValue(Cst.PROP_HR_KEEP_DISPLAYED);
    
  		if(sleeping && showHR && keepDisp){
  			var clipWidth = ICON_HEARTH_WIDTH + ICON_PADDING+dc.getTextWidthInPixels("000", FONT_SMALL);
  			var clipHeight = ICON_HEARTH_HEIGHT;
  			var clipX = co_Screen_Width/2-clipWidth/2;
  			var clipY = co_HR_y;
	  		dc.setClip(clipX, clipY, clipWidth, clipHeight);
	  		dc.setColor(colorBackground, colorBackground);
	  		dc.fillRectangle(clipX, clipY, clipWidth, clipHeight);
	  		
		    var iconWidthAndPadding = ICON_HEARTH_WIDTH + ICON_PADDING;
			var hrText = retrieveHeartrateText();	  		
	  		var size = dc.getTextWidthInPixels(hrText.toString(), FONT_SMALL) + iconWidthAndPadding;
			var start = co_Screen_Width/ 2.0 - size/2.0;
	  		dc.setColor(colorForeground, colorBackground);
		    dc.drawBitmap(start, co_HR_y, iconHeart);
			dc.drawText(start+iconWidthAndPadding, co_HR_y-ICON_PADDING, FONT_SMALL, hrText, Gfx.TEXT_JUSTIFY_LEFT);
    	}
    }
    
 	function reloadBasics(){
    	reloadBasicColors();
    	reloadBasicIcons();
    	reloadOtherBasics();
    }
    
    function reloadOtherBasics(){
    	showSeconds = Helper.getPropertyValue(Cst.PROP_SHOW_SECONDS);
    	showHR = Helper.getPropertyValue(Cst.PROP_SHOW_HR);
    	showNotification = Helper.getPropertyValue(Cst.PROP_SHOW_NOTIFICATION);
    	colorMode = Helper.getPropertyValue(Cst.PROP_MODE_COLOR);
    	dateFormat = Helper.getPropertyValue(Cst.PROP_DATE_FORMAT);
    }
    
    function reloadBasicIcons(){
    	iconHeart = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_HEART, Cst.PROP_ICON_COLOR_HEART) );
		iconBT = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_BLUETOOTH, Cst.PROP_ICON_COLOR_BLUETOOTH) );
		iconAlarm = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_ALARM, Cst.PROP_ICON_COLOR_ALARM) );
		iconNotification = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_NOTIFICATION, Cst.PROP_ICON_COLOR_NOTIFICATION) );
		iconRunner = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_RUNNER, Cst.PROP_ICON_COLOR_RUNNER) );
    }
/**
	------------------------
	COLORS
	------------------------
*/
    function reloadBasicColors(){
    	colorBackground =  Helper.getPropertyValue(Cst.PROP_COLOR_BACKGROUND);
	    colorHour =  Helper.getPropertyValue(Cst.PROP_COLOR_CLOCK_HOUR);
    	colorMinute = Helper.getPropertyValue(Cst.PROP_COLOR_CLOCK_MIN);
    	colorForeground = Helper.getPropertyValue(Cst.PROP_COLOR_FOREGROUND);
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
    		
    		iconHeart = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_HEART, [colorBackground]) );
			iconBT = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_BLUETOOTH, [colorBackground]) );
			iconAlarm = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_ALARM, [colorBackground]) );
			iconNotification = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_NOTIFICATION, [colorBackground]) );
			iconRunner = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_RUNNER,  [colorBackground]) );
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
   		var iconWidthAndPadding = ICON_RUNNER_WIDTH + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), FONT_SMALL) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;
		dc.setColor(colorForeground,COLOR_TRANSPARENT);
		dc.drawBitmap(start,co_StepsCount_y, iconRunner );
	  	dc.drawText(start+iconWidthAndPadding, co_StepsCount_y-ICON_PADDING,  FONT_SMALL, stepsCount.toString(),Gfx.TEXT_JUSTIFY_LEFT);
	}
    

/**
	------------------------
	NOTIFICATIONS
	------------------------
*/
    function displayNotifications(dc){
    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
		var notif = System.getDeviceSettings().notificationCount;
		if(notif>0){
		    dc.drawBitmap(co_IconNotif_x, co_IconNotif_y , iconNotification);
			dc.drawText(co_IconNotif_x+ICON_NOTIFICATION_WIDTH+ICON_PADDING, co_IconNotif_y-ICON_PADDING, FONT_SMALL, notif.toString(),Gfx.TEXT_JUSTIFY_LEFT);	    	
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
		    dc.drawBitmap(co_IconBT_x, co_IconBT_y , iconBT);	
		}
	    
	    if(System.getDeviceSettings().alarmCount >= 1){
		    dc.drawBitmap(co_IconAlarm_x, co_IconAlarm_y , iconAlarm);	
		}
	}


/**
	------------------------
	HEARTH RATE
	------------------------
*/
    function displayHr(dc){
		var hrText = retrieveHeartrateText();
	    var iconWidthAndPadding = ICON_HEARTH_WIDTH + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(hrText.toString(), FONT_SMALL) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;

    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
		dc.drawBitmap(start, co_HR_y, iconHeart);
		dc.drawText(start+iconWidthAndPadding, co_HR_y-ICON_PADDING, FONT_SMALL, hrText ,Gfx.TEXT_JUSTIFY_LEFT);
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
		dc.drawText(co_Screen_Width/2, co_Clock_y, customFont, hourToString ,Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
		
		//draw min
        dc.setColor(colorMinute, COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, co_Clock_y, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]),Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
        
        //draw sec
        if(!sleeping && showSeconds){
			dc.drawText(co_Screen_Width-40,co_Seconds_y, FONT_SECONDS, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);  
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
	   	dc.drawText(co_Battery_text_x, co_Battery_text_y, FONT_SMALL, battery.format("%d")+"%", Gfx.TEXT_JUSTIFY_LEFT);
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
        dc.drawRectangle(co_Battery_x, co_Battery_y, BATTERY_WIDTH, BATTERY_HEIGHT);
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawLine(co_BatteryDop_x-1, co_BatteryDop_y+1, co_BatteryDop_x-1, co_BatteryDop_y + BATTERY_DOP_HEIGHT-1);

        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawRectangle(co_BatteryDop_x, co_BatteryDop_y, BATTERY_DOP_WIDTH, BATTERY_DOP_HEIGHT);
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawLine(co_BatteryDop_x, co_BatteryDop_y+1, co_BatteryDop_x, co_BatteryDop_y + BATTERY_DOP_HEIGHT-1);

		var fillBar = ((BATTERY_WIDTH -2 ) * battery / 100);
		var fillBar2 = Math.round(fillBar);
		//System.println("battery=" + battery + " --- prog=" + fillBar +" or "+ fillBar2 );
		
        dc.setColor(fillColor, COLOR_TRANSPARENT);
        dc.fillRectangle(co_Battery_x +1 , co_Battery_y+1, fillBar2, BATTERY_HEIGHT-2);
    }

/**
	------------------------
	DATE
	------------------------
*/
	function displayDate(dc){
        var dateStr = formatDate();
        dc.setColor(colorForeground, COLOR_TRANSPARENT);
        dc.drawText(co_Screen_Width - 35,co_Date_y, FONT_DATE, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
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
