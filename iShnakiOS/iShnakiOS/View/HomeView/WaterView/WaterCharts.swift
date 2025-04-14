//
//  WaterCharts.swift
//  iShnakiOS
//
//  Created by Huw Williams on 10/04/2025.
//

import SwiftUI

import Charts

struct WaterChart7Days: View {
    
    var data: [UserData]
    let title: String = "SEVEN DAYS"
    let keyPath: KeyPath<UserData, Int>
    var colour: Color = .blue
    
    // filtered data at the bottom of the view
    var body: some View {
        ZStack {
            // background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            // title and
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                Text(String((total / 1000)) + "L")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water (ml)", entry[keyPath: keyPath]), width: 13
                        )
                        .position(by: .value("category", "Water (ml)"))
                        .foregroundStyle(.primary)
                        
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
    
    // gets total water
    var total: Double {
        var total = 0.0
        for data in data {
            total += Double(data.amountofWater)
        }
        return total
    }

    
}

struct WaterChartMonth: View {
    var data: [UserData]
    let title: String = "LAST MONTH"
    var colour: Color = .blue
    
    // filtered data at the bottom of the view
    var body: some View {
        ZStack {
            // background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            // title and
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                Text(String(total / 1000) + "L")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water (L)", entry.amountofWater), width: 13
                        )
                        .position(by: .value("category", "Water (ml)"))
                        .foregroundStyle(.primary)
                        
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
    
  
    // gets total water
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
