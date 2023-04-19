//
//  Reminder+CoreDataProperties.swift
//  Reminders
//
// Created by Niharika on 15/04/23.


import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var done: Bool
    @NSManaged public var enabled: Bool
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}
