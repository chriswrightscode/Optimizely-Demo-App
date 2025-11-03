//
//  Optimizely_Demo_AppApp.swift
//  Optimizely-Demo-App
//
//  Created by Christopher Wright on 11/1/25.
//

import SwiftUI

@main
struct Optimizely_Demo_AppApp: App {
    init() {
        // Pre-initialize Optimizely manager
        Task {
            await OptimizelyManager.shared.initialize()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
