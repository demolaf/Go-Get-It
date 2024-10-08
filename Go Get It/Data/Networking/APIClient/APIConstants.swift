//
//  APIConstants.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 08/07/2023.
//

import Foundation

// Keep the endpoints
class APIConstants {
    struct Auth {
        static let rapidAPIKey = "4739d02763mshded1edffd5a964bp1d6164jsn182996e48cf6"
    }
    
    enum Endpoints {
        static let urlScheme = "https://"
        static let exercisesDBAPIHost = "exercisedb.p.rapidapi.com"
        static let exercisesDBBaseURL = "\(urlScheme)\(exercisesDBAPIHost)"
        static let rapidAPIKeyValue = "rapidapi-key=\(Auth.rapidAPIKey)"
        
        case getBodyPartsList
        case getExercisesForBodyPart(String)
        
        var stringValue: String {
            switch self {
            case .getBodyPartsList:
                return Endpoints.exercisesDBBaseURL + "/exercises/bodyPartList" + "?\(Endpoints.rapidAPIKeyValue)"
            case .getExercisesForBodyPart(let bodyPart):
                return Endpoints.exercisesDBBaseURL + "/exercises/bodyPart/\(bodyPart)" + "?\(Endpoints.rapidAPIKeyValue)"
            }
        }
        
        var url: URL? {
            // This handles converting string to URL and accepting spaces in query params
            return URL(string: stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
    }
}
