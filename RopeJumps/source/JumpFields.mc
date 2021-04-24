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
	hidden var timerRunning = false;
	const CAL = 1;
	const JUMPS = 2;
	var mSession;
	var mLogger;	
	
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
   		var xAccel = sensorData.accelerometerData.x;
    	var yAccel = sensorData.accelerometerData.y;
    	var zAccel = sensorData.accelerometerData.z;
    	System.println("x: " + xAccel + ", y: " + yAccel+ ", z: " + zAccel);
    	
    }
    

    //TODO: need the heart rate here and the accelerator
    function calculateJumps(info) {
    	var hr = 0;
    	if (info has :currentHeartRate && 
    		info.currentHeartRate != null 
    		&& info.currentHeartRate > 0) {
			if (hr != info.currentHeartRate) {
				hr = info.currentHeartRate;
				jumps = jumps + 1;
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
				cal = info.calories;
			}
         	calories = Lang.format("$1$", [cal.format("%01d")]); 
       	}      
    }
    
    function compute(info) {
    
    	if(!timerRunning) {
    		calories = (cal == 0) ? "--" : Lang.format("$1$", [cal.format("%01d")]); 
    		numberOfJumps = (jumps == 0 )? "--" : Lang.format("$1$", [jumps.format("%01d")]);    		
    	} else {
    		if (info has :Workout && 
    			info.Workout != null) {
    		System.println(info.Workout.activeStep);
    		}
    		calculateJumps(info);
    		calculateCalories(info);
    	}
    }
    
    function onStart(app) {
        System.println("[JumpFields] On Start");
    
		var info = Activity.getActivityInfo();
		
		// if the activity has restarted after "resume later", 
		// load previously stored steps values
		if (info != null) {
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
        
    }
    
   function onStop(app) {
        System.println("[JumpFields] On Stop");
    	// store current values of steps on stop for later usage (e.g., resume later)
        app.setProperty(CAL, cal);
        app.setProperty(JUMPS, jumps);
    }
    
    // start/resume
    function onActivityStart() {
    	timerRunning = true;
    }
    
    // stop/pause
    function onActivityStop() {
    	timerRunning = false;
    }
    
    // start/resume
    function onSave() {
        System.println("[JumpFields] OnSave");
        	 Sensor.unregisterSensorDataListener();
        mSession.stop();
    	mSession.save();

    }
    
        // start/resume
    function onDiscard() {
            	 Sensor.unregisterSensorDataListener();
        mSession.stop();
    	mSession.discard();
    }
    
}