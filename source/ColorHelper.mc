using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang as Lang;
using Toybox.Math as Mt;
using Toybox.Application;

module ColorHelper {

	var WHITE=0; 
	var LT_GRAY=1;
	var DK_GRAY= 2;
	var BLACK= 3;
	var RED= 4;
	var DK_RED= 5;
	var ORANGE= 6;
	var YELLOW= 7;
	var GREEN= 8;
	var DK_GREEN= 9;
	var BLUE= 10;
	var DK_BLUE= 11;
	var PURPLE=12 ;
	var PINK=13;
	
	var COLORS_D={
		WHITE=>Gfx.COLOR_WHITE, 
		LT_GRAY=>Gfx.COLOR_LT_GRAY, 
		DK_GRAY=>Gfx.COLOR_DK_GRAY, 
		BLACK=>Gfx.COLOR_BLACK, 
		RED=>Gfx.COLOR_RED,
		DK_RED=>Gfx.COLOR_DK_RED,
		ORANGE=>Gfx.COLOR_ORANGE, 
		YELLOW=>Gfx.COLOR_YELLOW, 
		GREEN=>Gfx.COLOR_GREEN, 
		DK_GREEN=>Gfx.COLOR_DK_GREEN, 
		BLUE=>Gfx.COLOR_BLUE, 
		DK_BLUE=>Gfx.COLOR_DK_BLUE,
		PURPLE=>Gfx.COLOR_PURPLE, 
		PINK=>Gfx.COLOR_PINK
	};
		
	function getRandomColor(colorToAvoid){
    	var r = Mt.rand() % COLORS_D.size();
    	var color = COLORS_D.get(r);
    	if(null != colorToAvoid && colorToAvoid == color){
    		return getRandomColor(colorToAvoid);
    	}
    	return color;
    }
    
    function getColorByIndex(colorIndex){
    	return COLORS_D.get(colorIndex);
    }
}