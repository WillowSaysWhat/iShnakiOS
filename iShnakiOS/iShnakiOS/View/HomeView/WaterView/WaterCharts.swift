//
//  WaterCharts.swift
//  iShnakiOS
//
//  Created by Huw Williams on 10/04/2025.
//

import SwiftUI
import Charts

// MARK: - Chart View for showing water data over the last 7 days
struct WaterChart7Days: View {
    
    var data: [UserData] // Array of daily UserData
    let title: String = "SEVEN DAYS" // Title for the chart
    let keyPath: KeyPath<UserData, Int> // Dynamic property to chart
    var colour: Color = .blue // Color of text and indicators
    
    var body: some View {
        ZStack {
            // Background card
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Chart title
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                // Total water (converted from ml to L)
                Text(String((total / 1000)) + "L")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Bar chart for water intake per day
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water (ml)", entry[keyPath: keyPath]),
                            width: 13
                        )
                        .position(by: .value("category", "Water (ml)"))
                        .foregroundStyle(.primary)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    // Custom X-axis labels (Mon, Tue, etc.)
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
    
    // Computes total water over the week (in ml)
    var total: Double {
        var total = 0.0
        for data in data {
            total += Double(data.amountofWater)
        }
        return total
    }
}

// MARK: - Chart View for showing water data over the last month
struct WaterChartMonth: View {
    
    var data: [UserData] // Monthly UserData history
    let title: String = "LAST MONTH" // Title of chart
    var colour: Color = .blue // Themed color for display
    
    var body: some View {
        ZStack {
            // Background container
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Chart title
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                // Total water for month in litres
                Text(String(total / 1000) + "L")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Chart of daily water totals
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water (L)", entry.amountofWater),
                            width: 13
                        )
                        .position(by: .value("category", "Water (ml)"))
                        .foregroundStyle(.primary)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    // Show weekday short format
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

    // Computes total water (in ml)
    var total: Double {
        var total = 0.0
        for data in data {
            total += Double(data.amountofWater)
        }
        return total
    }
}

#Preview {
    WaterView()
}
