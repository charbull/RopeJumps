using Toybox.WatchUi;
using Toybox.System;

class RopeJumpsMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }
        //TODO(charbelk): use the the Activity.Session options

	function onBack(){
	    System.println("[Menu2InputDelegate] OnBack");
		//Menu2InputDelegate.onBack();
	}


//    function onMenuItem(item) {
//    System.println("OnMenu");
//        if (item == "Onback") {
//            System.println("item 1");
//        } else if (item == :item_2) {
//            System.println("item 2");
//        }
//    }

}