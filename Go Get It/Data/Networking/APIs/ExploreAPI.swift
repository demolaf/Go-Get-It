//
//  ExploreAPI.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import Foundation

class ExploreAPI {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getBodyPartsList(completion: @escaping (ExercisesBodyPartListResponse, Error?) -> Void) -> URLSessionTask? {
        return apiClient.get(url: APIConstants.Endpoints.getBodyPartsList.url, headers: nil, response: ExercisesBodyPartListResponse.self, skipDecoding: false) { response, error in
            if let response = response as? ExercisesBodyPartListResponse {
                completion(response, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    func getExercisesForBodyPart(bodyPart: String, completion: @escaping (ExerciseForBodyPartResponse, Error?) -> Void) -> URLSessionTask? {
        return apiClient.get(url: APIConstants.Endpoints.getExercisesForBodyPart(bodyPart).url, headers: nil, response: ExerciseForBodyPartResponse.self, skipDecoding: false) { response, error in
            if let response = response as? ExerciseForBodyPartResponse {
                completion(response, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    func getExerciseImage(url: URL, completion: @escaping (Data?) -> Void) -> URLSessionTask? {
        return apiClient.get(url: url, headers: nil, response: Data.self, skipDecoding: true) { response, error in
            if let response = response as? Data {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
}
