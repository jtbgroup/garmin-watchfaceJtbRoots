using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class FloorsClimbedComponent extends ZoneComponent {
	hidden const COLOR_BAR_0=0xFF0000;
	hidden const COLOR_BAR_25=0xFFAA00;
	hidden const COLOR_BAR_75=0xAA55FF;
    hidden const COLOR_BAR_100=0x00FF00;
	hidden const BAR_WIDTH = 80;
	hidden const BAR_HEIGHT = 8;
	hidden const PADDING_V = 1;
	
	hidden var barPercent=0.7;
	hidden var barHeight=10;
	hidden var barWidth;
	
	hidden var co_bar_x, co_bar_y;
	hidden var co_count_y = -1;
	 
    function initialize(params) {
       ZoneComponent.initialize(params);
		computeCoordinates();
    }
    
    private function computeCoordinates(){
    	barWidth = BAR_WIDTH;
    	co_bar_x = x + width/2 - (BAR_WIDTH)/2;
    	co_bar_y = y + height/2 - barHeight - PADDING_V *2;
    }
    
	function draw(dc){
		if(co_count_y == -1){
			var fHeight = dc.getFontHeight(textFont);
	    		if(fHeight < dc.getFontHeight(iconFont)){
	    			fHeight = dc.getFontHeight(iconFont);
	    		}
	    	co_count_y = y + height/2  + fHeight/2 -PADDING_V;
		}
	
		displaySteps(dc);	
	}
	
	 function displaySteps(dc){
		var count = Mon.getInfo().floorsClimbed;
        displayBar(dc, count);
        displayCounter(dc, count);
    }
    
    function displayBar(dc, count){
    	dc.setColor(colorForeground, colorBackground);
        dc.drawRectangle(co_bar_x, co_bar_y, barWidth, barHeight);
        
        var countGoal = Mon.getInfo().floorsClimbedGoal;
        var goal = (count * 1.0 / countGoal * 1.0) ;
                        
        var fillColor = COLOR_BAR_25;
        var fillSize = (barWidth -2.0) * goal;
        if(goal>=1.0){
	        fillColor=COLOR_BAR_100;
	        fillSize=barWidth-2;
        }else if(goal >= 0.75){
        	fillColor=COLOR_BAR_75;
         }else if(goal <= 0.25){
        	fillColor=COLOR_BAR_0;
        }
        
        dc.setColor(fillColor, colorBackground);
        dc.fillRectangle(co_bar_x + 1, co_bar_y+2, fillSize, barHeight-4);
   }
   
   function displayCounter(dc, count){
   		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(count.toString(), textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_count_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_count_y,  textFont, count.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
    
}