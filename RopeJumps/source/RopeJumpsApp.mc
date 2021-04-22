using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;


class RopeJumpsApp extends Application.AppBase {

 var ropeJumpsView;
	
    function initialize() {
        AppBase.initialize();
        ropeJumpsView = new RopeJumpsView(); 
    }

    // onStart() is called on application start up
    function onStart(state) {
    	System.println("[RopeJumpsApp] Starting App");
       	ropeJumpsView.onStart(self, state);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        System.println("[RopeJumpsApp] Stopping App");
       	ropeJumpsView.onStop(self, state);
    }

	// This method runs each time the main application starts.
    // Return the initial view of your application here
    function getInitialView() {
        return [ropeJumpsView , new RopeJumpsDelegate(ropeJumpsView) ];
    }
    

}
