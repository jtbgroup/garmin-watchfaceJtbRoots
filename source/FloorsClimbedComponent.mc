using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Mon;

class FloorsClimbedComponent extends GoalComponent {
	

	function initialize(params) {
		GoalComponent.initialize(params);
    }
   
    function getCounterValue(){
		return Mon.getInfo().floorsClimbed;
	}
	
	function getGoalValue(){
		return Mon.getInfo().floorsClimbedGoal;
	}
	
	function canMonitor(){
		return Mon.getInfo() has :floorsClimbed;
	}
}