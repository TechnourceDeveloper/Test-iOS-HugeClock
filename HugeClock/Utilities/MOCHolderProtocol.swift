//
//  DataViewController.swift
//  HugeClock
//
//  Created by Niharika on 15/04/23.
//

import UIKit
import CoreData

protocol MOCHolderProtocol {
    var context: NSManagedObjectContext! {get set}
}
extension MOCHolderProtocol {
    mutating func setupContext(context: NSManagedObjectContext) {
        self.context = context
    }
    func moc() -> NSManagedObjectContext {
        if (self.context == nil) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
        return self.context
    }
}

class DataTableViewController : UITableViewController, MOCHolderProtocol {
    var context: NSManagedObjectContext!
}
class DataViewController : UIViewController, MOCHolderProtocol {
    var context: NSManagedObjectContext!
}
