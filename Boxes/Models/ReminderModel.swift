//
//  ReminderModel.swift
//  Boxes
//
//  Created by Felipe Lobo on 28/02/21.
//

import Foundation
import UserNotifications

class Reminders {
    
    private let center : UNUserNotificationCenter
    
    init(center: UNUserNotificationCenter) {
        self.center = UNUserNotificationCenter.current()
    }
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }
    }
    
    func createReminder(title: String, text: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Hey did you do \(title) ?"
        content.body = text
        content.sound = .default
        
        print("Creating trigger")
        let date = date
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: "\(date)", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
        print("Identifier: \(request.identifier)")
    }
    
    func removeReminder(date: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [date])
        print("deleting...")
    }
}
