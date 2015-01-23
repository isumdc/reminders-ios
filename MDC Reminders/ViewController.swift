//
//  ViewController.swift
//  MDC Reminders
//
//  Created by Ian McDowell on 1/22/15.
//  Copyright (c) 2015 Mobile Development Club. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else { return nil }
    }()
    
    var arrayOfReminders: [ReminderItem] = []
    var firstRun: FirstRun?
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Custom Methods
    
    class func saveItem(reminder: ReminderItem) {
        
    }
    
    class func deleteItem(reminder: ReminderItem) {
        
    }
    
    func save() {
        
    }
    
    func fetchItems() {
        
    }
    
    @IBAction func unwindToTableVC(segue: UIStoryboardSegue) {
        // Nothing needed here
    }


}

