//
//  GoogleAuth.swift
//  StormChaser
//
//  Created by Inderpreet Singh Bhangu on 27/07/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class GoogleAuth:NSObject {
    
    // MARK: Google SignIN Methods
    
    private func googleSignIN(viewController: UIViewController, completionHandler: @escaping (_ isSucceeded: Bool, _ data: GIDSignInResult?, _ error: String?) -> ()) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            guard let signInResult = signInResult else {
                completionHandler(false, nil, "Failed login into google account")
                return
            }
            completionHandler(true, signInResult, nil)
        }
    }
    
    // We dont use this !
    private func googleSignOUT(){
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: Firebase Auth
    func signIN(viewController: UIViewController, completionHandler: @escaping (_ isSucceeded: Bool, _ data: AuthDataResult?, _ error: String?) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        googleSignIN(viewController: viewController) { isSucceeded, data, error in
            if let error = error {
                completionHandler(false, nil, error)
            }
            if isSucceeded {
                guard let user = data?.user, let idToken = user.idToken?.tokenString else {
                    completionHandler(false, nil, "Failed to Login, ERROR: user or userIdToken mising")
                    return
                }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        completionHandler(false, nil, error.localizedDescription)
                    } else {
                        // We are Authenticated !
                        completionHandler(true, result, nil)
                    }
                }
            }
        }
    }
    
    func signOUT(completionHandler: @escaping (_ isSucceeded: Bool, _ error: String?) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completionHandler(true, nil)
        } catch let signOutError as NSError {
            completionHandler(false, "Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func isUserSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
