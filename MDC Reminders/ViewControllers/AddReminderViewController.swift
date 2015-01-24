//
//  AddReminderViewController.swift
//  MDC Reminders
//
//  Created by Ian McDowell on 1/22/15.
//  Copyright (c) 2015 Mobile Development Club. All rights reserved.
//

import UIKit
import CoreData

class AddReminderViewController: UIViewController {
    
    @IBOutlet weak var reminderTitleTextField: UITextField!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
