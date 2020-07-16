using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class GoalComponent extends ZoneComponent {
	
	hidden const COLOR_BAR_0=0xFF0000;
	hidden const COLOR_BAR_25=0xFFAA00;
	hidden const COLOR_BAR_75=0xAA55FF;
    hidden const COLOR_BAR_100=0x00FF00;
	hidden const BAR_WIDTH = 80;
	hidden const BAR_HEIGHT = 10;
	hidden const PADDING_V = 1;
	
	const MODE_FULL = 0;
	const MODE_VALUE = 1;
	const MODE_BAR = 2;
	
	hidden var mode;
	hidden var barPercent=0.7;
	hidden var barHeight;
	hidden var barWidth;
	
	hidden var co_bar_x, co_bar_y;
	hidden var co_counter_y = -1;
	 
    function initialize(params) {
		ZoneComponent.initialize(params);
		me.mode=params.get(:mode);
		co_counter_y = -1;
    }
    
    private function computeCoordinates(dc){
	    if(mode == MODE_FULL){
	    	barWidth = BAR_WIDTH;
	    	barHeight = BAR_HEIGHT;
	    	co_bar_x = x + width/2 - (BAR_WIDTH)/2;
	    	
	    	var fHeight = dc.getFontHeight(textFont);
		    if(fHeight < dc.getFontHeight(iconFont)){
		    	fHeight = dc.getFontHeight(iconFont);
		    }
	    	
		    var co_middle = y + height/2;
		    var fullH = BAR_HEIGHT + fHeight;
		    var pad = (height - fullH) / 2;
		    	
		    co_bar_y = y + pad;
		    co_counter_y = co_bar_y + BAR_HEIGHT + fHeight / 2;
	    } else if(mode == MODE_VALUE){
	   		 co_counter_y = y + height/2;
	    } else if(mode == MODE_BAR){
	   		barWidth = BAR_WIDTH;
	   		barHeight = BAR_HEIGHT;
	    	co_bar_x = x + width/2 - (BAR_WIDTH)/2;
	   		co_bar_y = y + height/2 - BAR_HEIGHT / 2;
	    }
    }
    
	function draw(dc){
		if(co_counter_y == -1){
			computeCoordinates(dc);
		}
	
		display(dc);	
	}
	
	 function display(dc){
		var counter = -1;
		if(canMonitor()){
			counter = getCounterValue();
		}
		
		if(mode == MODE_FULL){
	        displayBar(dc, counter);
	        displayCounter(dc, counter);
	    }else if(mode == MODE_VALUE){
	        displayCounter(dc, counter);
	    }else if(mode == MODE_BAR){
	        displayBar(dc, counter);
	    }
	    
    }
    
    function displayBar(dc, counter){
    	dc.setColor(colorForeground, colorBackground);
        dc.drawRectangle(co_bar_x, co_bar_y, barWidth, barHeight);
        
        if(counter == -1){
        	return;
        }
        
        var counterGoal = getGoalValue();
        var goal = (counter * 1.0 / counterGoal * 1.0) ;
                        
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
   
   function displayCounter(dc, counter){
   		if(counter == -1){
   			counter = "N/A";
   		}
   		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(counter.toString(), textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_counter_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_counter_y,  textFont, counter.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
	
	function getCounterValue(){
		return 0;
	}
	
	function getGoalValue(){
		return 1;
	}
    
}