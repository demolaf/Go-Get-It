//
//  ActivityRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 04/07/2023.
//

import Foundation

class ActivityRepositoryImpl: ActivityRepository {
    
    var workoutActivities = [ActivityDataModel]()
    
    func createWorkoutActivity(activityTitle: String, activityType: ActivityType) -> ActivityDataModel {
        let newActivity = ActivityDataModel(activityTitle: activityTitle, activityType: activityType, programs: [ProgramDataModel]())
        
        workoutActivities.append(newActivity)
        debugPrint(newActivity)
        return newActivity
    }
    
    func createWorkoutProgram(_ activity: ActivityDataModel, title: String, programActivityType: ActivityType, sets: Int, reps: Int, restTime: TimeInterval, totalProgramTime: TimeInterval) {
        let newProgram = ProgramDataModel(programTitle: title, activityType: programActivityType, sets: sets, reps: reps, restTime: restTime, totalProgramTime: totalProgramTime)
        
        activity.programs.append(newProgram)
        debugPrint(newProgram)
    }
    
    func fetchWorkoutActivities(completed: Bool) -> [ActivityDataModel] {
        return workoutActivities.filter { activity in
            return completed ? activity.completed : !activity.completed
        }
    }
}
