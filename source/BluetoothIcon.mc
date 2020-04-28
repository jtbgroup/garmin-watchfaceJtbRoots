using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

/**
Width should be a multiple of 2
Height should be a multiple of 4 and 3
*/
class BluetoothIcon extends Ui.Drawable {

	hidden var foregroundColor,backgroundColor = null;
	hidden var point01x, point01y, point02x, point02y;
	hidden var point03x, point03y, point04x, point04y;
	hidden var point05x, point05y, point06x, point06y;
	 
    function initialize(params) {
        Drawable.initialize(params);
			
      	me.foregroundColor=params.get(:fgc);
		me.backgroundColor=params.get(:bgc);
		
		point01x=locX;
		point01y=locY+height/4;
		point02x=locX+width;
		point02y=locY+height*3/4;
		
		point03x=locX;
		point03y=locY+height*3/4;
		point04x=locX+width;
		point04y=locY+height/4;
		
		point05x=locX+width/2;
		point05y=locY;
		point06x=point05x;
		point06y=locY+height;
    }

	function draw(dc){
		dc.setColor(foregroundColor, backgroundColor);
		//cross
		dc.drawLine(point01x, point01y, point02x, point02y);
		dc.drawLine(point03x, point03y, point04x, point04y);
		//bottom right
		dc.drawLine(point04x, point04y, point05x, point05y);
		//top right
		dc.drawLine(point02x, point02y, point06x, point06y);
		//center vertical
		dc.drawLine(point05x, point05y, point06x, point06y);
	}
}