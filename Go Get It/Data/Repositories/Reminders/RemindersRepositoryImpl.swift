//
//  RemindersRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 05/07/2023.
//

import Foundation

class RemindersRepositoryImpl: RemindersRepository {
    private let remindersAPI: RemindersAPI
    let dataController: DataController
    
    init(remindersAPI: RemindersAPI) {
        self.remindersAPI = remindersAPI
        self.dataController = remindersAPI.dataController
    }
    
    func createReminder(title: String, time: Date?, notifyMe: Bool = false, completed: Bool = false) {
        remindersAPI.createReminder(title: title, time: time, notifyMe: notifyMe, completed: completed)
    }
}
