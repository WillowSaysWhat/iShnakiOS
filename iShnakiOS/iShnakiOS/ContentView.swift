//
//  ContentView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    
    @Query private var data: [UserData]// used to make new day if needed.
    @Query private var goals: [GoalDefaults]
    
    @State private var newItemText: String = "Home"
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                // Show main TabView
                TabView(selection: $newItemText) {
                    HomeView()
                        .tag("Home")
                        .tabItem {
                            Image(systemName: "house")
                        }
                    
                    WeekView()
                        .tag("Week")
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                        }
                }
            } else {
                // Show onboarding screen
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                
            }
        }
       
    }
   
    
    
// body
}// end

#Preview {
    ContentView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
