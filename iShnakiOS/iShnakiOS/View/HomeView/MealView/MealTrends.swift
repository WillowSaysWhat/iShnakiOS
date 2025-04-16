//
//  MealTrends.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct MealTrends: View {
    var sevenDays: [UserData] // Data for the past 7 days
    var thirtyDays: [UserData] // Data for the past 30 days
    let goal: Int // Goal value to compare averages against
    let colour: Color // Colour for UI elements
    let postfix: String // Postfix string for units (e.g., "kcal")
    let keyPath: KeyPath<UserData, Int> // Property to pull from UserData dynamically
    
    var body: some View {
        ZStack {
            // Background styling
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading) {
                // Section title
                Text("Trends")
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                HStack {
                    // Chevron for weekly average
                    chevron(averageOverSevenDays)
                        .foregroundStyle(colour)
                    
                    // Weekly average display
                    VStack(alignment: .leading) {
                        Text("WEEKLY AVG")
                            .foregroundStyle(colour)
                        Text(String(averageOverSevenDays) + postfix)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(colour)
                    }
                    
                    Spacer()
                    
                    // Chevron for monthly average
                    chevron(averageOverThirtyDays)
                        .foregroundStyle(colour)
                    
                    // Monthly average display
                    VStack(alignment: .leading) {
                        Text("MONTHLY AVG")
                            .foregroundStyle(colour)
                        Text(String(averageOverThirtyDays) + postfix)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(colour)
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Compute 7-day average
    var averageOverSevenDays: Int {
        var total = 0
        var days = 0
        for data in sevenDays {
            total += data[keyPath: keyPath]
            days += 1
        }
        return total / days
    }
    
    // MARK: - Compute 30-day average
    var averageOverThirtyDays: Int {
        var total = 0
        var days = 0
        for data in thirtyDays {
            total += data[keyPath: keyPath]
            days += 1
        }
        return total / days
    }
    
    // MARK: - Chevron indicator logic
    // Returns an upward or downward chevron based on whether the value meets or exceeds the goal
    func chevron(_ amountLitres: Int) -> Image {
        let tempCast = goal
        
        if amountLitres >= tempCast {
            return Image(systemName:"chevron.up.circle") // On track or above goal
        }
        if amountLitres < tempCast {
            return Image(systemName: "chevron.down.circle") // Below goal
        } else {
            return Image(systemName: "exclamationmark.circle") // Fallback case
        }
    }
}
