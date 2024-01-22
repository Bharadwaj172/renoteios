//
//  TreeFreeNoteApp.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 30/05/23.
//

import SwiftUI
import GoogleSignIn

@main
struct TreeFreeNoteApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
            //check
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        querys().create_tables()        
        return true
    }

    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
          return GIDSignIn.sharedInstance.handle(url)
    }

}

class AppSharedInstance: ObservableObject {
    static var shared = AppSharedInstance()
    @Published var selectedTab: String = ""
     
}
