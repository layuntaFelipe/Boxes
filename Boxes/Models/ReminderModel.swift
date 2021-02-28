//
//  ReminderModel.swift
//  Boxes
//
//  Created by Felipe Lobo on 28/02/21.
//

import Foundation
import UserNotifications

class Reminders {
    
    let center : UNUserNotificationCenter
    
    init(center: UNUserNotificationCenter) {
        self.center = UNUserNotificationCenter.current()
    }
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }
    }
    
    func createReminder(title: String, text: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Hi, I'm notification \(title)"
        content.body = "My long \(text)"
        
        print("Creating trigger")
        let date = date
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: "\(date)", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
}
