//
//  MovieDemoApp.swift
//  MovieDemo
//
//  Created by Michael Long on 4/10/26.
//

import App
import SwiftUI

@main
struct MovieDemoApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
    
}
