using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class CaloriesComponent extends Ui.Drawable {
	
	hidden const PADDING = 3;
	hidden var colorForeground,colorBackground, iconColor;
	hidden var x, y, height, width;
	hidden var textFont, iconFont, iconChar;
	hidden var barPercent=0.7;
	hidden var barHeight=10;
	hidden var barWidth;
	
	hidden var co_y;
	 
    function initialize(params) {
        Drawable.initialize(params);
        me.x=locX;
        me.y=locY;
        me.height=params.get(:height);
        me.width=params.get(:width);
      	me.colorForeground=params.get(:fgc);
		me.colorBackground=params.get(:bgc);
		me.textFont=params.get(:textFont);
		me.iconFont=params.get(:iconFont);
		me.iconChar=params.get(:iconChar);
		me.iconColor=params.get(:iconColor);
		
		computeCoordinates();
    }
    
    private function computeCoordinates(){
  	  	co_y = y + height/2;
    }
    
	function draw(dc){
		displaySteps(dc);	
	}
	
	 function displaySteps(dc){
		var calories = Mon.getInfo().calories;
		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + PADDING;
   		var size = dc.getTextWidthInPixels(calories.toString(), textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_y, textFont, calories.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
   
 
}