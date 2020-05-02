using Toybox.Application;
using Toybox.System as Sys;
using RootsConstants as Cst;
using JTBHelper as Helper;

class RootsApp extends Application.AppBase {

	var view;
	
    function initialize() {
        AppBase.initialize();
        JTBHelper.loadColoredIconRez(Cst.iconsDictionary);
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