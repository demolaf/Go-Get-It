//
//  RemindersAPI.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 10/07/2023.
//

import Foundation

class RemindersAPI {
    let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func createReminder(title: String, time: Date?, notifyMe: Bool = false, completed: Bool = false) {
        let newReminder = ReminderMO(context: dataController.viewContext)
        newReminder.title = title
        newReminder.time = time
        newReminder.notifyMe = notifyMe
        newReminder.completed = completed
        try? dataController.viewContext.save()
    }
}
