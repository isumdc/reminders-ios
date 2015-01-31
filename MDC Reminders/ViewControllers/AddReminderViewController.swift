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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stepperClicked(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
