using Toybox.Graphics as Gfx;
using JTBUtils as Helper;

module RootsConstants {

	//CONSTANT values for properties
	// color mode
	const OPTION_MODE_COLOR_STANDARD = 0;
	const OPTION_MODE_COLOR_DISCO = 1;
	const OPTION_MODE_COLOR_LUCY = 2;
	// colors
	const OPTION_DATE_FORMAT_WEEKDAYTXT_DAYNUM_MONTHTXT=0;
	const OPTION_DATE_FORMAT_DAYNUM_MONTHNUM_YEARNUM=1;
	const OPTION_DATE_FORMAT_MONTH_NUM_DAYNUM_YEARNUM=2;
	
	const OPTION_ZONE_NONE = 0;
	const OPTION_ZONE_STEPS = 1;
	const OPTION_ZONE_CALORIES = 2;
	const OPTION_ZONE_BATTERY = 3;
	const OPTION_ZONE_DISTANCE = 4;
	const OPTION_ZONE_HEARTRATE = 5;
	const OPTION_ZONE_SECONDS = 6;
	const OPTION_ZONE_FLOORS_CLIMBED = 7;
	
	//hour format
//	var HOUR_FORMAT_12 = 0;
//	var HOUR_FORMAT_24 = 1;


	//PROPERTIES -- configurables
	//Those properties must be the same as in the properties.xml
	const PROP_COLOR_BACKGROUND="PROP_COLOR_BACKGROUND";
	const PROP_COLOR_FOREGROUND="PROP_COLOR_FOREGROUND";
	const PROP_COLOR_CLOCK_HOUR="PROP_COLOR_CLOCK_HOUR";
	const PROP_COLOR_CLOCK_MIN="PROP_COLOR_CLOCK_MIN";
	const PROP_COLOR_SECONDS="PROP_COLOR_SECONDS";
	
	const PROP_MODE_COLOR="PROP_MODE_COLOR";
	const PROP_DATE_FORMAT="PROP_DATE_FORMAT";
	
	const PROP_SHOW_BATTERY_TEXT="PROP_SHOW_BATTERY_TEXT";
	const PROP_SHOW_NOTIFICATION="PROP_SHOW_NOTIFICATION";
	const PROP_SHOW_DATE="PROP_SHOW_DATE";
	const PROP_SHOW_ALARM="PROP_SHOW_ALARM";
	const PROP_SHOW_BLUETOOTH="PROP_SHOW_BLUETOOTH";
	const PROP_HR_KEEP_DISPLAYED="PROP_HR_KEEP_DISPLAYED";
	const PROP_SECONDS_KEEP_DISPLAYED="PROP_SECONDS_KEEP_DISPLAYED";
	
	const PROP_ICON_COLOR_BLUETOOTH="PROP_ICON_COLOR_BLUETOOTH";
	const PROP_ICON_COLOR_HEART="PROP_ICON_COLOR_HEART";
	const PROP_ICON_COLOR_NOTIFICATION="PROP_ICON_COLOR_NOTIFICATION";
	const PROP_ICON_COLOR_RUNNER="PROP_ICON_COLOR_RUNNER";
	const PROP_ICON_COLOR_ALARM="PROP_ICON_COLOR_ALARM";
	const PROP_ICON_COLOR_CALORIES="PROP_ICON_COLOR_CALORIES";
	const PROP_ICON_COLOR_DISTANCE="PROP_ICON_COLOR_DISTANCE";
	const PROP_ICON_COLOR_FLOORS_CLIMBED="PROP_ICON_COLOR_FLOORS_CLIMBED";

	const PROP_FONT_SIZE_HR = "PROP_FONT_SIZE_HR";
	const PROP_FONT_SIZE_BATTERY = "PROP_FONT_SIZE_BATTERY";
	const PROP_FONT_SIZE_NOTIFICATION = "PROP_FONT_SIZE_NOTIFICATION";
	const PROP_FONT_SIZE_DATE = "PROP_FONT_SIZE_DATE";
	const PROP_FONT_SIZE_SECONDS = "PROP_FONT_SIZE_SECONDS";
	const PROP_FONT_SIZE_STEPS = "PROP_FONT_SIZE_STEPS";
	const PROP_FONT_SIZE_CALORIES = "PROP_FONT_SIZE_CALORIES";
	const PROP_FONT_SIZE_DISTANCE = "PROP_FONT_SIZE_DISTANCE";
	const PROP_FONT_SIZE_FLOORS_CLIMBED = "PROP_FONT_SIZE_FLOORS_CLIMBED";
	
	const PROP_ZONE_1 = "PROP_ZONE_1";
	const PROP_ZONE_6 = "PROP_ZONE_6";
	const PROP_ZONE_7 = "PROP_ZONE_7";
	const PROP_ZONE_8 = "PROP_ZONE_8";
}
