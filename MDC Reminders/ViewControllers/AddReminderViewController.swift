//
//  AddReminderViewController.swift
//  MDC Reminders
//
//  Created by Ian McDowell on 1/22/15.
//  Copyright (c) 2015 Mobile Development Club. All rights reserved.
//

import UIKit
import CoreData

class AddReminderViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var reminderTitleTextField: UITextField!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var repeatSlider: UISlider!
    @IBOutlet weak var repeatFrequencyLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var beginTimeStepper: UIStepper!
    @IBOutlet weak var endTimeStepper: UIStepper!
    
    var frequencyInSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stepperClicked(self)
        sliderMoved(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func sliderMoved(sender: AnyObject) {
        let sliderValue = repeatSlider.value
        if (sliderValue == 0) {
            repeatFrequencyLabel.text = "Never"
            frequencyInSeconds = 0
            return
        } else if (sliderValue < 0.1) {
            repeatFrequencyLabel.text = "5 minutes"
            frequencyInSeconds = 5 * 60
            return
        } else if (sliderValue < 0.2) {
            repeatFrequencyLabel.text = "10 minutes"
            frequencyInSeconds = 10 * 60
            return
        } else if (sliderValue < 0.3) {
            repeatFrequencyLabel.text = "15 minutes"
            frequencyInSeconds = 15 * 60
            return
        } else if (sliderValue < 0.4) {
            repeatFrequencyLabel.text = "30 minutes"
            frequencyInSeconds = 30 * 60
            return
        } else if (sliderValue < 0.5) {
            repeatFrequencyLabel.text = "1 hour"
            frequencyInSeconds = 60 * 60
            return
        } else if (sliderValue < 0.6) {
            repeatFrequencyLabel.text = "2 hours"
            frequencyInSeconds = 2 * 60 * 60
            return
        } else if (sliderValue < 0.7) {
            repeatFrequencyLabel.text = "3 hours"
            frequencyInSeconds = 3 * 60 * 60
            return
        } else if (sliderValue < 0.8) {
            repeatFrequencyLabel.text = "6 hours"
            frequencyInSeconds = 6 * 60 * 60
            return
        } else if (sliderValue < 0.9) {
            repeatFrequencyLabel.text = "day"
            frequencyInSeconds = 24 * 60 * 60
            return
        } else if (sliderValue < 1) {
            repeatFrequencyLabel.text = "week"
            frequencyInSeconds = 7 * 24 * 60 * 60
            return
        } else if (sliderValue == 1) {
            repeatFrequencyLabel.text = "month"
            frequencyInSeconds = 30 * 7 * 24 * 60 * 60  // Figure out a better month calculation later
        }
    }
    
    @IBAction func stepperClicked(sender: AnyObject) {
        // Set the beginning hour time label
        let beginTime = Int(beginTimeStepper.value)
        let beginTime12 = beginTime % 12
        if (beginTime > 0 && beginTime < 12) {
            beginTimeLabel.text = "\(beginTime12) am"
        } else if (beginTime > 12 && beginTime < 24) {
            beginTimeLabel.text = "\(beginTime12) pm"
        } else if (beginTime == 0) {
            beginTimeLabel.text = "12 am"
        } else if (beginTime == 12) {
            beginTimeLabel.text = "noon"
        } else if (beginTime == 24) {
            beginTimeLabel.text = "11:59 pm"
        }

        // Set the ending hour time label
        let endTime = Int(endTimeStepper.value)
        let endTime12 = endTime % 12
        if (endTime > 0 && endTime < 12) {
            endTimeLabel.text = "\(endTime12) am"
        } else if (endTime > 12 && endTime < 24) {
        endTimeLabel.text = "\(endTime12) pm"
        } else if (endTime == 0) {
            endTimeLabel.text = "12 am"
        } else if (endTime == 12) {
            endTimeLabel.text = "noon"
        } else if (endTime == 24) {
            endTimeLabel.text = "11:59 pm"
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
