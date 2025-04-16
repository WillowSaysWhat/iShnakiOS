//
//  ContentView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // Access the SwiftData model context
    @Environment(\.modelContext) private var modelContext
    
    // Detect current color scheme (light/dark mode)
    @Environment(\.colorScheme) private var colourScheme
    
    // Choose contrasting tint color for yellow based on light or dark mode
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .black : .white
    }
    
    // Keeps track of which tab is selected
    @State private var newItemText: String = "Home"
    
    // Check if the user has completed onboarding using AppStorage (persisted)
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                // Show main app content via TabView
                TabView(selection: $newItemText) {
                    
                    // Home tab
                    HomeView()
                        .tag("Home")
                        .tabItem {
                            Image(systemName: "house")
                        }
                    
                    // Weekly overview tab
                    WeekView()
                        .tag("Week")
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                        }
                    
                    // Profile tab
                    ProfileView()
                        .tag("Profile")
                        .tabItem {
                            Image(systemName: "person")
                        }
                }
                // Apply color tint based on theme
                .tint(lightOrDarkThemeForYellow)
            } else {
                // Show onboarding screen if user hasn't completed setup
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
    
// body
} // end
