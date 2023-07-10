//
//  Environment.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 10/07/2023.
//

import Foundation

enum Environment {
    enum Keys {
        static let rapidApiKey = "RAPID_API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        
        return dict
    }()
    
    static let rapidApiKey: String = {
        guard let apiKeyString = Environment.infoDictionary[Keys.rapidApiKey] as? String else {
            fatalError("API Key not set in plist")
        }
        
        return apiKeyString
    }()
}
