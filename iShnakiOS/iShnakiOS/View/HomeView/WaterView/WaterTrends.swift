//
//  WaterTrends.swift
//  iShnakiOS
//
//  Created by Huw Williams on 10/04/2025.
//

import SwiftUI

struct WaterTrends: View {
    var sevenDays: [UserData] // Data for the past 7 days
    var thirtyDays: [UserData] // Data for the past 30 days
    var goal: Int // Daily water goal in ml
    
    // Not currently used, but could be leveraged for UI feedback
    @State private var weekColor: Color = .gray
    @State private var monthColor: Color = .gray
    
    var body: some View {
        ZStack {
            // Card background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading) {
                // Title
                Text("Trends")
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                HStack {
                    // Weekly average icon
                    colouredIcon(averageOverSevenDays)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("WEEKLY AVG")
                            .foregroundStyle(.blue)
                        // Weekly average converted to L
                        Text(String(Int(averageOverSevenDays / 1000)) + "L")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                    
                    // Monthly average icon
                    colouredIcon(averageOverThirtyDays)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("MONTHLY AVG")
                            .foregroundStyle(.blue)
                        // Monthly average converted to L
                        Text(String(Int(averageOverThirtyDays / 1000)) + "L")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: - Compute 7-day average water intake (in ml)
    var averageOverSevenDays: Int {
        var total = 0
        var days = 0
        for data in sevenDays {
            total += data.amountofWater
            days += 1
        }
        return total / days
    }

    // MARK: - Compute 30-day average water intake (in ml)
    var averageOverThirtyDays: Int {
        var total = 0
        var days = 0
        for data in thirtyDays {
            total += data.amountofWater
            days += 1
        }
        return total / days
    }
    
    // MARK: - Icon indicating if average meets goal
    func colouredIcon(_ amountLitres: Int) -> Image {
        let tempCast = goal
        
        if amountLitres >= tempCast {
            return Image(systemName:"chevron.up.circle")
        }
        if amountLitres < tempCast {
            return Image(systemName: "chevron.down.circle")
        } else {
            return Image(systemName: "exclamationmark.circle")
        }
    }
}

#Preview {
    WaterView()
}
