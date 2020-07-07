using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class StepsComponent extends Ui.Drawable {
//
//	hidden const COLOR_BATTERY_LOW = Gfx.COLOR_RED;
//	hidden const COLOR_BATTERY_MEDIUM = Gfx.COLOR_YELLOW;
//	hidden const COLOR_BATTERY_HIGH = Gfx.COLOR_GREEN;
//	
//	hidden const BATTERY_WIDTH = 22;
//	hidden const BATTERY_HEIGHT = 10;
//	hidden const BATTERY_DOP_WIDTH = 2;
//	hidden const BATTERY_DOP_HEIGHT = 5;
	
//	hidden const ICON_PADDING = 3;
	
	hidden const COLOR_STEPSBAR_0=0xFF0000;
	hidden const COLOR_STEPSBAR_25=0xFFAA00;
	hidden const COLOR_STEPSBAR_75=0xAA55FF;
    hidden const COLOR_STEPSBAR_100=0x00FF00;
	hidden const STEPSBAR_WIDTH = 80;
	hidden const STEPSBAR_HEIGHT = 8;
	
	hidden var colorForeground,colorBackground;
	hidden var x, y, height, width;
	hidden var font;
	hidden var barPercent=0.7;
	hidden var barHeight=10;
	hidden var barWidth;
	
	hidden var co_bar_x, co_bar_y;
	hidden var co_stepsCount_y;
	 
    function initialize(params) {
        Drawable.initialize(params);
        me.x=locX;
        me.y=locY;
        me.height=params.get(:height);
        me.width=params.get(:width);
      	me.colorForeground=params.get(:fgc);
		me.colorBackground=params.get(:bgc);
		me.font=params.get(:font);
		
		//computeCoordinatesX(params.get(:dc));
		computeCoordinatesY();
    }
    
    private function computeCoordinatesY(){
    	barWidth = STEPSBAR_WIDTH;
    	co_bar_x = x + width/2 - (STEPSBAR_WIDTH)/2;
    	co_bar_y = y+barHeight;
    	
    	co_stepsCount_y=co_bar_y+5;
    }
    
//    private function computeCoordinatesX(dc){
//    	bar_x = x - totalWidth/2;
//    	co_BatteryDop_x = co_Battery_x + BATTERY_WIDTH;
//		co_Battery_text_x = co_BatteryDop_x + ICON_PADDING*2;
//    }

	function draw(dc){
		displaySteps(dc);	
	}
	
	 function displaySteps(dc){
		var stepsCount = Mon.getInfo().steps;
        displayStepsBar(dc, stepsCount);
       // displayStepsCounter(dc, stepsCount);
    }
    
    function displayStepsBar(dc, stepsCount){
    	dc.setColor(colorForeground, colorBackground);
        dc.drawRectangle(co_bar_x, co_bar_y, barWidth, barHeight);
        
        var stepsCountGoal = Mon.getInfo().stepGoal;
        var goal = (stepsCount * 1.0 / stepsCountGoal * 1.0) ;
                        
        var fillColor = COLOR_STEPSBAR_25;
        var fillSize = (barWidth -2.0) * goal;
        if(goal>=1.0){
	        fillColor=COLOR_STEPSBAR_100;
	        fillSize=barWidth-2;
        }else if(goal >= 0.75){
        	fillColor=COLOR_STEPSBAR_75;
         }else if(goal <= 0.25){
        	fillColor=COLOR_STEPSBAR_0;
        }
        
        dc.setColor(fillColor, colorBackground);
        dc.fillRectangle(co_bar_x + 1, co_bar_y+2, fillSize, barHeight-4);
   }
   
   function displayStepsCounter(dc, stepsCount){
   		var iconWidthAndPadding = dc.getTextWidthInPixels(FONT_ICON_CHAR_RUNNER, fontIcons) + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), fontTextSteps) + iconWidthAndPadding;
		var start = co_Screen_Width/ 2.0 - size/2.0;
		dc.setColor(iconColorRunner,COLOR_TRANSPARENT);
		dc.drawText(start, co_StepsCount_y, fontIcons, FONT_ICON_CHAR_RUNNER, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,COLOR_TRANSPARENT);
	  	dc.drawText(start+iconWidthAndPadding, co_StepsCount_y,  fontTextSteps, stepsCount.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
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