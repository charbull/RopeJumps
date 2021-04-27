using Toybox.Time as Time;
using Toybox.Timer as Timer;
using Toybox.System as System;
using Toybox.Sensor;
using Toybox.SensorLogging;



class JumpFields {

	var numberOfJumps = "--";
	var calories = "--";
	hidden var cal = 0;
	hidden var jumps = 0;
	//jumps from acceleration
	hidden var jumpsAcc = 0;
	hidden var lastAcceleration = 0;
	
	hidden var timerRunning = false;
	const CAL = 1;
	const JUMPS = 2;
	var mSession;
	var mLogger;	
	hidden var wholeDaySteps = 0;
	hidden var lastDeltaSteps = 0;
	hidden var wholeDayCalories = 0;
	
	 // Constructor
    function initialize() {
        try {
            mSession = ActivityRecording.createSession({:name=>"Rope Jumps", 
            :sport=>ActivityRecording.SPORT_GENERIC, 
            :sensorLogger => new SensorLogging.SensorLogger({:enableAccelerometer => true})});
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
    }
	
	
	    // Callback to receive accel data
    function accelerationCallback(sensorData) {
//    	var zAccel = sensorData.accelerometerData.z;
//    	System.println("z: " + zAccel);
//		var currentAcc = 0;
//    	if(timerRunning) {
//    		for(var i = 0; i< zAccel.size();i++){
//    	  		 currentAcc = zAccel[i];
//    	  		 System.println("[JumpField]: i "+i+", currentAcc: "+currentAcc+", lastAcceleration: "+lastAcceleration);
//    	  		 
//    	  		if(lastAcceleration > 0 && currentAcc < 0){
//    	    		jumpsAcc = jumpsAcc + 1;
//    	  		} else if (lastAcceleration < 0 && currentAcc > 0){
//    	    		jumpsAcc = jumpsAcc + 1;
//    	 		}
//    	 		lastAcceleration = currentAcc;
//    	      	System.println("[JumpField]: jumpsAcc "+jumpsAcc);
//    	  	}
//    	}	  	
    }
    

    //TODO: need the heart rate here and the accelerator
    function calculateJumps(activityInfo, activityMonitorInfo) {
    	// delta steps but the user might just have walked and not jumped.
		var deltaSteps = activityMonitorInfo.steps - wholeDaySteps;
		System.println("[JumpField]: info.steps: "+activityMonitorInfo.steps+ " , wholeDaySteps: "+wholeDaySteps);

		var hr = 0;
		
    	if (activityInfo has :currentHeartRate && 
    		activityInfo.currentHeartRate != null 
    		&& activityInfo.currentHeartRate > 0) {
			if (hr != activityInfo.currentHeartRate) {
				hr = activityInfo.currentHeartRate;
				
				if( lastDeltaSteps != deltaSteps) {
				jumps = jumps + (deltaSteps - lastDeltaSteps);
				lastDeltaSteps = deltaSteps;
				}
//				if(jumpsAcc == deltaSteps) {
//					jumps = jumps + jumpsAcc;
//					System.println("[JumpField]: deltaSteps == jumps == "+jumps);
//				} 
//				// the acceleration and the deltaSteps are different take the average
//				else {
//					jumps = deltaSteps == 0? jumps + jumpsAcc : jumps + (jumpsAcc + deltaSteps)/2;
//					System.println("[JumpField]: deltaSteps == "+deltaSteps+" \n deltaSteps == "+deltaSteps+"\n calculated jumps=: "+jumps);
//				}
				
			}
      	numberOfJumps = Lang.format("$1$", [jumps.format("%01d")]);
       	}      
    }
    
    //todo: https://github.com/rgergely/polesteps/blob/master/source/FitContributions.mc
    function calculateCalories(info) {
    	if (info has :calories && 
    		info.calories != null 
    		&& info.calories > 0) {
			if (cal != info.calories) {
				cal = info.calories - wholeDayCalories;
			}
         	calories = Lang.format("$1$", [cal.format("%01d")]); 
       	}      
    }
    
    function compute(activityInfo, activityMonitorInfo) {
    	var info = Activity.getActivityInfo();
    	if(!timerRunning) {
    		calories = (cal == 0) ? "--" : Lang.format("$1$", [cal.format("%01d")]); 
    		numberOfJumps = (jumps == 0 )? "--" : Lang.format("$1$", [jumps.format("%01d")]);    		
    	} else {
    		calculateJumps(activityInfo, activityMonitorInfo);
    		calculateCalories(activityInfo);
    	}
    }
    
    function onStart(app) {
        System.println("[JumpFields] On Start");
    
		var activityMonitorInfo = ActivityMonitor.getInfo();
		//The step count since midnight for the current day in number of steps. 
		//Value may be null.
    	wholeDaySteps = (activityMonitorInfo.steps != null)? activityMonitorInfo.steps : 0 ;
    	System.println("[JumpFields] On Start, wholeDaySteps: "+wholeDaySteps);
    	
    	var activityInfo = Activity.getActivityInfo();
    	
    	wholeDayCalories = (activityInfo.calories != null)? activityInfo.calories : 0 ;
    	System.println("[JumpFields] On Start, wholeDayCalories: "+wholeDayCalories);
    	
    	
		
		// if the activity has restarted after "resume later", 
		// load previously stored steps values
		if (activityMonitorInfo != null) {
	        calories = Lang.format("$1$", [CAL.format("%01d")]); 
	        numberOfJumps = Lang.format("$1$", [JUMPS.format("%01d")]);
        } 
        
              // initialize accelerometer
        var options = {:period => 1, :sampleRate => 8, :enableAccelerometer => true};
        try {
            Sensor.registerSensorDataListener(method(:accelerationCallback), options);
            //TODO: create field on the session
            //https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityRecording/Session.html#createField-instance_function
            mSession.start();
        }
        catch(e) {
            System.println(e.getErrorMessage());
        }
        return true;
        
    }
    
   function onStop(app) {
        System.println("[JumpFields] On Stop");
    	// store current values of steps on stop for later usage (e.g., resume later)
        app.setProperty(CAL, cal);
        app.setProperty(JUMPS, jumps);
        return true;
    }
    
    // start
    function onActivityStart() {
    	timerRunning = true;
    	if(!mSession.isRecording()){
        	mSession.start();
        }
        return true;
    }
    
    // stop/pause
    function onActivityStop() {
    	timerRunning = false;
    	if(mSession.isRecording()){
        	mSession.stop();
        }
        return true;
    }
    
    // start/resume
    function onSave() {
        System.println("[JumpFields] OnSave");
       	Sensor.unregisterSensorDataListener();
       	if(mSession.isRecording()){
        	mSession.stop();
        }
    	return mSession.save();

    }
    
    function onDiscard() {
        Sensor.unregisterSensorDataListener();
		if(mSession.isRecording()){
        	mSession.stop();
        }   
        return mSession.discard();
    }
    
}