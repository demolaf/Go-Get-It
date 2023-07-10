//
//  AuthAPI.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 09/07/2023.
//

import Foundation

class AuthAPI {
    func storeAuthData(name: String, email: String) {
        do {
            let data = try JSONEncoder().encode(AuthUserData(name: name, email: email))
            
            UserDefaults.standard.setValue(data, forKey: LocalStorageKeys.authUserData)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchAuthData() -> AuthUserData? {
        do {
            let storedData = UserDefaults.standard.data(forKey: LocalStorageKeys.authUserData)
            
            if let storedData = storedData {
                let data = try JSONDecoder().decode(AuthUserData.self, from: storedData)
                
                return data
            }
        } catch {
            debugPrint(error)
            return nil
        }
        return nil
    }
    
    func removeAllUserData() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
