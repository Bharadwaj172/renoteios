//
//  GoogleIntegration.swift
//  TreeFreeNote
//
//  Created by Vinod Kodavath on 04/09/23.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST
import SwiftUI


class GoogleAuthModel: ObservableObject {
    
    @Published var givenName: String = ""
    @Published var email: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
   
    
    init(){
//        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = givenName ?? ""
            self.profilePicUrl = profilePicUrl
            self.isLoggedIn = true
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn{ user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus()
        }
    }
    
    func signIn() {
      // 1
//      if GIDSignIn.sharedInstance().hasPreviousSignIn() {
//        GIDSignIn.sharedInstance().restorePreviousSignIn { [unowned self] user, error in
////            authenticateUser(for: user, with: error)
//        }
//      } else {
        // 2
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // 3
        
        // let configuration = GIDConfiguration(clientID: "313339963339-tkkv35so06n2qp8cuconso0rp2bagurd.apps.googleusercontent.com")

        // 4
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        // 5
          let gIdConfiguration = GIDConfiguration(clientID: "313339963339-tkkv35so06n2qp8cuconso0rp2bagurd.apps.googleusercontent.com", serverClientID: "313339963339-tkkv35so06n2qp8cuconso0rp2bagurd.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = gIdConfiguration
        GIDSignIn.sharedInstance.currentUser?.addScopes([kGTLRAuthScopeDrive], presenting: rootViewController)

          rootViewController.modalPresentationStyle = .fullScreen

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, hint: "google login", additionalScopes: [kGTLRAuthScopeDrive]) { result, error in
            
            if let user = result?.user {
                print(user)
                var gDriveUsers = NSMutableDictionary()
                
                if let userArray = AppPersistenceUtility.getObjectFromUserDefaults(key: "GoogleDriveUsers") as? Dictionary<String, Any> {
                    
                    gDriveUsers = NSMutableDictionary(dictionary: userArray)
                    
                }
                
                guard let userEmail = user.profile?.email else {
                    //TODO: Show Alert as invalid user
                    return
                }
                gDriveUsers.setValue(user, forKey: userEmail.lowercased())
                self.email = userEmail
                AppPersistenceUtility.setObjectToUserDefaults(key: "GoogleDriveUsers", dataToBeSaved: gDriveUsers)
                
            }else{
                  print(error as Any)
              }
             
          }
          
      }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}

//class GoogleIntegration{
//
//    func googleLogin(controller : UIViewController){
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().signIn(withPresenting: controller) { signInResult, error in
//            guard error == nil else { return }
//            guard let signInResult = signInResult else { return }
//
//            signInResult.user.refreshTokensIfNeeded { user, error in
//                guard error == nil else { return }
//                guard let user = user else { return }
//
//                let idToken = user.idToken
//                // Send ID token to backend (example below).
//                print("idToken ==>", idToken ?? "")
//            }
//        }
//
////        GIDSignIn.sharedInstance().signOut()
////        GIDSignIn.sharedInstance().
////        GIDSignIn.sharedInstance()()?.delegate = self
////        GIDSignIn.sharedInstance()()?.presentingViewController = self
////        GIDSignIn.sharedInstance()()?.scopes =
////            [kGTLRAuthScopeDrive]
////        GIDSignIn.sharedInstance()()?.signIn()
//    }
//
//    func tokenSignInExample(idToken: String) {
//        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
//            return
//        }
//        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
//            // Handle response from your backend.
//        }
//        task.resume()
//    }
//
//}


