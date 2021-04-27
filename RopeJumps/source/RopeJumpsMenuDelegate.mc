using Toybox.WatchUi;
using Toybox.System;

class RopeJumpsMenuDelegate extends WatchUi.Menu2InputDelegate {

	hidden var dialogHeaderString;
	hidden var dialog;
	var parentRopeJumpsView;

    function initialize(ropeJumpsView) {
       Menu2InputDelegate.initialize();
        	 System.println("[RopeJumpsMenuDelegate] initialize");
        
        parentRopeJumpsView = ropeJumpsView;
    }
	
	function onDone(){  
	 System.println("[RopeJumpsMenuDelegate] onDone");
//		pushDialog();
	}

	function onSelect(item){  
	 System.println("[RopeJumpsMenuDelegate] onSelect: "+item.getLabel());
	 var actionId = item.getId();
	 if(actionId == :Save) {
	 	System.println("[RopeJumpsMenuDelegate] onSave: saving session");
		//WatchUi.pushView(Application.getApp().ropeJumpsView, null, WatchUi.SLIDE_IMMEDIATE);
       var progressBar = new WatchUi.ProgressBar(
            "Saving ...",
            0
        );
        WatchUi.pushView(progressBar, null, WatchUi.SLIDE_DOWN);
		parentRopeJumpsView.onSave();
		for(var i = 0 ; i<=100; i++){
			progressBar.setProgress(i);
		}
	
			//WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
			//	WatchUi.pushView(new ActionApplied("Activity Saved"), null, WatchUi.SLIDE_RIGHT);
				System.println("[RopeJumpsMenuDelegate] onSave: saved");
				       	System.exit();

		
	 } else if(actionId == :Discard) {
	 	System.println("[RopeJumpsMenuDelegate] onDiscard: asking");
	 	pushDialog(item.getLabel()+"?");
	 }
	}


    function pushDialog(action) {
            dialog = new WatchUi.Confirmation(action);
        WatchUi.pushView(dialog, new ConfirmationDialogDelegate(parentRopeJumpsView), WatchUi.SLIDE_IMMEDIATE);
        //return false;
   	}

}

class ConfirmationDialogDelegate extends WatchUi.ConfirmationDelegate {

	var parentRopeJumpsView;

    function initialize(ropeJumpsView) {
        ConfirmationDelegate.initialize();
        parentRopeJumpsView = ropeJumpsView;
    }

    function onResponse(response) {
        if (response == WatchUi.CONFIRM_NO) {
            //WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        } else {
            WatchUi.pushView(new ActionApplied("Discarded"), null, WatchUi.SLIDE_RIGHT);
           	System.println("[RopeJumpsMenuDelegate] onSave: Discarded");
           	parentRopeJumpsView.onDiscard();
			System.exit();
        }      
        return true;
    }
  }
  
  
  class ActionApplied extends WatchUi.View {

    hidden var myText;

    function initialize(text) {
        View.initialize();
        myText = text;
    }

    function onShow() {
        myText = new WatchUi.Text({
            :text=>myText,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        myText.draw(dc);
    }
}

class MyProgressDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
    	WatchUi.pushView(new ActionApplied("Activity Saved"), null, WatchUi.SLIDE_RIGHT);
    
        return true;
    }
}
