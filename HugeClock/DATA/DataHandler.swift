//
//  DataHandler.swift
//  HugeClock
//
//  Created by Niharika on 15/04/23.
//

import Foundation
import CoreData
import UIKit
class DataHandler {
    
    static func saveData(onContext context: NSManagedObjectContext!){
        do {
            try context!.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func deleteObject(_ object: NSManagedObject, onContext context: NSManagedObjectContext!, andCommit: Bool){
        context.delete(object)
        if (andCommit){
            saveData(onContext: context)
        }
    }
    
    static func discardChanges(onContext context: NSManagedObjectContext!){
        context!.rollback()
    }
    
    static func allReminders() -> [Reminder] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return allRemindersOnContext(context)
    }
    
    static func allRemindersOnContext(_ context: NSManagedObjectContext) -> [Reminder] {
        let remindersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        do {
            let reminders = try context.fetch(remindersFetchRequest)// as! [Reminder]
            return reminders as! [Reminder]
        } catch {
            print("error at context.execute")
            return []
        }
    }
    
    
}


