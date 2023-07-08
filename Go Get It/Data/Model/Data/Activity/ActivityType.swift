//
//  ActivityType.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 04/07/2023.
//

import Foundation

enum ActivityType: Int {
    case upper = 0
    case arm
    case legs
    case cardio
    case yoga
    
    var info: ActivityTypeInfo {
        switch self {
        case .upper:
            return ActivityTypeInfo(name: "Upper Body", image: Images.upperBodyIcon, color: Colors.upper)
        case .arm:
            return ActivityTypeInfo(name: "Arms", image: Images.armsIcon, color: Colors.arm)
        case .legs:
            return ActivityTypeInfo(name: "Legs", image: Images.legsIcon, color: Colors.legs)
        case .cardio:
            return ActivityTypeInfo(name: "Cardio", image: Images.cardioIcon, color: Colors.cardio)
        case .yoga:
            return ActivityTypeInfo(name: "Yoga", image: Images.yogaIcon, color: Colors.yoga)
        }
    }
}
