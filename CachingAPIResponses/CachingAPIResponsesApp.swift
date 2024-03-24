//
//  CachingAPIResponsesApp.swift
//  CachingAPIResponses
//
//  Created by Etienne Grey on 3/23/24 @ 7:52 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import SwiftUI
import SwiftData

@main
struct CachingAPIResponsesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Photo.self])
        }
    }
}
