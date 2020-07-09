using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class SecondsComponent extends ZoneComponent {
	
	
	hidden var co_y, co_x;
	 
    function initialize(params) {
        ZoneComponent.initialize(params);
		computeCoordinates();
    }
    
    private function computeCoordinates(){
  	  	co_y = y + height/2;
  	  	co_x = x + width/2;
    }
    
	function draw(dc){
		dc.setColor(colorForeground, colorBackground);
		dc.drawText(co_x, co_y, textFont, System.getClockTime().sec.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
	
   
 
}