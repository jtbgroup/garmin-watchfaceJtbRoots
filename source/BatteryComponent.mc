using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BatteryComponent extends ZoneComponent {

	hidden const COLOR_BATTERY_LOW = Gfx.COLOR_RED;
	hidden const COLOR_BATTERY_MEDIUM = Gfx.COLOR_YELLOW;
	hidden const COLOR_BATTERY_HIGH = Gfx.COLOR_GREEN;
	
	hidden const BATTERY_WIDTH = 22;
	hidden const BATTERY_HEIGHT = 10;
	hidden const BATTERY_DOP_WIDTH = 2;
	hidden const BATTERY_DOP_HEIGHT = 5;
	
	hidden const BATTERY_ICON_PADDING = 6;
	
	hidden var co_Battery_x = -1;
	hidden var co_Battery_y, co_BatteryDop_x,co_BatteryDop_y, co_Battery_text_x, co_Battery_text_y;
	hidden var mode;
	
	const MODE_ICON_AND_VALUE = 0;
	const MODE_ICON = 1;
	const MODE_VALUE = 2;
	
    function initialize(params) {
       	ZoneComponent.initialize(params);
		me.mode=params.get(:mode);
		
		computeCoordinatesY();
    }
    
    private function computeCoordinatesY(){
		if(mode == MODE_ICON || mode == MODE_ICON_AND_VALUE){
	    	co_Battery_y = y + height/2 - BATTERY_HEIGHT/2;
			co_BatteryDop_y = y + height/2 - BATTERY_DOP_HEIGHT/2;
		}
		
		if(mode == MODE_VALUE || mode == MODE_ICON_AND_VALUE){
			co_Battery_text_y = y + height/2;
    	}
    }
    
    private function computeCoordinatesX(dc, textPercent){
		var textSize = 0;
    	var totalWidth = 0;
		if(mode == MODE_ICON_AND_VALUE){
			textSize = dc.getTextWidthInPixels(textPercent, textFont);
			totalWidth = BATTERY_WIDTH + BATTERY_DOP_WIDTH + BATTERY_ICON_PADDING + textSize;
			co_Battery_x = x + width/2 - totalWidth/2;
	    	co_BatteryDop_x = co_Battery_x + BATTERY_WIDTH;
			co_Battery_text_x = co_BatteryDop_x + BATTERY_ICON_PADDING;
		}else if(mode == MODE_ICON){
			totalWidth = BATTERY_WIDTH + BATTERY_DOP_WIDTH;
			co_Battery_x = x + width/2 - totalWidth/2;
	    	co_BatteryDop_x = co_Battery_x + BATTERY_WIDTH;
		}else if(mode == MODE_VALUE){
			textSize = dc.getTextWidthInPixels(textPercent, textFont);
	    	co_Battery_text_x = x + width/2 - textSize/2;
		}
    }

	function draw(dc){
		displayBattery(dc);	
	}
	
	private function displayBattery(dc){
		var battery = Sys.getSystemStats().battery;
		var batteryTxt = battery.format("%d")+"%";
		computeCoordinatesX(dc, batteryTxt);
		
		if(mode == MODE_ICON || mode == MODE_ICON_AND_VALUE){
			displayBatteryIcon(dc, battery, COLOR_BATTERY_LOW, COLOR_BATTERY_MEDIUM, COLOR_BATTERY_HIGH);
		}
		
		if(mode == MODE_VALUE || mode == MODE_ICON_AND_VALUE){
	       	displayBatteryPercent(dc, battery);
		}
	}
	
    private function displayBatteryPercent(dc, battery){
		var batteryTxt = battery.format("%d")+"%";
		dc.setColor(colorForeground, colorBackground);
	   	dc.drawText(co_Battery_text_x, co_Battery_text_y, textFont, batteryTxt, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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
    
     function setMode(mode){
    	me.mode=mode;
    }
}