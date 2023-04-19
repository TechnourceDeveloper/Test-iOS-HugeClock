//
//  NotificationHandler.swift
//  HugeClock
//
//  Created by Niharika on 15/04/23.
//

import Foundation
import UserNotifications
import CoreData
import UIKit

class NotificationHandler {
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    
    static func setupNotifications(){
        
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        
        let reminders = DataHandler.allReminders()
        for reminder in reminders {
            if (reminder.done == false) {
                addNotificationFromReminder(reminder)
            }
        }
    }
    
    
    static func requestNotificationAuthorization(){
        
        let options: UNAuthorizationOptions = [.alert, .sound]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
            }
        }
    }
    
    static func addNotificationFromReminder(_ reminder: Reminder){
        
        let content = UNMutableNotificationContent()
        
        content.title = reminder.title ?? ""
        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "bell.mp3"))
        content.badge = 1
        
        if let dueDate = reminder.dueDate {
            addScheduledNotification(identifier: reminder.id!.uuidString, date: dueDate as Date, content: content)
        }
    }
    
    static func removeReminderNotification(reminder: Reminder){
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [(reminder.id?.uuidString)!])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [(reminder.id?.uuidString)!])
    }
    
    private static func addScheduledNotification(identifier: String, date: Date, content: UNMutableNotificationContent){
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
}
