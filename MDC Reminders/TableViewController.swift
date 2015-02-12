//
//  TableViewController.swift
//  MDC Reminders
//
//  Created by Nathan Karasch on 1/24/15.
//  Copyright (c) 2015 Mobile Development Club. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else { return nil }
        }()
    
    var arrayOfReminders: [ReminderItem] = []
    var firstRun: Bool?
    var dateFormatter = NSDateFormatter()
    
    
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets date format for use during Reminder Item saves
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        // Fetch "FirstRun" from the NSUserDefaults and test to see if this is the first time the user has run the app
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let testFirstRun = defaults.objectForKey("FirstRun") as? Bool {
            self.firstRun = defaults.boolForKey("FirstRun")
        }
        if firstRun? == false {
            // No first run methods are called if it's not the first run
        } else {
            // If it's the first time the user has run the app, run one-time-only methods here
            println("First run actions taken.")
            
            // Set FirstRun in NSUserDefaults to false
            defaults.setBool(false, forKey: "FirstRun")
            defaults.synchronize()
        }
        
        // The initial fetch in viewDidLoad() is necessary to present the items when the app is loaded
        fetchItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrayOfReminders.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = arrayOfReminders[indexPath.row].name
        let formattedDate = NSDateFormatter.localizedStringFromDate(arrayOfReminders[indexPath.row].date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        cell.detailTextLabel?.text = formattedDate
        if (arrayOfReminders[indexPath.row].enabled == true) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark } else { cell.accessoryType = UITableViewCellAccessoryType.None }

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete) {
            NSLog("Deleting item")
            
            // Find the LogItem object the user is trying to delete
            let itemToDelete = arrayOfReminders[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedObjectContext?.deleteObject(itemToDelete)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchItems()
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            save()
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    
    // MARK: - Custom Methods
    
    func save() {
        var error: NSError?
        if (managedObjectContext!.save(&error)) {
            NSLog("Data model saved. Errors: \(error?.localizedDescription)")
        }
    }
    
    func fetchItems() {
        // Create a fetch request to customize what you are requesting
        let fetchRequest = NSFetchRequest(entityName: "ReminderItem")
        
        // Create a sort descriptor object that sorts on the "date" property of the Core Data object, and set it on the fetch request
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute the fetch request, storying the results in the array of reminder items
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ReminderItem] {
            arrayOfReminders = fetchResults
        }
        
        NSLog("Fetched items from data model")
    }
    
    @IBAction func saveItem(segue: UIStoryboardSegue) {
        
        // Get the new view controller using segue.destinationViewController.
        var secondScene = segue.sourceViewController as AddReminderViewController
        
        // Create new item within the ViewController's managedObjectContext.
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ReminderItem", inManagedObjectContext: managedObjectContext!) as ReminderItem
        newItem.name = secondScene.reminderTitleTextField.text
        
        // The bit of juggling before storing the date is required to truncate the seconds from the date.
        // Otherwise the alarm won't happen right at the top of the minute.
        // Since the dateFormatter's dateStyle and timeStyle are ShortStyle, it only keeps D/M/Y and H:M
        let dateString = dateFormatter.stringFromDate(secondScene.reminderDatePicker.date)
        
        let dateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: secondScene.reminderDatePicker.date);
        
        let date = NSCalendar.currentCalendar().dateFromComponents(dateComponents);

        newItem.date = date!
        newItem.enabled = secondScene.enableSwitch.on
        newItem.repeating = false
        newItem.frequency = 0
//        newItem.stopDate = self.stopDate
        
        // Update the array
        fetchItems()
        
        // refresh our local notifications and add this one to the system
        NotificationManager.updateNotifications();
        
        // Animate in the new row
        // Use Swift's find() function to figure out the index of the newLogItem
        // After it's been added and sorted in our logItems array
        if let newItemIndex = find(arrayOfReminders, newItem) {
            // Create an NSIndexPath from the newItemIndex
            let newItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
            // Animate in the insertion of this row
            tableView.insertRowsAtIndexPaths([ newItemIndexPath ], withRowAnimation: .Automatic)
        }
        NSLog("Added new ReminderItem to data model. Name: \(newItem.name) Date: \(newItem.date)")
        
        // Save the data model
        save()
    }

}
