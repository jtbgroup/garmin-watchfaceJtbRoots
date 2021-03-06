using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class CaloriesComponent extends ZoneComponent {
	
	
	hidden var co_y;
	 
    function initialize(params) {
        ZoneComponent.initialize(params);
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
		var txt = calories.toString();
		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(txt, textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_y, textFont, txt, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
   
 
}