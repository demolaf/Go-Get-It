//
//  Reminder.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 04/07/2023.
//

import Foundation

class DailyReminderDataModel {
    let reminderTitle: String
    let time: Date?
    let notifyMe: Bool
    let completed: Bool
    
    init(reminderTitle: String, time: Date?, notifyMe: Bool, completed: Bool) {
        self.reminderTitle = reminderTitle
        self.time = time
        self.notifyMe = notifyMe
        self.completed = completed
    }
}
