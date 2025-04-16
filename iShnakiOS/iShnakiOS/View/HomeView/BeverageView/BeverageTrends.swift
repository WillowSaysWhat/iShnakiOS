//
//  BeverageTrends.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct BeverageTrends: View {
    // MARK: - Properties
    
    // Array of last 7 days of data
    var sevenDays: [UserData]
    
    // Array of last 30 days of data
    var thirtyDays: [UserData]
    
    // The user's daily goal for beverage intake (e.g. 2000 ml)
    let goal: Int
    
    // Unit suffix (e.g. "ml", "kcal") used in labels
    let postfix: String
    
    // KeyPath to determine which property of `UserData` we're measuring (e.g. amountofBeverage)
    let keyPath: KeyPath<UserData, Int>

    // MARK: - View Body
    var body: some View {
        ZStack {
            // Background color and styling
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading) {
                // Header
                Text("Trends")
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                // Weekly and Monthly trend comparison
                HStack {
                    // Chevron showing direction vs goal
                    chevron(averageOverSevenDays)
                        .foregroundStyle(.brown)
                    
                    VStack(alignment: .leading) {
                        Text("WEEKLY AVG")
                            .foregroundStyle(.brown)
                        Text(String(averageOverSevenDays) + postfix)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(.brown)
                    }
                    
                    Spacer()
                    
                    // Chevron showing direction vs goal
                    chevron(averageOverThirtyDays)
                        .foregroundStyle(.brown)
                    
                    VStack(alignment: .leading) {
                        Text("MONTHLY AVG")
                            .foregroundStyle(.brown)
                        Text(String(averageOverThirtyDays) + postfix)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(.brown)
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Weekly Average Calculation
    var averageOverSevenDays: Int {
        var total = 0
        var days = 0
        for data in sevenDays {
            total += data[keyPath: keyPath]
            days += 1
        }
        return total / days
    }

    // MARK: - Monthly Average Calculation
    var averageOverThirtyDays: Int {
        var total = 0
        var days = 0
        for data in thirtyDays {
            total += data[keyPath: keyPath]
            days += 1
        }
        return total / days
    }

    // MARK: - Chevron Indicator
    /// Returns an icon indicating if the average is above or below the goal.
    func chevron(_ amountLitres: Int) -> Image {
        let tempCast = goal
        
        if amountLitres >= tempCast {
            return Image(systemName:"chevron.up.circle")
        }
        
        if amountLitres < tempCast {
            return Image(systemName: "chevron.down.circle")
        }
        
        return Image(systemName: "exclamationmark.circle") // fallback
    }
}

#Preview {
    BeverageView()
}
