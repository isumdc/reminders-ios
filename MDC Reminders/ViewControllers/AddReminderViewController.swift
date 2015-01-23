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
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        var title = self.reminderTitleTextField.text;
        var date = self.reminderDatePicker.date;
        NSLog("Button pressed, with title: \(title),  date: \(date)");
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // The "Create" button will unwind to the ViewController, and the unwind will trigger this method
        
        // Get the new view controller using segue.destinationViewController.
        var secondScene = segue.destinationViewController as ViewController
        // Create new item within the ViewController's managedObjectContext.
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ReminderItem", inManagedObjectContext: secondScene.managedObjectContext!) as ReminderItem
        newItem.name = self.reminderTitleTextField.text
        newItem.date = self.reminderDatePicker.date
        newItem.enabled = false
        newItem.repeating = false
        newItem.frequency = 0
//        newItem.stopDate = self.stopDate
        
    }

}
