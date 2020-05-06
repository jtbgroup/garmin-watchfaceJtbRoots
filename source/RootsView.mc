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
	hidden var showLines = true;
	
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
	hidden const ICON_CHAR_NOTIFICATION = "(";
	hidden const ICON_CHAR_HEART = "Y";
	
	//IINSTANCE VARIABLES 
	//general
	hidden var customFont, fontTextSmall, fontTextMedium, fontIconHeart, fontIconNotification = null;
	hidden var colorBackground, colorHour, colorMinute, colorForeground, colorIconNotification, colorIconHeart;
	hidden var iconBT, iconAlarm, iconRunner = null;
	hidden var showSeconds, showHR, showNotification, dateFormat, colorMode;
	hidden var sleeping=false;
	hidden var batteryComponent;
	//coordinates
	hidden var co_Screen_Height, co_Screen_Width;
	hidden var co_Date_y, co_Clock_x, co_Clock_y, co_Seconds_y;
	hidden var co_IconBT_x,co_IconBT_y;
	hidden var co_IconAlarm_x, co_IconAlarm_y;
	hidden var co_HR_y;
	hidden var co_StepsBar_x,co_StepsBar_y, co_StepsCount_y;
	hidden var co_IconNotif_x, co_IconNotif_y, co_IconNotifText_x;
	hidden var co_Battery_x, co_Battery_y, co_BatteryDop_x,co_BatteryDop_y, co_Battery_text_x, co_Battery_text_y;
	//lines
	hidden var Y_L1, Y_L2, Y_L3, Y_L4,Y_L5, Y_L6,Y_LCLOCK_BOTTOM, Y_LCLOCK_TOP;
	
	function initialize (){
		Ui.WatchFace.initialize();
	}
	
    function onLayout(dc) {
		customFont = Ui.loadResource(Rez.Fonts.customFont);
		fontTextSmall = Ui.loadResource(Rez.Fonts.fontTextSmall);
		fontTextMedium = Gfx.FONT_SYSTEM_SMALL;
		fontIconHeart = Ui.loadResource(Rez.Fonts.fontIconHeart);
		fontIconNotification = Ui.loadResource(Rez.Fonts.fontIconNotification);
		
		reloadBasics();
		computeCoordinates(dc);
		
		
		batteryComponent = new BatteryComponent({
			:locX => co_Screen_Height/2,
			:locY => co_Battery_y,
			:fgc => colorForeground,
			:dc => dc,
		});
    }
    
    function computeCoordinates(dc){
    	//get screen dimensions
		co_Screen_Width = dc.getWidth();
        co_Screen_Height = dc.getHeight();
        
		Y_L1=15;
		Y_L2=co_Screen_Height*0.15;
		Y_L3=co_Screen_Height/2;
		Y_L4=co_Screen_Height*0.78;
		Y_L6=co_Screen_Height-38;
		Y_LCLOCK_TOP=co_Screen_Height/2-dc.getFontHeight(customFont)/2;
		Y_LCLOCK_BOTTOM=co_Screen_Height/2+dc.getFontHeight(customFont)/2;
		
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

    	co_Date_y = Y_LCLOCK_TOP - dc.getFontHeight(fontTextMedium) ;
		
		co_Clock_x = co_Screen_Width/2;
    	co_Clock_y = Y_L3;
    	co_Seconds_y = Y_LCLOCK_BOTTOM;
    	
    	co_IconNotif_x = LEFT_X;
    	co_IconNotif_y = Y_L4;
    	co_IconNotifText_x = co_IconNotif_x + dc.getTextWidthInPixels(ICON_CHAR_NOTIFICATION, fontIconNotification) + ICON_PADDING;
    	
    	co_HR_y=Y_L4;
    	
		co_StepsBar_x = co_Screen_Width/2 - STEPSBAR_WIDTH/2;
    	co_StepsBar_y = Y_L6;
    	co_StepsCount_y = co_StepsBar_y+20;
    	
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
  			var clipWidth = ICON_HEARTH_WIDTH + ICON_PADDING+dc.getTextWidthInPixels("000", fontTextSmall);
  			var clipHeight = ICON_HEARTH_HEIGHT;
  			var clipX = co_Screen_Width/2-clipWidth/2;
  			var clipY = co_HR_y;
	  		dc.setClip(clipX, clipY, clipWidth, clipHeight);
	  		dc.setColor(colorBackground, colorBackground);
	  		dc.fillRectangle(clipX, clipY, clipWidth, clipHeight);
	  		
		    var iconWidthAndPadding = ICON_HEARTH_WIDTH + ICON_PADDING;
			var hrText = retrieveHeartrateText();	  		
	  		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextSmall) + iconWidthAndPadding;
			var start = co_Screen_Width/ 2.0 - size/2.0;
	  	
			dc.setColor(colorIconHeart, COLOR_TRANSPARENT);
		//  dc.drawBitmap(start, co_HR_y, iconHeart);
			dc.drawText(start, co_HR_y, fontIconHeart, ICON_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
			
	  		dc.setColor(colorForeground, colorBackground);
			//dc.drawText(start+iconWidthAndPadding, co_HR_y-ICON_PADDING, fontTextSmall, hrText, Gfx.TEXT_JUSTIFY_LEFT);
			dc.drawText(start+iconWidthAndPadding, co_HR_y, fontTextSmall, hrText ,Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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
		iconBT = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_BLUETOOTH, Cst.PROP_ICON_COLOR_BLUETOOTH) );
		iconAlarm = Ui.loadResource( Helper.getColoredIcon(Cst.DICT_ICON_ALARM, Cst.PROP_ICON_COLOR_ALARM) );
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
    	colorIconHeart = Helper.getColorById(Helper.getPropertyValue(Cst.PROP_ICON_COLOR_HEART));
    	colorIconNotification = Helper.getColorById(Helper.getPropertyValue(Cst.PROP_ICON_COLOR_NOTIFICATION));
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
    		
			iconBT = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_BLUETOOTH, [colorBackground]) );
			iconAlarm = Ui.loadResource( Helper.getRandomColoredIcon(Cst.DICT_ICON_ALARM, [colorBackground]) );
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
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), fontTextSmall) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;
		dc.setColor(colorForeground,COLOR_TRANSPARENT);
		dc.drawBitmap(start,co_StepsCount_y-5, iconRunner );
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
//		    dc.drawBitmap(co_IconNotif_x, co_IconNotif_y , iconNotification);
			dc.setColor(colorIconNotification, COLOR_TRANSPARENT);
			dc.drawText(co_IconNotif_x, co_IconNotif_y, fontIconNotification, ICON_CHAR_NOTIFICATION, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	    	dc.setColor(colorForeground, COLOR_TRANSPARENT);
			dc.drawText(co_IconNotifText_x, co_IconNotif_y, fontTextSmall, notif.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);	    	
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
   		var size = dc.getTextWidthInPixels(hrText.toString(), fontTextSmall) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;

    	dc.setColor(colorIconHeart, COLOR_TRANSPARENT);
//		dc.drawBitmap(start, co_HR_y, iconHeart);
		dc.drawText(start, co_HR_y, fontIconHeart, ICON_CHAR_HEART, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
//		Sys.println("height: " + dc.getFontHeight(webdingFont) + " - width: "+dc.getTextWidthInPixels("Y", webdingFont) );
		
		dc.setColor(colorForeground, COLOR_TRANSPARENT);
		dc.drawText(start+iconWidthAndPadding, co_HR_y, fontTextSmall, hrText ,Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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
			dc.drawText(co_Screen_Width-40,co_Seconds_y, fontTextMedium, clockTime.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);  
		}
    }

/**
	------------------------
	BATTERY
	------------------------
*/
	function displayBattery(){
//		displayBatteryIcon(dc, COLOR_BATTERY_LOW, COLOR_BATTERY_MEDIUM, COLOR_BATTERY_HIGH);
//       	displayBatteryPercent(dc);
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
        dc.drawText(co_Screen_Width - 35,co_Date_y, fontTextMedium, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
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
