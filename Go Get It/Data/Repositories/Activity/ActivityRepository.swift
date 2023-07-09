//
//  ActivityRepository.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 04/07/2023.
//

import Foundation

protocol ActivityRepository {
    var dataController: DataController { get }
    
    func createWorkoutActivity(activityTitle: String, activityType: ActivityType) -> ActivityMO
    
    func createWorkoutProgram(_ activity: ActivityMO, title: String, programActivityType: ActivityType, sets: Int, reps: Int, restTime: TimeInterval, totalProgramTime: TimeInterval)
}
