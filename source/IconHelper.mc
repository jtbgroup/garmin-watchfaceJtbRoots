using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Mt;
using Toybox.Application;
using RootsConstants as Cst;
using JTBHelper as Helper;

module JTBHelper {
	
	class IconHelper {
		
		var rez = {};
	
		function loadColoredIconRez(iconDictionary){
			rez = iconDictionary;
		}
			
		function getColoredIcon(iconDictId, colorPropertyKey){
			return rez.get(iconDictId).get(JTBHelper.getRawPropertyValue(colorPropertyKey));
		}
		
	}
}