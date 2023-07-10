//
//  ActivityAPI.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 09/07/2023.
//

import Foundation
import CoreData

class ActivityAPI {
    let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func createWorkoutActivity(activityTitle: String, activityType: ActivityType) -> ActivityMO {
        
        let newActivity = ActivityMO(context: dataController.viewContext)
        newActivity.title = activityTitle
        newActivity.type = Int16(activityType.rawValue)
        try? dataController.viewContext.save()
        
        debugPrint(newActivity)
        return newActivity
    }
    
    func createWorkoutProgram(_ activity: ActivityMO, title: String, programActivityType: ActivityType, sets: Int, reps: Int, restTime: TimeInterval, totalProgramTime: TimeInterval) {
        let newProgram = ProgramMO(context: dataController.viewContext)
        newProgram.title = title
        newProgram.activity = activity
        newProgram.activityType = Int16(programActivityType.rawValue)
        newProgram.sets = Int64(sets)
        newProgram.reps = Int64(reps)
        newProgram.restTime = Int64(restTime)
        newProgram.totalTime = Int64(totalProgramTime)
        try? dataController.viewContext.save()
        
        debugPrint(newProgram)
    }
}
