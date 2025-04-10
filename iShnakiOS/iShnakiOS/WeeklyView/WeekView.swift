//
//  WeekView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData
struct WeekView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Button("Reset Onboarding for now?") {
            
            UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        }
        Button("save context") {
            do {
                let goals = GoalDefaults()
                print("1st obj made")
                modelContext.insert(goals)
                print("2nd obj made")
                let data = UserData()
                modelContext.insert(data)
                try modelContext.save()
                print("context saved")
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

#Preview {
    WeekView()
}
