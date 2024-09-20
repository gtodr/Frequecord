//
//  FrequecordApp.swift
//  Frequecord
//
//  Created by 徐德润 on 2024/9/20.
//

import SwiftUI

@main
struct FrequecordApp: App {
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
