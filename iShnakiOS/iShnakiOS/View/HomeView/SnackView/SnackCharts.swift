//
//  SnackCharts.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI
import Charts

// MARK: - Chart for Snack Data (Past 7 Days)
struct SnackChart7Days: View {
    
    var data: [UserData] // Filtered snack data for the last 7 days
    let title: String = "SEVEN DAYS" // Chart title
    let keyPath: KeyPath<UserData, Int> // Property to chart (e.g. amountofSnack, snackCalories)
    var colour: Color // Bar color
    let postfix: String // Unit label (e.g. " kcal" or " snacks")
    
    var body: some View {
        ZStack {
            // Chart background style
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Title and total value display
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                Text(String(total) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Bar chart
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Snacks", entry[keyPath: keyPath]),
                            width: 13
                        )
                        .position(by: .value("category", "Snacks" + postfix))
                        .foregroundStyle(colour)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated)) // M, T, W...
                    }
                }
            }
            .padding()
        }
    }

    // Total value for the given data set and keyPath
    var total: Int {
        var total = 0
        for data in data {
            total += data[keyPath: keyPath]
        }
        return total
    }
}

// MARK: - Chart for Snack Data (Past Month)
struct SnackChartMonth: View {
    var data: [UserData] // Filtered snack data for the last month
    
    let title: String = "LAST MONTH"
    var colour: Color
    let keyPath: KeyPath<UserData, Int>
    let postfix: String

    var body: some View {
        ZStack {
            // Chart background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Title and total
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                Text(String(total) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Bar chart
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water" + postfix, entry[keyPath: keyPath]),
                            width: 13
                        )
                        .position(by: .value("category", "Water" + postfix))
                        .foregroundStyle(colour)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
            }
            .padding()
        }
    }

    // Total value for the given data set and keyPath
    var total: Int {
        var total = 0
        for data in data {
            total += data[keyPath: keyPath]
        }
        return total
    }
}
