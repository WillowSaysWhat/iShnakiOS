//
//  BeverageCharts.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI
import Charts

// MARK: - Seven Day Beverage Chart View
struct BeverageChart7Days: View {
    
    // Data source from SwiftData
    var data: [UserData]
    
    // Chart title
    let title: String = "SEVEN DAYS"
    
    // KeyPath allows us to dynamically pass in which property to track (e.g. amountofBeverage, beverageCalories)
    let keyPath: KeyPath<UserData, Int>
    
    // Default color used for the bars and text
    var colour: Color = .brown
    
    // Postfix to display unit (e.g. "ml", "kcal")
    let postfix: String

    // MARK: - View
    var body: some View {
        ZStack {
            // Background color and card styling
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Title
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                
                // Total value label (e.g. "3500ml")
                Text(String((total)) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Chart view
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Bev", entry[keyPath: keyPath]), width: 13
                        )
                        .position(by: .value("category", "Bev" + postfix))
                        .foregroundStyle(.brown)
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

    // MARK: - Total value calculator
    var total: Int {
        var total = 0
        for data in data {
            total += data[keyPath: keyPath]
        }
        return total
    }
}

// MARK: - Monthly Beverage Chart View
struct BeverageChartMonth: View {
    // SwiftData model entries
    var data: [UserData]

    // Static title
    let title: String = "LAST MONTH"

    // Color for bars and text
    var colour: Color = .brown

    // KeyPath for dynamically accessing UserData properties
    let keyPath: KeyPath<UserData, Int>

    // Postfix string (e.g. "ml")
    let postfix: String

    // MARK: - View
    var body: some View {
        ZStack {
            // Background container
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 1) {
                // Title
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()

                // Display total (converted to liters if ml) with unit
                Text(String(total / 1000) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                // Bar chart showing daily values
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water" + postfix, entry[keyPath: keyPath]), width: 13
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

    // MARK: - Total (converted to Double to allow scaling like /1000)
    var total: Double {
        var total = 0.0
        for data in data {
            total += Double(data[keyPath: keyPath])
        }
        return total
    }
}

#Preview {
    BeverageView()
}
