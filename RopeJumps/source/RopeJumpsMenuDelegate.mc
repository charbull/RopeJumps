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
		return true;
	 
	}
	
		function onFooter(){  
	 System.println("[RopeJumpsMenuDelegate] onFooter");
	 	 pushDialog();
		return true;
	 
	}
	
	
				function onWrap(key){  
	 System.println("[RopeJumpsMenuDelegate] onWrap");
	 	 pushDialog();
		return true;
	 
	}
	
	
			function onTitle(){  
	 System.println("[RopeJumpsMenuDelegate] onTitle");
	 	 pushDialog();
		return true;
	 
	}
	
	function onDone(){  
	 System.println("[RopeJumpsMenuDelegate] onDone");
		pushDialog();
return true;
	}

	function onSelect(item){  
	 System.println("[RopeJumpsMenuDelegate] onSelect: "+item);
	 pushDialog();
return true;
	}


    function pushDialog() {
            dialog = new WatchUi.Confirmation(dialogHeaderString);
        WatchUi.pushView(dialog, new ConfirmationDialogDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return false;
   	}

}

class ConfirmationDialogDelegate extends WatchUi.ConfirmationDelegate {


    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
//    var user;
//        if (response == WatchUi.CONFIRM_NO) {
//            user = WatchUi.loadResource(Rez.Strings.Cancel);
//        } else {
//            user = WatchUi.loadResource(Rez.Strings.Confirm);
//        }
        System.println("[ConfirmationDialogDelegate]: "+response);
        return true;
    }
  }
