//
//  ReminderMO+Extensions.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 09/07/2023.
//

import Foundation

extension ReminderMO {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
