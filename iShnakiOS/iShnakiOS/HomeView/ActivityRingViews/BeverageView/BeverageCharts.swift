//
//  BeverageCharts.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI
import Charts
// I'm not happy that I have not refactored this.
struct BeverageChart7Days: View {
    
    var data: [UserData]
    let title: String = "SEVEN DAYS"
    let keyPath: KeyPath<UserData, Int> // further discovery on my journey to refactoring
    var colour: Color = .brown
    let postfix: String
    
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
                Text(String((total)) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water" + postfix, entry[keyPath: keyPath]), width: 13
                        )
                        .position(by: .value("category", "Water" + postfix))
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
    
    // gets total water
    var total: Int {
        var total = 0
        for data in data {
            total += data[keyPath: keyPath]
        }
        return total
    }
}

struct BeverageChartMonth: View {
    var data: [UserData]
    
    let title: String = "LAST MONTH"
    var colour: Color = .brown
    let keyPath: KeyPath<UserData, Int>
    let postfix: String
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
                Text(String(total / 1000) + postfix)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(colour)
                
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("Day", entry.date, unit: .day),
                            y: .value("Water" + postfix, entry[keyPath: keyPath]), width: 13
                        )
                        .position(by: .value("category", "Water" + postfix))
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
    
  
    // gets total water
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
