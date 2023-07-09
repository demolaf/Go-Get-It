//
//  ActivityRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 04/07/2023.
//

import Foundation

class ActivityRepositoryImpl: ActivityRepository {
    private let activityAPI: ActivityAPI
    let dataController: DataController
    
    init(activityAPI: ActivityAPI) {
        self.activityAPI = activityAPI
        self.dataController = activityAPI.dataController
    }
    
    func createWorkoutActivity(activityTitle: String, activityType: ActivityType) -> ActivityMO {
        return activityAPI.createWorkoutActivity(activityTitle: activityTitle, activityType: activityType)
    }
    
    func createWorkoutProgram(_ activity: ActivityMO, title: String, programActivityType: ActivityType, sets: Int, reps: Int, restTime: TimeInterval, totalProgramTime: TimeInterval) {
        activityAPI.createWorkoutProgram(activity, title: title, programActivityType: programActivityType, sets: sets, reps: reps, restTime: restTime, totalProgramTime: totalProgramTime)
    }
}
