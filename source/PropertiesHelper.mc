<<<<<<< HEAD
using Toybox.System as Sys;
using Toybox.Application;

module JTBHelper {
	class PropertiesHelper {

		private function getProperty(key){
			var result = null;
			try{
				result = Application.Properties.getValue(key);
			} catch (e instanceof InvalidKeyException) {
				Sys.println(e.getErrorMessage());
			}
			
			if(result == null){
				Sys.println("resource '" + key + "' undefined");
				return null;
			}
			
			return result;
		}
		
		private function getColorById(id){
			var value =  JTBHelper.getColorById(id);
			return value;
		}	

		public function getPropertyValue(key){
			var value = getProperty(key);
			if(key.find("PROP_COLOR") != null){
				var color =  getColorById(value);
			//	Sys.println(key + " => "+value+" => "+color);
				return color;
			}
			
			//Sys.println(key + " => "+ value);
			return value;
		}
		
		public function getRawPropertyValue(key){
			return getProperty(key);
		}
	}
	
	
}
=======
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang as Lang;
using Toybox.Application;
using ColorHelper as Ch;
using Toybox.Application.Properties;

module PropertiesHelper {

	//CONSTANT values for properties
	// color mode
	const OPTION_MODE_COLOR_STANDARD = 0;
	const OPTION_MODE_COLOR_DISCO = 1;
	const OPTION_MODE_COLOR_LUCY = 2;
	// colors
	const OPTION_DATE_FORMAT_WEEKDAYTXT_DAYNUM_MONTHTXT=0;
	const OPTION_DATE_FORMAT_DAYNUM_MONTHNUM_YEARNUM=1;
	const OPTION_DATE_FORMAT_MONTH_NUM_DAYNUM_YEARNUM=2;
	//hour format
//	var HOUR_FORMAT_12 = 0;
//	var HOUR_FORMAT_24 = 1;


	//PROPERTIES -- configurables
	//Those properties must be the same as in the properties.xml
	const PROP_COLOR_BACKGROUND="PROP_COLOR_BACKGROUND";
	const PROP_COLOR_FOREGROUND="PROP_COLOR_FOREGROUND";
	const PROP_COLOR_CLOCK_HOUR="PROP_COLOR_CLOCK_HOUR";
	const PROP_COLOR_CLOCK_MIN="PROP_COLOR_CLOCK_MIN";
	
	const PROP_MODE_COLOR="PROP_MODE_COLOR";
	const PROP_DATE_FORMAT="PROP_DATE_FORMAT";
	
	const PROP_SHOW_NOTIFICATION="PROP_SHOW_NOTIFICATION";
	const PROP_SHOW_SECONDS="PROP_SHOW_SECONDS";
	const PROP_SHOW_HR="PROP_SHOW_HR";
	const PROP_HR_KEEP_DISPLAYED="PROP_HR_KEEP_DISPLAYED";
	
	const PROP_ICON_COLOR_BLUETOOTH="PROP_ICON_COLOR_BLUETOOTH";
	const PROP_ICON_COLOR_HEART="PROP_ICON_COLOR_HEART";
	const PROP_ICON_COLOR_NOTIFICATION="PROP_ICON_COLOR_NOTIFICATION";
	const PROP_ICON_COLOR_RUNNER="PROP_ICON_COLOR_RUNNER";
	const PROP_ICON_COLOR_ALARM="PROP_ICON_COLOR_ALARM";
	
	//The map with all the properties
	var properties={
		PROP_COLOR_BACKGROUND=>Gfx.COLOR_BLACK,
		PROP_COLOR_CLOCK_HOUR=>Gfx.COLOR_RED,
		PROP_COLOR_CLOCK_MIN=>Gfx.COLOR_RED,
		PROP_MODE_COLOR=>OPTION_MODE_COLOR_STANDARD,
		PROP_DATE_FORMAT=>OPTION_DATE_FORMAT_WEEKDAYTXT_DAYNUM_MONTHTXT,
		PROP_SHOW_SECONDS=>true,
		PROP_SHOW_NOTIFICATION=>true,
		PROP_SHOW_HR=>true,
		PROP_HR_KEEP_DISPLAYED=>true,
		PROP_COLOR_FOREGROUND=>Gfx.COLOR_WHITE,
		PROP_ICON_COLOR_BLUETOOTH=>Gfx.COLOR_BLUE,
		PROP_ICON_COLOR_HEART=>Gfx.COLOR_RED,
		PROP_ICON_COLOR_NOTIFICATION=>Gfx.COLOR_WHITE,
		PROP_ICON_COLOR_RUNNER=>Gfx.COLOR_WHITE,
		PROP_ICON_COLOR_ALARM=>Gfx.COLOR_YELLOW
	};
	
	function loadProperties(){
		var keys = properties.keys();
		var key = null;
		var value = null;
		for(var i = 0; i < keys.size(); i++){
			try{
				key = keys[i];
				//System.print(i + " > " + key);
				value = Application.Properties.getValue(key);
				if(null != value){
					if(key.find("PROP_COLOR") != null){
						//System.print(" - " + value);
						value = Ch.getColorByIndex(value);
						//System.print(" - " + value);
					}
				}
			} catch (e instanceof InvalidKeyException) {
		   		System.println(e.getErrorMessage());
			}
			properties.put(key, value);
			//System.println(" > " + getValue(key));
		}
	}
	
    function getValue(propertyName){
    	return properties.get(propertyName);
    }
	
}
>>>>>>> refs/heads/1.5.0-branch
