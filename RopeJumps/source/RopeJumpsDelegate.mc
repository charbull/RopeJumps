using Toybox.WatchUi;

class RopeJumpsDelegate extends WatchUi.BehaviorDelegate {

	var parentRopeJumpsView;
	var ropeJumpsMenuDelegate;
	

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), ropeJumpsMenuDelegate, WatchUi.SLIDE_UP);
        return true;
    }
    
    function initialize(ropeJumpsView) {
        BehaviorDelegate.initialize();
        ropeJumpsMenuDelegate = new RopeJumpsMenuDelegate();
        parentRopeJumpsView = ropeJumpsView;
    }

    // Call the start stop timer method on the parent view
    // when the select action occurs (start/stop button on most products)
    function onSelect() {
        parentRopeJumpsView.startStopTimer();
        return true;
    }

    // Call the reset method on the parent view when the
    // back action occurs.
    function onBack() {
    	System.println("Onback");
        parentRopeJumpsView.onTimerPause();
        //ropeJumpsMenuDelegate.onMenuItem("Onback");
        ropeJumpsMenuDelegate.onBack();
        //TODO(charbelk): use the the Activity.Session options
    }

}