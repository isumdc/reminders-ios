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
    
    var futureReminders: [ReminderItem] = []
    var pastReminders: [ReminderItem] = []
    
    var dateFormatter = NSDateFormatter()
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets date format for use during Reminder Item saves
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchItems()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return self.futureReminders.count
        case 1:
            return self.pastReminders.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Future Reminders"
        case 1:
            return "Past Reminders"
        default:
            return nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var reminder: ReminderItem
        if (indexPath.section == 0) {
            reminder = self.futureReminders[indexPath.row]
        } else {
            reminder = self.pastReminders[indexPath.row]
        }
        
        cell.textLabel?.text = reminder.name
        
        cell.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(reminder.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        cell.accessoryType = (reminder.enabled.boolValue ? .Checkmark : .None)

        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        var reminder: ReminderItem
        if (indexPath.section == 0) {
            reminder = self.futureReminders[indexPath.row]
        } else {
            reminder = self.pastReminders[indexPath.row]
        }
        reminder.enabled = NSNumber(bool: !reminder.enabled.boolValue)
        
        self.save()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete) {
            NSLog("Deleting item")
            
            // Find the LogItem object the user is trying to delete
            var reminder: ReminderItem
            if (indexPath.section == 0) {
                reminder = self.futureReminders[indexPath.row]
            } else {
                reminder = self.pastReminders[indexPath.row]
            }
            
            // Delete it from the managedObjectContext
            managedObjectContext?.deleteObject(reminder)
            
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
        let futureFetchRequest = NSFetchRequest(entityName: "ReminderItem")
        futureFetchRequest.predicate = NSPredicate(format: "date >= %@", NSDate())
        
        // Create a sort descriptor object that sorts on the "date" property of the Core Data object, and set it on the fetch request
        futureFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        // Execute the fetch request, storying the results in the array of reminder items
        if let fetchResults = managedObjectContext!.executeFetchRequest(futureFetchRequest, error: nil) as? [ReminderItem] {
            self.futureReminders = fetchResults
        }
        
        
        // Create a fetch request to customize what you are requesting
        let pastFetchRequest = NSFetchRequest(entityName: "ReminderItem")
        pastFetchRequest.predicate = NSPredicate(format: "date < %@", NSDate())
        
        // Create a sort descriptor object that sorts on the "date" property of the Core Data object, and set it on the fetch request
        pastFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        // Execute the fetch request, storying the results in the array of reminder items
        if let fetchResults = managedObjectContext!.executeFetchRequest(pastFetchRequest, error: nil) as? [ReminderItem] {
            self.pastReminders = fetchResults
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
        
        NSLog("Added new ReminderItem to data model. Name: \(newItem.name) Date: \(newItem.date)")
        
        self.tableView.reloadData()
        
        // Save the data model
        save()
    }

}
