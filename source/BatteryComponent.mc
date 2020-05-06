using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BatteryComponent extends Ui.Drawable {

	hidden var colorForeground,backgroundColor = Gfx.COLOR_RED;
	hidden const COLOR_BATTERY_LOW = Gfx.COLOR_RED;
	hidden const COLOR_BATTERY_MEDIUM = Gfx.COLOR_YELLOW;
	hidden const COLOR_BATTERY_HIGH = Gfx.COLOR_GREEN;
	hidden const COLOR_TRANSPARENT = Gfx.COLOR_TRANSPARENT;
	
		hidden const BATTERY_WIDTH = 22;
	hidden const BATTERY_HEIGHT = 10;
	hidden const BATTERY_DOP_WIDTH = 2;
	hidden const BATTERY_DOP_HEIGHT = 5;
	
		hidden const ICON_PADDING = 3;
		
			hidden var co_Battery_x, co_Battery_y, co_BatteryDop_x,co_BatteryDop_y, co_Battery_text_x, co_Battery_text_y;
	hidden const FONT_SMALL = Gfx.FONT_SYSTEM_XTINY;

	hidden var x, y, dc;
	 
    function initialize(params) {
        Drawable.initialize(params);
        me.x=locX;
        me.y=locY;
      	me.colorForeground=params.get(:fgc);
		me.backgroundColor=params.get(:bgc);
		me.dc=params.get(:dc);
		
		computeCoordinates();
    }
    
    function computeCoordinates(){
    	//get screen dimensions
    	var textSize = dc.getTextWidthInPixels("99%", FONT_SMALL);
        var totalWidth = BATTERY_WIDTH + BATTERY_DOP_WIDTH + ICON_PADDING + textSize;
        
		co_Battery_x =  x - totalWidth/2;
    	co_Battery_y = y - BATTERY_HEIGHT/2;
    	co_BatteryDop_x = x - totalWidth/2 + BATTERY_WIDTH;
		co_BatteryDop_y = y - BATTERY_DOP_HEIGHT/2;
		
		co_Battery_text_x = x - totalWidth/2 + BATTERY_WIDTH + BATTERY_DOP_WIDTH + ICON_PADDING;
		co_Battery_text_y = y;
    }

	function draw(){
		dc.setColor(colorForeground, COLOR_TRANSPARENT);
		dc.drawLine(x-100, y, x+100, y);
		dc.drawLine(x, y-10, x, y+10);
		displayBattery();	
	}
	
	function displayBattery(){
		displayBatteryIcon(COLOR_BATTERY_LOW, COLOR_BATTERY_MEDIUM, COLOR_BATTERY_HIGH);
       	displayBatteryPercent();
	}
	
    function displayBatteryPercent(){
	   	var battery = Sys.getSystemStats().battery;
		dc.setColor(colorForeground, COLOR_TRANSPARENT);
	   	dc.drawText(co_Battery_text_x, co_Battery_text_y, FONT_SMALL, battery.format("%d")+"%", Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
    
    function displayBatteryIcon(lowBatteryColor, mediumBatteryColor, fullBatteryColor) {
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
}