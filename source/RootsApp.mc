using Toybox.Application;
using Toybox.System as Sys;
using RootsConstants as Cst;
using JTBHelper as Helper;

class RootsApp extends Application.AppBase {

	var view;
	
    function initialize() {
        AppBase.initialize();
        loadIconDictionaries();
    }

	function loadIconDictionaries(){
		var rez = {
			Cst.DICT_ICON_RUNNER => {
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
			Cst.DICT_ICON_HEART => {
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
			Cst.DICT_ICON_NOTIFICATION => {
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
			Cst.DICT_ICON_ALARM => {
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
			Cst.DICT_ICON_BLUETOOTH => {
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
		
		JTBHelper.loadColoredIconRez(rez);
	}
	
    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	view =  new RootsJtbView();
        return [ view ];
    }
	
	function onSettingsChanged(){
		view.reloadBasics();
	}

}