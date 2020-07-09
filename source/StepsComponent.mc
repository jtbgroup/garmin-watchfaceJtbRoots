using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class StepsComponent extends ZoneComponent {
	
	hidden const COLOR_STEPSBAR_0=0xFF0000;
	hidden const COLOR_STEPSBAR_25=0xFFAA00;
	hidden const COLOR_STEPSBAR_75=0xAA55FF;
    hidden const COLOR_STEPSBAR_100=0x00FF00;
	hidden const STEPSBAR_WIDTH = 80;
	hidden const STEPSBAR_HEIGHT = 8;
	hidden const PADDING = 3;
	hidden const PADDING_V = 1;
	
	hidden var barPercent=0.7;
	hidden var barHeight=10;
	hidden var barWidth;
	
	hidden var co_bar_x, co_bar_y;
	hidden var co_stepsCount_y = -1;
	 
    function initialize(params) {
       ZoneComponent.initialize(params);
		computeCoordinates();
    }
    
    private function computeCoordinates(){
    	barWidth = STEPSBAR_WIDTH;
    	co_bar_x = x + width/2 - (STEPSBAR_WIDTH)/2;
    	co_bar_y = y + height/2 - barHeight - PADDING_V *2;
    }
    
	function draw(dc){
		if(co_stepsCount_y == -1){
			var fHeight = dc.getFontHeight(textFont);
	    		if(fHeight < dc.getFontHeight(iconFont)){
	    			fHeight = dc.getFontHeight(iconFont);
	    		}
	    	co_stepsCount_y = y + height/2  + fHeight/2 -PADDING_V;
		}
	
		displaySteps(dc);	
	}
	
	 function displaySteps(dc){
		var stepsCount = Mon.getInfo().steps;
        displayStepsBar(dc, stepsCount);
        displayStepsCounter(dc, stepsCount);
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
   		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + PADDING;
   		var size = dc.getTextWidthInPixels(stepsCount.toString(), textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_stepsCount_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_stepsCount_y,  textFont, stepsCount.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
    
}