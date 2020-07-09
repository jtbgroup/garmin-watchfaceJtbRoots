using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class HeartRateComponent extends ZoneComponent {
	
	hidden var co_y;
	
	 
    function initialize(params) {
        ZoneComponent.initialize(params);
        me.canHideOnSleep = true;
        me.keepDisplayedOnSleep = params.get(:keepDisplayedOnSleep);
		computeCoordinates();
    }
    
    private function computeCoordinates(){
  	  	co_y = y + height/2;
    }
    
	function draw(dc){
		displayHR(dc);	
	}
	
    function displayHR(dc){
	    var wIcon = dc.getTextWidthInPixels(iconChar, iconFont);
	    var iconWidthAndPadding = wIcon + ICON_PADDING;
		var hrText = retrieveHeartrateText();
   		var size = dc.getTextWidthInPixels(hrText.toString(), textFont) + iconWidthAndPadding;
		var start = x + width/ 2.0 - size/2.0;

		System.println(width);

		dc.setColor(iconColor,colorBackground);
		dc.drawText(start, co_y, iconFont, iconChar, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.setColor(colorForeground, colorBackground);
		dc.drawText(start+iconWidthAndPadding, co_y, textFont, hrText, Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
	}
	
    private function retrieveHeartrateText() {
		var hr = Activity.getActivityInfo().currentHeartRate;
		if(null != hr){
			return hr.format("%d");
		}
		return "000";
    }    
   
 
}