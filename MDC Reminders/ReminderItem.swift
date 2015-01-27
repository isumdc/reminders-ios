//
//  ReminderItem.swift
//  MDC Reminders
//
//  Created by Nathan Karasch on 1/23/15.
//  Copyright (c) 2015 Mobile Development Club. All rights reserved.
//

import Foundation
import CoreData

class ReminderItem: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var enabled: NSNumber
    @NSManaged var name: String
    @NSManaged var repeating: NSNumber
    @NSManaged var frequency: NSNumber
    @NSManaged var stopDate: NSDate

}
