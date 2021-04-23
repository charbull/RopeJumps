	using Toybox.WatchUi;

class RopeJumpsDelegate extends WatchUi.BehaviorDelegate {

	var parentRopeJumpsView;
	var ropeJumpsMenuDelegate;

    
    function initialize(ropeJumpsView) {
        BehaviorDelegate.initialize();
        ropeJumpsMenuDelegate = new RopeJumpsMenuDelegate(ropeJumpsView);
        parentRopeJumpsView = ropeJumpsView;
    }
    
    function onMenu() {
        System.println("[RopeJumpsDelegate] onMenu");
    
        WatchUi.pushView(new Rez.Menus.MainMenu(), ropeJumpsMenuDelegate, WatchUi.SLIDE_UP);
        return true;
    }
    
    
    

    // Call the start stop timer method on the parent view
    // when the select action occurs (start/stop button on most products)
    function onSelect() {
    System.println("[RopeJumpsDelegate] onSelect");
        parentRopeJumpsView.startStopTimer();
        return true;
    }

    // Call the reset method on the parent view when the
    // back action occurs.
    function onBack() {
    	System.println("[RopeJumpsDelegate] Onback");
        parentRopeJumpsView.onTimerPause();
        ropeJumpsMenuDelegate.onBack();
        
        //TODO(charbelk): use the the Activity.Session options
    }
    
}
