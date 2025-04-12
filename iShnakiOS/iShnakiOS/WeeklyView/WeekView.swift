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
        VStack {
            Button("Reset Onboarding for now?") {
                
                UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                
            }// button
            ListOfDailyData()
        }
    }
}

#Preview {
    WeekView()
}
