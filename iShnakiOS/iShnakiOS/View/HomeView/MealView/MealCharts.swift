//
//  MealCharts.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI
import Charts

// MARK: - Chart for displaying 7-day meal data
struct MealChart7Days: View {
    
    var data: [UserData]                     // Array of UserData entries to chart
    let title: String = "SEVEN DAYS"         // Chart section title
    let keyPath: KeyPath<UserData, Int>      // The value to extract dynamically (e.g. calories or meals)
    var colour: Color                        // Color used for the bars
    let postfix: String                      // Unit label suffix (e.g., "kcal", " meals")
    
    var body: some View {
        ZStack {
            // Background styling for the card
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Title and total value
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                Text(String(total) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Display chart with bar marks for each entry
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Meal" + postfix, entry[keyPath: keyPath]),
                            width: 13
                        )
                        .position(by: .value("category", "Meal" + postfix))
                        .foregroundStyle(colour)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    // Show abbreviated weekdays along the X axis
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
    
    // Total value for all 7 days
    var total: Int {
        var total = 0
        for data in data {
            total += data[keyPath: keyPath]
        }
        return total
    }
}

// MARK: - Chart for displaying meal data over the last month
struct MealChartMonth: View {
    
    var data: [UserData]                     // Full month of UserData entries
    let title: String = "LAST MONTH"         // Chart title
    var colour: Color                        // Bar color
    let keyPath: KeyPath<UserData, Int>      // Dynamic path to display value
    let postfix: String                      // Suffix (e.g., " kcal", " meals", etc.)
    
    var body: some View {
        ZStack {
            // Card background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Title and total
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                // If total is very large, fallback to conversion to liters
                Text((total >= 0) ? String(total) + postfix : String(total / 1000) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Chart visualization
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water", entry[keyPath: keyPath]),
                            width: 13
                        )
                        .position(by: .value("category", "Water" + postfix))
                        .foregroundStyle(colour)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    // Day names along the bottom
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
    
    // Total value across the month
    var total: Int {
        var total = 0
        for data in data {
            total += data[keyPath: keyPath]
        }
        return total
    }
}
