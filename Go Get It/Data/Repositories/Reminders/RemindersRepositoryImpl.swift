//
//  RemindersRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 05/07/2023.
//

import Foundation

class RemindersRepositoryImpl: RemindersRepository {
    
    var reminders = [DailyReminderDataModel]()
    
    func createReminder(title: String, time: Date?, notifyMe: Bool = false, completed: Bool = false) {
        let newReminder = DailyReminderDataModel(reminderTitle: title, time: time, notifyMe: notifyMe, completed: completed)
        
        reminders.append(newReminder)
    }
}
