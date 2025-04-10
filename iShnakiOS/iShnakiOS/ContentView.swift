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
    
    
    @Query private var data: [UserData] // used to make new day if needed.
    
    
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
                // OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
    func isThisANewDay(){
        // make timestamp for today
        let calendar = Calendar.current
        let startofToday = calendar.startOfDay(for: Date())
        // tomorrow
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startofToday)!
        // makes this a UserData type if today is present
        let todayRecord = data.first { $0.date >= startofToday && $0.date < startOfTomorrow }
        // if todayRecord is empty it adds a new record to swiftdata
        if todayRecord == nil {
            print("It's a new day")
            let newRecord = UserData()
            modelContext.insert(newRecord)
        }else {
            print("Today'record Already exists")
        }
    }
// body
}// end

#Preview {
    ContentView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
