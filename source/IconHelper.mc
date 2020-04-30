using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang as Lang;
using Toybox.Math as Mt;
using Toybox.Application;
using PropertiesHelper as Ph;
using ColorHelper as Ch;

/**
 This Helper class is used to manage icons
*/
module IconHelper {
	var runner = {
		Ch.BLACK=>Rez.Drawables.icon_runner_16_BLACK,
		Ch.BLUE=>Rez.Drawables.icon_runner_16_BLUE,
		Ch.DK_BLUE=>Rez.Drawables.icon_runner_16_DK_BLUE,
		Ch.DK_GRAY=>Rez.Drawables.icon_runner_16_DK_GRAY,
		Ch.DK_GREEN=>Rez.Drawables.icon_runner_16_DK_GREEN,
		Ch.DK_RED=>Rez.Drawables.icon_runner_16_DK_RED,
		Ch.GREEN=>Rez.Drawables.icon_runner_16_GREEN,
		Ch.LT_GRAY=>Rez.Drawables.icon_runner_16_LT_GRAY,
		Ch.ORANGE=>Rez.Drawables.icon_runner_16_ORANGE,
		Ch.PINK=>Rez.Drawables.icon_runner_16_PINK,
		Ch.PURPLE=>Rez.Drawables.icon_runner_16_PURPLE,
		Ch.RED=>Rez.Drawables.icon_runner_16_RED,
		Ch.WHITE=>Rez.Drawables.icon_runner_16_WHITE,
		Ch.YELLOW=>Rez.Drawables.icon_runner_16_YELLOW
	};
	var heart = {
		Ch.BLACK=>Rez.Drawables.icon_heart_16_BLACK,
		Ch.BLUE=>Rez.Drawables.icon_heart_16_BLUE,
		Ch.DK_BLUE=>Rez.Drawables.icon_heart_16_DK_BLUE,
		Ch.DK_GRAY=>Rez.Drawables.icon_heart_16_DK_GRAY,
		Ch.DK_GREEN=>Rez.Drawables.icon_heart_16_DK_GREEN,
		Ch.DK_RED=>Rez.Drawables.icon_heart_16_DK_RED,
		Ch.GREEN=>Rez.Drawables.icon_heart_16_GREEN,
		Ch.LT_GRAY=>Rez.Drawables.icon_heart_16_LT_GRAY,
		Ch.ORANGE=>Rez.Drawables.icon_heart_16_ORANGE,
		Ch.PINK=>Rez.Drawables.icon_heart_16_PINK,
		Ch.PURPLE=>Rez.Drawables.icon_heart_16_PURPLE,
		Ch.RED=>Rez.Drawables.icon_heart_16_RED,
		Ch.WHITE=>Rez.Drawables.icon_heart_16_WHITE,
		Ch.YELLOW=>Rez.Drawables.icon_heart_16_YELLOW
	};
	var notification = {
		Ch.BLACK=>Rez.Drawables.icon_enveloppe_16_BLACK,
		Ch.BLUE=>Rez.Drawables.icon_enveloppe_16_BLUE,
		Ch.DK_BLUE=>Rez.Drawables.icon_enveloppe_16_DK_BLUE,
		Ch.DK_GRAY=>Rez.Drawables.icon_enveloppe_16_DK_GRAY,
		Ch.DK_GREEN=>Rez.Drawables.icon_enveloppe_16_DK_GREEN,
		Ch.DK_RED=>Rez.Drawables.icon_enveloppe_16_DK_RED,
		Ch.GREEN=>Rez.Drawables.icon_enveloppe_16_GREEN,
		Ch.LT_GRAY=>Rez.Drawables.icon_enveloppe_16_LT_GRAY,
		Ch.ORANGE=>Rez.Drawables.icon_enveloppe_16_ORANGE,
		Ch.PINK=>Rez.Drawables.icon_enveloppe_16_PINK,
		Ch.PURPLE=>Rez.Drawables.icon_enveloppe_16_PURPLE,
		Ch.RED=>Rez.Drawables.icon_enveloppe_16_RED,
		Ch.WHITE=>Rez.Drawables.icon_enveloppe_16_WHITE,
		Ch.YELLOW=>Rez.Drawables.icon_enveloppe_16_YELLOW
	};
	var alarm = {
		Ch.BLACK=>Rez.Drawables.icon_bell_16_BLACK,
		Ch.BLUE=>Rez.Drawables.icon_bell_16_BLUE,
		Ch.DK_BLUE=>Rez.Drawables.icon_bell_16_DK_BLUE,
		Ch.DK_GRAY=>Rez.Drawables.icon_bell_16_DK_GRAY,
		Ch.DK_GREEN=>Rez.Drawables.icon_bell_16_DK_GREEN,
		Ch.DK_RED=>Rez.Drawables.icon_bell_16_DK_RED,
		Ch.GREEN=>Rez.Drawables.icon_bell_16_GREEN,
		Ch.LT_GRAY=>Rez.Drawables.icon_bell_16_LT_GRAY,
		Ch.ORANGE=>Rez.Drawables.icon_bell_16_ORANGE,
		Ch.PINK=>Rez.Drawables.icon_bell_16_PINK,
		Ch.PURPLE=>Rez.Drawables.icon_bell_16_PURPLE,
		Ch.RED=>Rez.Drawables.icon_bell_16_RED,
		Ch.WHITE=>Rez.Drawables.icon_bell_16_WHITE,
		Ch.YELLOW=>Rez.Drawables.icon_bell_16_YELLOW
	};
	var bluetooth = {
		Ch.BLACK=>Rez.Drawables.icon_bluetooth_16_BLACK,
		Ch.BLUE=>Rez.Drawables.icon_bluetooth_16_BLUE,
		Ch.DK_BLUE=>Rez.Drawables.icon_bluetooth_16_DK_BLUE,
		Ch.DK_GRAY=>Rez.Drawables.icon_bluetooth_16_DK_GRAY,
		Ch.DK_GREEN=>Rez.Drawables.icon_bluetooth_16_DK_GREEN,
		Ch.DK_RED=>Rez.Drawables.icon_bluetooth_16_DK_RED,
		Ch.GREEN=>Rez.Drawables.icon_bluetooth_16_GREEN,
		Ch.LT_GRAY=>Rez.Drawables.icon_bluetooth_16_LT_GRAY,
		Ch.ORANGE=>Rez.Drawables.icon_bluetooth_16_ORANGE,
		Ch.PINK=>Rez.Drawables.icon_bluetooth_16_PINK,
		Ch.PURPLE=>Rez.Drawables.icon_bluetooth_16_PURPLE,
		Ch.RED=>Rez.Drawables.icon_bluetooth_16_RED,
		Ch.WHITE=>Rez.Drawables.icon_bluetooth_16_WHITE,
		Ch.YELLOW=>Rez.Drawables.icon_bluetooth_16_YELLOW
	};
	
	function getIcon(dictionary, key){
		var colorKey = Ph.getValue(key);
		return dictionary.get(colorKey);
	}
	
	function getRunnerIcon(){
		//var key = Ph.getValue(Ph.PROP_ICON_COLOR_RUNNER);
		//return runner.get(key);
		return getIcon(runner, Ph.PROP_ICON_COLOR_RUNNER);
 	}  
 	
 	function getHeartIcon(){
		return getIcon(heart, Ph.PROP_ICON_COLOR_HEART);
 	}  
 	
 	function getBluetoothIcon(){
		return getIcon(bluetooth, Ph.PROP_ICON_COLOR_BLUETOOTH);
 	}  
 	function getAlarmIcon(){
		return getIcon(alarm, Ph.PROP_ICON_COLOR_ALARM);
 	}  
 	function getNotificationIcon(){
		return getIcon(notification, Ph.PROP_ICON_COLOR_NOTIFICATION);
 	}  
  
}