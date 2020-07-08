using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BatteryComponent extends Ui.Drawable {

	hidden const COLOR_BATTERY_LOW = Gfx.COLOR_RED;
	hidden const COLOR_BATTERY_MEDIUM = Gfx.COLOR_YELLOW;
	hidden const COLOR_BATTERY_HIGH = Gfx.COLOR_GREEN;
	
	hidden const BATTERY_WIDTH = 22;
	hidden const BATTERY_HEIGHT = 10;
	hidden const BATTERY_DOP_WIDTH = 2;
	hidden const BATTERY_DOP_HEIGHT = 5;
	
	hidden const ICON_PADDING = 3;
	
	hidden var colorForeground,colorBackground;
	hidden var co_Battery_x = -1;
	hidden var co_Battery_y, co_BatteryDop_x,co_BatteryDop_y, co_Battery_text_x, co_Battery_text_y;
	hidden var x, y, font, showText;
	hidden var lastBatteryValue;
	 
    function initialize(params) {
        Drawable.initialize(params);
        me.x=locX;
        me.y=locY;
      	me.colorForeground=params.get(:fgc);
		me.colorBackground=params.get(:bgc);
		me.font=params.get(:font);
		me.showText=params.get(:showText);
		
		computeCoordinatesY();
    }
    
    private function computeCoordinatesY(){
    	co_Battery_y = y - BATTERY_HEIGHT/2;
		co_BatteryDop_y = y - BATTERY_DOP_HEIGHT/2;
		co_Battery_text_y = y;
    }
    
    private function computeCoordinatesX(dc, textPercent){
    	var textSize = 0;
    	var totalWidth = 0;
    	if(showText){
    		textSize = dc.getTextWidthInPixels(textPercent, font);
			totalWidth = BATTERY_WIDTH + BATTERY_DOP_WIDTH + ICON_PADDING*2 + textSize;
        }else{
        	totalWidth = BATTERY_WIDTH;
        }
		co_Battery_x = x - totalWidth/2;
    	co_BatteryDop_x = co_Battery_x + BATTERY_WIDTH;
		co_Battery_text_x = co_BatteryDop_x + ICON_PADDING*2;
    }

	function draw(dc){
		if(co_Battery_x == -1){
			computeCoordinatesX(dc, "100%");
		}
		displayBattery(dc);	
	}
	
	private function displayBattery(dc){
		var battery = Sys.getSystemStats().battery;
		var batteryTxt = battery.format("%d")+"%";
		if(lastBatteryValue != battery){
	   		lastBatteryValue = battery;
			computeCoordinatesX(dc, batteryTxt);
		}
		
		displayBatteryIcon(dc, battery, COLOR_BATTERY_LOW, COLOR_BATTERY_MEDIUM, COLOR_BATTERY_HIGH);
		if(showText){
	       	displayBatteryPercent(dc, battery);
		}
	}
	
    private function displayBatteryPercent(dc, battery){
		var batteryTxt = battery.format("%d")+"%";
		dc.setColor(colorForeground, colorBackground);
	   	dc.drawText(co_Battery_text_x, co_Battery_text_y, font, batteryTxt, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
    
    private function displayBatteryIcon(dc, battery, lowBatteryColor, mediumBatteryColor, fullBatteryColor) {
    	dc.setColor(colorForeground, colorBackground);
      	
      	var fillColor = fullBatteryColor;
      
        if(battery < 25.0){
            fillColor = lowBatteryColor;
        }else if(battery < 50.0){
        	fillColor = mediumBatteryColor;
        }

        dc.setColor(colorForeground,colorBackground);
        dc.drawRectangle(co_Battery_x, co_Battery_y, BATTERY_WIDTH, BATTERY_HEIGHT);

        dc.setColor(colorForeground, colorBackground);
        dc.fillRectangle(co_BatteryDop_x, co_BatteryDop_y, BATTERY_DOP_WIDTH, BATTERY_DOP_HEIGHT);

		var fillBar = ((BATTERY_WIDTH -2 ) * battery / 100);
		var fillBar2 = Math.round(fillBar);
		
        dc.setColor(fillColor, colorBackground);
        dc.fillRectangle(co_Battery_x +1 , co_Battery_y+1, fillBar2, BATTERY_HEIGHT-2);
    }
    
    function setFont(font){
    	me.font=font;
    }
    
    function setForegroundColor(colorForeground){
    	me.colorForeground=colorForeground;
    }
    
     function setShowText(showText){
    	me.showText=showText;
    	lastBatteryValue=-1;
    }
}