//
//  RemindersRepository.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 05/07/2023.
//

import Foundation

protocol RemindersRepository {
    func createReminder(title: String, time: Date?, notifyMe: Bool, completed: Bool)
}
