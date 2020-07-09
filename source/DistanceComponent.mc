using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class DistanceComponent extends ZoneComponent {
	
	hidden const PADDING = 3;
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
		var distance = Mon.getInfo().distance / 100;
		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + PADDING;
   		var size = dc.getTextWidthInPixels(distance.toString(), textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_y, textFont, distance.toString(),Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
   
 
}