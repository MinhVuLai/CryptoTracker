//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Minh Vu Lai on 7/13/24.
//

import SwiftUI


@main
struct CryptoTrackerApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(viewModel)
        }
    }
}
