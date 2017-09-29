//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let activityLabels = ["🚗": "Driving", "🚴": "Cycling", "🏃": "Running", "🚶": "Walking", "👨‍💻":  "Stationary", "🤷‍♂️": "Unknown", "🕵": "Detecting activity..."];
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                self.currentStepsLabel.text = "Steps: \(newtotalSteps)"
            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var currentStepsLabel: UILabel!
    @IBOutlet weak var currentActivityEmojiLabel: UILabel!
    @IBOutlet weak var currentActivityLabel: UILabel!
    
    //MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.totalSteps = 0.0
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        
        currentActivityEmojiLabel.font = currentActivityEmojiLabel.font.withSize(48)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            var currentActivity: String = "";
            if unwrappedActivity.automotive {
                currentActivity = "🚗"
                
            } else if unwrappedActivity.cycling {
                currentActivity = "🚴"
            } else if unwrappedActivity.running {
                currentActivity = "🏃"
            } else if unwrappedActivity.walking {
                currentActivity = "🚶"
            } else if unwrappedActivity.stationary {
                currentActivity = "👨‍💻"
            } else if unwrappedActivity.unknown {
                currentActivity = "🤷‍♂️"
            } else {
                currentActivity = "🕵"
            }
            DispatchQueue.main.async{
                self.currentActivityEmojiLabel.text = currentActivity
                self.currentActivityLabel.text = self.activityLabels[currentActivity]
            }
        }
    }
    
    // MARK: Pedometer Functions
    func startPedometerMonitoring(){
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date(),
                                   withHandler: handlePedometer)
        }
    }
    
    //ped handler
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?)->(){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }


}

