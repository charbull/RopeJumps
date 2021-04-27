	using Toybox.WatchUi;

class RopeJumpsDelegate extends WatchUi.BehaviorDelegate {

	var parentRopeJumpsView;
	var ropeJumpsMenuDelegate;

    
    function initialize(ropeJumpsView) {
        BehaviorDelegate.initialize();
        parentRopeJumpsView = ropeJumpsView;
    }
    
//    function onMenu() {
//        System.println("[RopeJumpsDelegate] onMenu");
//    
//        WatchUi.pushView(new Rez.Menus.ExitMenu(), new RopeJumpsMenuDelegate(), WatchUi.SLIDE_UP);
//        return true;
//    }
    
    
     // Detect Menu button input
    function onKey(keyEvent) {
        System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
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
        WatchUi.pushView(new Rez.Menus.ExitMenu(), new RopeJumpsMenuDelegate(parentRopeJumpsView), WatchUi.SLIDE_IMMEDIATE);
       return true;
        //TODO(charbelk): use the the Activity.Session options
    }
    
    
    
    
}
