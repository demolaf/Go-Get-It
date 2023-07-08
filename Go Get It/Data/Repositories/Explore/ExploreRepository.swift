//
//  ExploreRepository.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import Foundation

protocol ExploreRepository {
    var exploreTableListItem: [ExploreListDataModel] { get }
    
    func fetchBodyPartsList(completion: @escaping (ExercisesBodyPartListResponse, Error?) -> Void)
    
    func fetchExercisesForBodyPart(bodyPart: String, completion: @escaping (ExerciseForBodyPartResponse, Error?) -> Void)
    
    func fetchExerciseImage(url: URL, completion: @escaping (Data?) -> Void)
}
