using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class DistanceComponent extends ZoneComponent {
	hidden const FORMAT_DIST="%.1f";
	hidden var co_y;
	hidden var settings;
	 
    function initialize(params) {
    	ZoneComponent.initialize(params);
    	settings=Sys.getDeviceSettings();
		computeCoordinates();
    }
    
    private function computeCoordinates(){
  	  	co_y = y + height/2;
    }
    
	function draw(dc){
		displaySteps(dc);	
	}
	
	 function displaySteps(dc){
	 	var dist = Mon.getInfo().distance;
	 	var string;
		if(settings.distanceUnits==Sys.UNIT_STATUTE) {
			string=(dist/160934.0).format(FORMAT_DIST)+" mi";
		}
		else {
			string=(dist/(100000.0)).format(FORMAT_DIST)+" km";
		} 

		var iconWidthAndPadding = dc.getTextWidthInPixels(iconChar, iconFont) + ICON_PADDING;
   		var size = dc.getTextWidthInPixels(string, textFont) + iconWidthAndPadding;
		var start = x + width/2 - size/2.0;
		
		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
		dc.setColor(colorForeground,colorBackground);
	  	dc.drawText(start+iconWidthAndPadding, co_y, textFont, string, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
   
 
}