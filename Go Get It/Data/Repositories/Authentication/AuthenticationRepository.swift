//
//  Authentication Repository.swift
//  Go Get It
//
//  Created by Ademola Fadumo on 19/06/2023.
//

import Foundation
import UIKit

protocol AuthenticationRepository {
    //
    func signInWithGoogle(vc: UIViewController, completion: @escaping (Bool, Error?) -> Void)
    
    //
    func signInWithApple()
    
    //
    func signInWithFacebook()
    
    //
    func signOut()
    
    //
    func getAuthUserData() -> AuthUserData?
    
    //
    func checkIfLoggedIn() -> Bool
}
