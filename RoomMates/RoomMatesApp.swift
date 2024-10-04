//
//  RoomMatesApp.swift
//  RoomMates
//
//  Created by callum on 2023-11-18.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct RoomMatesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                NavigationView {
                    ContentView()
                        .environmentObject(authViewModel)
                }
            } else {
                AuthenticationView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
