using Toybox.Graphics as Gfx;
using JTBHelper as Helper;

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

	const DICT_ICON_RUNNER = "runner";
	const DICT_ICON_NOTIFICATION = "notification";
	const DICT_ICON_HEART = "heart";
	const DICT_ICON_ALARM = "alarm";
	const DICT_ICON_BLUETOOTH = "bluetooth";

	const iconsDictionary = {
		DICT_ICON_RUNNER => {
			Helper.OPTION_COLOR_BLACK=>Rez.Drawables.icon_runner_16_BLACK,
			Helper.OPTION_COLOR_BLUE=>Rez.Drawables.icon_runner_16_BLUE,
			Helper.OPTION_COLOR_DK_BLUE=>Rez.Drawables.icon_runner_16_DK_BLUE,
			Helper.OPTION_COLOR_DK_GRAY=>Rez.Drawables.icon_runner_16_DK_GRAY,
			Helper.OPTION_COLOR_DK_GREEN=>Rez.Drawables.icon_runner_16_DK_GREEN,
			Helper.OPTION_COLOR_DK_RED=>Rez.Drawables.icon_runner_16_DK_RED,
			Helper.OPTION_COLOR_GREEN=>Rez.Drawables.icon_runner_16_GREEN,
			Helper.OPTION_COLOR_LT_GRAY=>Rez.Drawables.icon_runner_16_LT_GRAY,
			Helper.OPTION_COLOR_ORANGE=>Rez.Drawables.icon_runner_16_ORANGE,
			Helper.OPTION_COLOR_PINK=>Rez.Drawables.icon_runner_16_PINK,
			Helper.OPTION_COLOR_PURPLE=>Rez.Drawables.icon_runner_16_PURPLE,
			Helper.OPTION_COLOR_RED=>Rez.Drawables.icon_runner_16_RED,
			Helper.OPTION_COLOR_WHITE=>Rez.Drawables.icon_runner_16_WHITE,
			Helper.OPTION_COLOR_YELLOW=>Rez.Drawables.icon_runner_16_YELLOW
			},
		DICT_ICON_HEART => {
			Helper.OPTION_COLOR_BLACK=>Rez.Drawables.icon_heart_16_BLACK,
			Helper.OPTION_COLOR_BLUE=>Rez.Drawables.icon_heart_16_BLUE,
			Helper.OPTION_COLOR_DK_BLUE=>Rez.Drawables.icon_heart_16_DK_BLUE,
			Helper.OPTION_COLOR_DK_GRAY=>Rez.Drawables.icon_heart_16_DK_GRAY,
			Helper.OPTION_COLOR_DK_GREEN=>Rez.Drawables.icon_heart_16_DK_GREEN,
			Helper.OPTION_COLOR_DK_RED=>Rez.Drawables.icon_heart_16_DK_RED,
			Helper.OPTION_COLOR_GREEN=>Rez.Drawables.icon_heart_16_GREEN,
			Helper.OPTION_COLOR_LT_GRAY=>Rez.Drawables.icon_heart_16_LT_GRAY,
			Helper.OPTION_COLOR_ORANGE=>Rez.Drawables.icon_heart_16_ORANGE,
			Helper.OPTION_COLOR_PINK=>Rez.Drawables.icon_heart_16_PINK,
			Helper.OPTION_COLOR_PURPLE=>Rez.Drawables.icon_heart_16_PURPLE,
			Helper.OPTION_COLOR_RED=>Rez.Drawables.icon_heart_16_RED,
			Helper.OPTION_COLOR_WHITE=>Rez.Drawables.icon_heart_16_WHITE,
			Helper.OPTION_COLOR_YELLOW=>Rez.Drawables.icon_heart_16_YELLOW
			},
		DICT_ICON_NOTIFICATION => {
			Helper.OPTION_COLOR_BLACK=>Rez.Drawables.icon_enveloppe_16_BLACK,
			Helper.OPTION_COLOR_BLUE=>Rez.Drawables.icon_enveloppe_16_BLUE,
			Helper.OPTION_COLOR_DK_BLUE=>Rez.Drawables.icon_enveloppe_16_DK_BLUE,
			Helper.OPTION_COLOR_DK_GRAY=>Rez.Drawables.icon_enveloppe_16_DK_GRAY,
			Helper.OPTION_COLOR_DK_GREEN=>Rez.Drawables.icon_enveloppe_16_DK_GREEN,
			Helper.OPTION_COLOR_DK_RED=>Rez.Drawables.icon_enveloppe_16_DK_RED,
			Helper.OPTION_COLOR_GREEN=>Rez.Drawables.icon_enveloppe_16_GREEN,
			Helper.OPTION_COLOR_LT_GRAY=>Rez.Drawables.icon_enveloppe_16_LT_GRAY,
			Helper.OPTION_COLOR_ORANGE=>Rez.Drawables.icon_enveloppe_16_ORANGE,
			Helper.OPTION_COLOR_PINK=>Rez.Drawables.icon_enveloppe_16_PINK,
			Helper.OPTION_COLOR_PURPLE=>Rez.Drawables.icon_enveloppe_16_PURPLE,
			Helper.OPTION_COLOR_RED=>Rez.Drawables.icon_enveloppe_16_RED,
			Helper.OPTION_COLOR_WHITE=>Rez.Drawables.icon_enveloppe_16_WHITE,
			Helper.OPTION_COLOR_YELLOW=>Rez.Drawables.icon_enveloppe_16_YELLOW
			},
		DICT_ICON_ALARM => {
			Helper.OPTION_COLOR_BLACK=>Rez.Drawables.icon_bell_16_BLACK,
			Helper.OPTION_COLOR_BLUE=>Rez.Drawables.icon_bell_16_BLUE,
			Helper.OPTION_COLOR_DK_BLUE=>Rez.Drawables.icon_bell_16_DK_BLUE,
			Helper.OPTION_COLOR_DK_GRAY=>Rez.Drawables.icon_bell_16_DK_GRAY,
			Helper.OPTION_COLOR_DK_GREEN=>Rez.Drawables.icon_bell_16_DK_GREEN,
			Helper.OPTION_COLOR_DK_RED=>Rez.Drawables.icon_bell_16_DK_RED,
			Helper.OPTION_COLOR_GREEN=>Rez.Drawables.icon_bell_16_GREEN,
			Helper.OPTION_COLOR_LT_GRAY=>Rez.Drawables.icon_bell_16_LT_GRAY,
			Helper.OPTION_COLOR_ORANGE=>Rez.Drawables.icon_bell_16_ORANGE,
			Helper.OPTION_COLOR_PINK=>Rez.Drawables.icon_bell_16_PINK,
			Helper.OPTION_COLOR_PURPLE=>Rez.Drawables.icon_bell_16_PURPLE,
			Helper.OPTION_COLOR_RED=>Rez.Drawables.icon_bell_16_RED,
			Helper.OPTION_COLOR_WHITE=>Rez.Drawables.icon_bell_16_WHITE,
			Helper.OPTION_COLOR_YELLOW=>Rez.Drawables.icon_bell_16_YELLOW
			},
		DICT_ICON_BLUETOOTH => {
			Helper.OPTION_COLOR_BLACK=>Rez.Drawables.icon_bluetooth_16_BLACK,
			Helper.OPTION_COLOR_BLUE=>Rez.Drawables.icon_bluetooth_16_BLUE,
			Helper.OPTION_COLOR_DK_BLUE=>Rez.Drawables.icon_bluetooth_16_DK_BLUE,
			Helper.OPTION_COLOR_DK_GRAY=>Rez.Drawables.icon_bluetooth_16_DK_GRAY,
			Helper.OPTION_COLOR_DK_GREEN=>Rez.Drawables.icon_bluetooth_16_DK_GREEN,
			Helper.OPTION_COLOR_DK_RED=>Rez.Drawables.icon_bluetooth_16_DK_RED,
			Helper.OPTION_COLOR_GREEN=>Rez.Drawables.icon_bluetooth_16_GREEN,
			Helper.OPTION_COLOR_LT_GRAY=>Rez.Drawables.icon_bluetooth_16_LT_GRAY,
			Helper.OPTION_COLOR_ORANGE=>Rez.Drawables.icon_bluetooth_16_ORANGE,
			Helper.OPTION_COLOR_PINK=>Rez.Drawables.icon_bluetooth_16_PINK,
			Helper.OPTION_COLOR_PURPLE=>Rez.Drawables.icon_bluetooth_16_PURPLE,
			Helper.OPTION_COLOR_RED=>Rez.Drawables.icon_bluetooth_16_RED,
			Helper.OPTION_COLOR_WHITE=>Rez.Drawables.icon_bluetooth_16_WHITE,
			Helper.OPTION_COLOR_YELLOW=>Rez.Drawables.icon_bluetooth_16_YELLOW
			}
		};
}
