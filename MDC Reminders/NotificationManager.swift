//
//  NotificationManager.swift
//  MDC Reminders
//
//  Created by Ian McDowell on 2/12/15.
//  Copyright (c) 2015 Mobile Development Club. All rights reserved.
//

import UIKit
import CoreData

class NotificationManager {
    
    class func updateNotifications() {
        // cancel all current local notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        var fetchedRequest = NSFetchRequest(entityName: "ReminderItem");
        
        var allNotifications = managedObjectContext?.executeFetchRequest(fetchedRequest, error: nil) as Array<ReminderItem>;

        // add all enabled reminders to local notifications
        for reminderItem in allNotifications {
            if (reminderItem.enabled.boolValue) {
                NSLog("Adding enabled notification: \(reminderItem.name)");
                NotificationManager.addNotification(reminderItem);
            }
        }
    }
    
    class func clearAllNotifications() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        var fetchedRequest = NSFetchRequest(entityName: "ReminderItem");
        
        var error: NSErrorPointer? = nil
        var allNotifications = managedObjectContext?.executeFetchRequest(fetchedRequest, error: error!) as Array<ReminderItem>;
        
        // remove all from core data
        for reminderItem in allNotifications {
            managedObjectContext?.deleteObject(reminderItem);
        }
        
        // remove all current local notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications();
    }
    
    class func addNotification(reminder: ReminderItem) {
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertBody = "Reminder! \(reminder.name)"
        localNotification.fireDate = reminder.date
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
}
