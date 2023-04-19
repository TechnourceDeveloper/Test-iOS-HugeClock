//
//  ReminderTableViewController.swift
//   HugeClock
//
//  Created by Niharika on 15/04/23.
//

import CoreData
import UIKit

class RemindersTableViewController: DataTableViewController, NSFetchedResultsControllerDelegate {

    enum Sections: Int {
        case RemindersSection = 0
    }
    var reminder : Reminder?

    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let remindersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        let primarySortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        remindersFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]

        let frc = NSFetchedResultsController(
            fetchRequest: remindersFetchRequest,
            managedObjectContext: self.moc(),
            sectionNameKeyPath: nil,
            cacheName: nil)

        frc.delegate = self

        return frc
    }()
    
    func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("error at fetchedResultsController.performFetch()")
        }
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.systemOrange

        self.fetchData()
    }
    
    func presentReminderEditionView(with reminder: Reminder?) {
        let reminderEditionVC = self.storyboard?.instantiateViewController(withIdentifier: "ReminderEditionViewController") as! ReminderEditionViewController
        if let rem = reminder {
            reminderEditionVC.setReminder(reminder: rem)
        }
        let navController = UINavigationController(rootViewController: reminderEditionVC)
        self.present(navController, animated: true, completion: nil)
    }

    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let sectionobjects = self.fetchedResultsController.sections?[0].objects {
                return sectionobjects.count
            }
            return 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell")!

            let reminder = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Reminder

        
        let titleLabel = cell.viewWithTag(21) as! UILabel
        titleLabel.text = reminder.title
        
        let subtitleLabel = cell.viewWithTag(22) as! UILabel
        var subtitle = ""
        if let dueDate = reminder.dueDate {
            subtitle += (dueDate as Date).toFormattedString()
        }
        subtitleLabel.text = subtitle
        


//        let dateSwitch = cell.viewWithTag(25) as! UISwitch
//        dateSwitch.isOn = (reminder.enabled != nil)
//        dateSwitch.tag = indexPath.row
//        dateSwitch.addTarget(self, action: #selector(SwitchValueChanged(dateSwitch:)), for: .valueChanged)
//
        cell.backgroundColor = UIColor.black
        cell.textLabel?.alpha = 1.0
        cell.detailTextLabel?.alpha = 1.0
            return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let reminder = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Reminder
            reminder.done = !reminder.done
            DataHandler.saveData(onContext:self.moc())
            if (reminder.done){
                NotificationHandler.removeReminderNotification(reminder: reminder)
            }
            else {
                NotificationHandler.addNotificationFromReminder(reminder)
            }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == Sections.RemindersSection.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.section == Sections.RemindersSection.rawValue) {
            return [UITableViewRowAction.init(style: .destructive, title: "Delete", handler: editReminderAtIndexPath),
                    UITableViewRowAction.init(style: .normal, title: "Edit", handler: editReminderAtIndexPath)]
        }
        return []
    }
    
    func editReminderAtIndexPath(action :UITableViewRowAction, indexPath :IndexPath){
        let reminder = self.fetchedResultsController.object(at: fetchedResultControllerIndexPathFromTableViewIndexPath(indexPath)) as! Reminder
        if (action.style == .destructive){
            NotificationHandler.removeReminderNotification(reminder: reminder)
            DataHandler.deleteObject(reminder, onContext: self.moc(), andCommit: true)
        }
        else {
            self.presentReminderEditionView(with: reminder)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let deletedIndexPath = indexPath {
                self.tableView.deleteRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(deletedIndexPath)], with: .automatic)
            }
        case .insert:
            if let insertedIndexPath = newIndexPath {
                self.tableView.insertRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(insertedIndexPath)], with: .automatic)
            } case .move:
            if let deletedIndexPath = indexPath {
                self.tableView.deleteRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(deletedIndexPath)], with: .automatic)
            }
            if let insertedIndexPath = newIndexPath {
                self.tableView.insertRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(insertedIndexPath)], with: .automatic)
            }
        case .update:
            if let updatedIndexPath = indexPath {
                self.tableView.reloadRows(at: [tableViewIndexPathFromFetchedResultControllerIndexPath(updatedIndexPath)], with: .automatic)
            }
        default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    func tableViewIndexPathFromFetchedResultControllerIndexPath(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: Sections.RemindersSection.rawValue)
    }
    func fetchedResultControllerIndexPathFromTableViewIndexPath(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: 0)
    }
    
    
//    @objc func SwitchValueChanged(dateSwitch: UISwitch){
//        self.tableView.beginUpdates()
//        print(dateSwitch.tag)
//        if (dateSwitch.isOn){
//            reminder?.enabled = true
//        }
//        else {
//            reminder?.enabled = false
//
//        }
//        self.tableView.endUpdates()
//    }
    
}
