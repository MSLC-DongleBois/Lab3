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
    var yesterdaysSteps: Float = 0.0
    var todaysSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                self.todaysStepsLabel.text = "\(newtotalSteps)"
            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var currentActivityEmojiLabel: UILabel!
    @IBOutlet weak var currentActivityLabel: UILabel!
    @IBOutlet weak var todaysStepsLabel: UILabel!
    @IBOutlet weak var yesterdaysStepsLabel: UILabel!
    @IBOutlet weak var stepsProgressBar: UIProgressView!
    
    //MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        self.setTodaysSteps()
        self.setYesterdaysSteps()
        self.yesterdaysStepsLabel.text = String(self.yesterdaysSteps)

        currentActivityEmojiLabel.font = currentActivityEmojiLabel.font.withSize(48)
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
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?) -> (){
        if let steps = pedData?.numberOfSteps {
            let totalSteps = self.todaysSteps + steps.floatValue
            self.todaysStepsLabel.text = String(totalSteps)
            self.stepsProgressBar.progress = totalSteps/500
        }
    }

    // Get number of steps today
    func setTodaysSteps() {
        let startOfToday: Date = Calendar.current.startOfDay(for: Date())
        
        var components = DateComponents()
        components.day = 1
        components.second = -1
//        let endOfToday: Date! = Calendar.current.date(byAdding: components, to: startOfDay)
        
        let endOfToday: Date = Calendar.current.startOfDay(for: Date.init(timeIntervalSinceNow: 86400))
        
        self.pedometer.queryPedometerData(from: startOfToday, to: endOfToday, withHandler: handleTodaysStepCounting)
    }
    
    // Get total number of steps yesterday
    func setYesterdaysSteps() {
        let startOfToday: Date = Calendar.current.startOfDay(for: Date())
        
//        var startDayComponents = DateComponents()
//        startDayComponents.day = -1
//        startDayComponents.second = -1
//        let startOfYesterday: Date! = Calendar.current.date(byAdding: startDayComponents, to: startOfToday)
        let startOfYesterday: Date = Calendar.current.startOfDay(for: Date.init(timeIntervalSinceNow: -86400))
        
        self.pedometer.queryPedometerData(from: startOfYesterday, to: startOfToday, withHandler: handleYesterdaysStepCounting)
    }
    
    // Handler for setTodaysSteps()
    func handleTodaysStepCounting(pedData: CMPedometerData?, error:Error?) -> Void {
        if let steps = pedData?.numberOfSteps {
            self.todaysSteps = steps.floatValue
        }
    }
    
    // Handler for setYesterdaysSteps()
    func handleYesterdaysStepCounting(pedData: CMPedometerData?, error:Error?) -> Void {
        if let steps = pedData?.numberOfSteps {
            self.yesterdaysSteps = steps.floatValue
        }
    }

}

