//
//  ExploreRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import Foundation

class ExploreRepositoryImpl: ExploreRepository {
    private let exploreAPI: ExploreAPI
    
    init(exploreAPI: ExploreAPI) {
        self.exploreAPI = exploreAPI
    }
    
    let exploreTableListItem: [ExploreListDataModel] = [
        ExploreListDataModel(image: Images.exercisesExploreListImage!, title: "Exercises", description: "Get a list of exciting exercises you could use in your routine"),
        ExploreListDataModel(image: Images.nutritionExploreListImage!, title: "Nutrition", description: "Get a list of food recipes you could use in your meal plans")
    ]
    
    func fetchBodyPartsList(completion: @escaping (ExercisesBodyPartListResponse, Error?) -> Void) {
        let _ = exploreAPI.getBodyPartsList { bodyPartList, error in
            completion(bodyPartList, error)
        }
    }
    
    func fetchExercisesForBodyPart(bodyPart: String, completion: @escaping (ExerciseForBodyPartResponse, Error?) -> Void) {
        let _ = exploreAPI.getExercisesForBodyPart(bodyPart: bodyPart) { exercisesForBodyPart, error in
            completion(exercisesForBodyPart, error)
        }
    }
    
    func fetchExerciseImage(url: URL, completion: @escaping (Data?) -> Void) {
        let _ = exploreAPI.getExerciseImage(url: url) { data in
            completion(data)
        }
    }
}
