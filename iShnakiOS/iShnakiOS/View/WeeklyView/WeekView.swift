//
//  WeekView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData
struct WeekView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Text ("Summary")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .padding()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title3)
                    .foregroundStyle(.blue)
            }
            
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
