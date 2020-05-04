module JTBHelper {
	
	class IconHelper {
		
		var rez = {};
	
		function loadColoredIconRez(iconDictionary){
			rez = iconDictionary;
		}
			
		function getColoredIcon(iconDictId, colorPropertyKey){
			return rez.get(iconDictId).get(JTBHelper.getRawPropertyValue(colorPropertyKey));
		}
		
		function getRandomColoredIcon(iconDictId, colorPropertyKey, colorsToAvoid){
			var color = JTBHelper.getRandomColorId(colorsToAvoid);
			return rez.get(iconDictId).get(color);
		}
		
	}
}