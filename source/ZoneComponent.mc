using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class ZoneComponent extends Ui.Drawable {
	
	hidden const ICON_PADDING = 3;
	
	hidden var colorForeground,colorBackground, iconColor;
	hidden var x, y, height, width;
	hidden var textFont, iconFont, iconChar;
	hidden var keepDisplayedOnSleep = true;
	hidden var canHideOnSleep = false;
	 
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
    }
    
	function setIconColor(color){
		me.iconColor=color;
	}
	
	function setForegroundColor(color){
		me.colorForeground=color;
	} 
	
	function isKeptDisplayedOnSleep(){
		return me.keepDisplayedOnSleep;
	}
	
	function canBeHiddenOnSleep(){
		return me.canHideOnSleep;
	}
	
	function canMonitor(){
		return true;
	}
 
}