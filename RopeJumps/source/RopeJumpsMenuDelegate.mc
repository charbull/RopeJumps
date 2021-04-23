using Toybox.WatchUi;
using Toybox.System;

class RopeJumpsMenuDelegate extends WatchUi.Menu2InputDelegate {

	hidden var dialogHeaderString;
	hidden var dialog;
	var parentRopeJumpsView;

    function initialize(ropeJumpsView) {
        Menu2InputDelegate.initialize();
        parentRopeJumpsView = ropeJumpsView;
        dialogHeaderString = WatchUi.loadResource(Rez.Strings.DialogHeader);
    }
        //TODO(charbelk): use the the Activity.Session options

	function onBack(){  
	 System.println("[RopeJumpsMenuDelegate] OnBack");
	 pushDialog();
	
	}
	
	function onDone(){  
	 System.println("[RopeJumpsMenuDelegate] onDone");
	 pushDialog();
	}

	function onSelect(){  
	 System.println("[RopeJumpsMenuDelegate] onSelect");
	 pushDialog();
	}


    function pushDialog() {
            dialog = new WatchUi.Confirmation(dialogHeaderString);
        WatchUi.pushView(dialog, new ConfirmationDialogDelegate(), WatchUi.SLIDE_IMMEDIATE);
//            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        
        return false;
   	}



class ConfirmationDialogDelegate extends WatchUi.ConfirmationDelegate {


    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
    	var reponse;
        if (response == WatchUi.CONFIRM_NO) {
            reponse = WatchUi.loadResource(Rez.Strings.Cancel);
        } else {
            reponse = WatchUi.loadResource(Rez.Strings.Confirm);
        }
        System.println("[ConfirmationDialogDelegate]: "+response);
    }
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