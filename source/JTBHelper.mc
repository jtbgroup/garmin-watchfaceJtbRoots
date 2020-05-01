using Toybox.System as Sys;

module JTBHelper {

	var helper = new Helper();
	
	const OPTION_COLOR_WHITE=0; 
	const OPTION_COLOR_LT_GRAY=1;
	const OPTION_COLOR_DK_GRAY= 2;
	const OPTION_COLOR_BLACK= 3;
	const OPTION_COLOR_RED= 4;
	const OPTION_COLOR_DK_RED= 5;
	const OPTION_COLOR_ORANGE= 6;
	const OPTION_COLOR_YELLOW= 7;
	const OPTION_COLOR_GREEN= 8;
	const OPTION_COLOR_DK_GREEN= 9;
	const OPTION_COLOR_BLUE= 10;
	const OPTION_COLOR_DK_BLUE= 11;
	const OPTION_COLOR_PURPLE=12 ;
	const OPTION_COLOR_PINK=13;
		
	
	class Helper {
		hidden static var propertiesHelper = new PropertiesHelper();
		hidden static var colorHelper = new ColorHelper();
		hidden static var iconHelper = new IconHelper();
		
		function getRandomColor(colorToAvoid){
			return colorHelper.getRandomColor(colorToAvoid);
		}
		
		function getColorById(id){
			return colorHelper.getColorById(id);
		}
	
		function getPropertyValue(key){
			return propertiesHelper.getPropertyValue(key);
		}
		
		function getRawPropertyValue(key){
			return propertiesHelper.getRawPropertyValue(key);
		}
		
		function loadColoredIconRez(iconDictionary){
			iconHelper.loadColoredIconRez(iconDictionary);
		}
		
		function getColoredIcon(iconDictId, colorPropertyKey){
			return iconHelper.getColoredIcon(iconDictId, colorPropertyKey);
		}
	}
	
	
	function getColorById(id){
		return helper.getColorById(id);
	}
	
	
	function loadColoredIconRez(iconDictionary){
		helper.loadColoredIconRez(iconDictionary);
	}
	
	function getColoredIcon(iconDictId, colorPropertyKey){
		return helper.getColoredIcon(iconDictId, colorPropertyKey);
	}
	 	
	function getRandomColor(colorToAvoid){
		return helper.getRandomColor(colorToAvoid);
	}
	
	function getPropertyValue(key){
		return helper.getPropertyValue(key);
	}
	
	function getRawPropertyValue(key){
		return helper.getRawPropertyValue(key);
	}
	
}