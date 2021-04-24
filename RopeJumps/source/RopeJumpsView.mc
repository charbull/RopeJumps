using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.Timer;

class RopeJumpsView extends WatchUi.View {

   	hidden var jumpFields;
	hidden var width;
	hidden var third_height;
	hidden var thenth_height;
	hidden var timerLabelView;
	hidden var timerValueView;
	hidden var jumpsLabelView;
	hidden var jumpsValueView;
	hidden var caloriesLabelView;
	hidden var caloriesValueView;
	hidden var updateTimer;
	hidden var timerStartTime;
	hidden var timerPauseTime;
	var latestElapsedTime;
	hidden var seconds = 0;
	hidden var minutes = 0;
		
	
    // Set the label of the data field here.
    function initialize() {
        View.initialize();
        jumpFields = new JumpFields();  
        // Create our timer object that is used to drive display updates
        updateTimer = new Timer.Timer();

       // Update the display each second.
       updateTimer.start(method(:requestUpdate), 1000, true);
    }

    	
   function compute() {
   		var activityMonitorInfo = ActivityMonitor.getInfo();
		var activityInfo = Activity.getActivityInfo();
        jumpFields.compute(activityInfo, activityMonitorInfo); 
   }
    
 
    
     // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
    
        System.println("[JumpRopeView] onUpdate");
        
		calculateElapsedTime();
		compute();
		       
		
        // Set the foreground color and value
        var timerValue = View.findDrawableById("timerValue");
        timerValue.setText(latestElapsedTime);
        if(timerPauseTime != null){
       		timerValue.setColor(Graphics.COLOR_ORANGE);
        } else {
        	timerValue.setColor(Graphics.COLOR_GREEN);
        }
        
        var jumpsValue = View.findDrawableById("jumpsValue");
        jumpsValue.setText(jumpFields.numberOfJumps);
        jumpsValue.setColor(Graphics.COLOR_WHITE);
        
        var caloriesValue = View.findDrawableById("caloriesValue");
        caloriesValue.setText(jumpFields.calories);
        caloriesValue.setColor(Graphics.COLOR_WHITE);
        

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
        //draw two lines
        dc.drawLine(0, third_height, width, third_height);
      	dc.drawLine(0, third_height*2, width, third_height*2);
      
    }
    
     // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
      
      dc.clear();
      
      compute();        
      
      System.println("[JumpRopeView] onLayout");
      
      third_height = dc.getHeight()/3;
      width = dc.getWidth();
      thenth_height = dc.getHeight()/10;
      
      View.setLayout(Rez.Layouts.MainLayout(dc));
      timerLabelView = View.findDrawableById("timerLabel");
      timerLabelView.locY = timerLabelView.locY - third_height - thenth_height/2;
      timerValueView = View.findDrawableById("timerValue");
      timerValueView.locY = timerValueView.locY - third_height + thenth_height ;
      
      jumpsLabelView = View.findDrawableById("jumpsLabel");
      jumpsLabelView.locY = jumpsLabelView.locY - thenth_height/2;
      jumpsValueView = View.findDrawableById("jumpsValue");
      jumpsValueView.locY = jumpsValueView.locY + thenth_height;
      
      caloriesLabelView = View.findDrawableById("caloriesLabel");
      caloriesLabelView.locY = caloriesLabelView.locY + third_height - thenth_height/2;
      caloriesValueView = View.findDrawableById("caloriesValue");
      caloriesValueView.locY = caloriesValueView.locY + third_height + thenth_height;   
    
      View.findDrawableById("timerLabel").setText(Rez.Strings.TimerFieldText);
      View.findDrawableById("jumpsLabel").setText(Rez.Strings.JumpsFieldText);
      View.findDrawableById("caloriesLabel").setText(Rez.Strings.CaloriesFieldText);
               
    }
    
    function onStart(app, state) {
    	System.println("[JumpRopeView] starting view");
    	jumpFields.onStart(app);
    	//startStopTimer();
    }
    
    function onStop(app, state) {
    	System.println("[JumpRopeView] stopping view");
    	jumpFields.onStop(app);
    	onTimerPause();
    }
    
	// If the timer is running, pause it. Otherwise, start it up.
    function startStopTimer() {
   	 var now = Time.now().value();

		//start the timer
        if(timerStartTime == null) {
            timerStartTime = now;
            updateTimer.start(method(:requestUpdate), 1000, true);
            jumpFields.onActivityStart();
 		} else {
 			//pause the timer
            if(timerPauseTime == null) {
                timerPauseTime = now;
                updateTimer.stop();
                WatchUi.requestUpdate();
            } else {
                timerStartTime += (now - timerPauseTime );
                timerPauseTime = null;
                updateTimer.start(method(:requestUpdate), 1000, true);
            }
         }
    	
    }
    
    function onTimerStop() {
    	jumpFields.onActivityStop();
    }
    
    function onTimerResume() {
    	jumpFields.onActivityStart();
    }
    
    function onTimerPause() {
    System.println("[RopeJumpView] onTimerPause: "+timerPauseTime);
   
    if(timerPauseTime == null) {
    	timerPauseTime = Time.now().value();
        updateTimer.stop();
        WatchUi.requestUpdate();
         System.println("[RopeJumpView] onTimerPause: updating ");
      }
    }
    
     

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
        // This is the callback method we use for our timer. It is
    // only needed to request display updates as the timer counts
    // down so we see the updated time on the display.
    function requestUpdate() {
        WatchUi.requestUpdate();
    }
    
    	/** Calculates the time from milliseconds and 
	update latestElapsedTime with a formatted string "mm:ss". */
    function calculateElapsedTime(){
    	if(timerStartTime != null && timerPauseTime == null) {
        	var milliseconds = Time.now().value() - timerStartTime;
    		seconds = milliseconds % 60 ;
			minutes = milliseconds / 60;
		}
		latestElapsedTime = Lang.format("$1$:$2$",
    		[minutes.format("%02d"), seconds.format("%02d")]); 
    }
    
       // start/resume
    function onSave() {
    System.println("[RopeJumpView] OnSave");
    	return jumpFields.onSave();
    }

}
