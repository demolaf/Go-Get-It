//
//  AuthenticationRepositoryImpl.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 19/06/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthenticationRepositoryImpl: AuthenticationRepository {
    let authAPI: AuthAPI
    
    init(authAPI: AuthAPI) {
        self.authAPI = authAPI
    }
    
    func checkIfLoggedIn() -> Bool {
        return getAuthUserData() != nil
    }
    
    func getAuthUserData() -> AuthUserData? {
        return authAPI.fetchAuthData()
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            authAPI.removeAllUserData()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func signInWithApple() {
        print("Authenticating with Apple")
    }
    
    func signInWithFacebook() {
        print("Authenticating with Facebook")
    }
    
    func signInWithGoogle(vc: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            
            completion(false, nil)
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            
            Auth.auth().signIn(with: credential) { result, error in
                
                guard let result = result else {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                    return
                }
                
                self.authAPI.storeAuthData(name: result.user.displayName ?? "", email: result.user.email ?? "")
                print("email: \(result.user.email ?? "N/A"), \(result.user.displayName ?? "")")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
    }
}
