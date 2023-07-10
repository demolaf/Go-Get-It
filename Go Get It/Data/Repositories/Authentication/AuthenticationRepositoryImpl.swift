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
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            //TODO: Remove UserDefaults after logging in
          try firebaseAuth.signOut()
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
                
                // TODO: Save auth details and persist in-app using UserDefaults
                print("email: \(result.user.email ?? "N/A"), \(result.user.displayName ?? "")")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
    }
}
