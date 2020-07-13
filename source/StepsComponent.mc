using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class StepsComponent extends GoalComponent {
	 
    function initialize(params) {
		GoalComponent.initialize(params);
    }
    
	function getCounterValue(){
		return Mon.getInfo().steps;
	}
	
	function getGoalValue(){
		return Mon.getInfo().stepGoal;
	}
    
}