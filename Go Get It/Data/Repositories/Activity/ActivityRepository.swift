//
//  ActivityRepository.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 04/07/2023.
//

import Foundation

protocol ActivityRepository {
    var workoutActivities: [ActivityDataModel] { get }
    
    func createWorkoutActivity(activityTitle: String, activityType: ActivityType) -> ActivityDataModel
    
    func createWorkoutProgram(_ activity: ActivityDataModel, title: String, programActivityType: ActivityType, sets: Int, reps: Int, restTime: TimeInterval, totalProgramTime: TimeInterval)
    
    func fetchWorkoutActivities(completed: Bool) -> [ActivityDataModel]
}
