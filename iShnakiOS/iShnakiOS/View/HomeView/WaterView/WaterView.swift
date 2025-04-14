//
//  WaterView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData
import Charts

struct WaterView: View {
    @Environment(\.modelContext) private var Context
    // get data for today only.
    
    @Query(
        filter: UserData.todayPredicate(), sort: \UserData.date, order: .reverse ) private var data: [UserData]
    
    @Query(sort: \UserData.date, order:.reverse) private var historyData: [UserData]
    @Query private var defaultGoals: [GoalDefaults]
    
    @State private var isTapped: Bool = false
    @State var sizeOfWaterContainer: Int = 250
    @State private var selectedIndex: Int = 2
    
    private let icons = ["drop.fill", "drop.halffull", "drop"]
    private let value = [1000, 600, 250]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Water Consumption")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Spacer()
                    Button("Reset") {
                        data.first?.amountofWater = 0
                    }
                    
                    
                }// HStack Heading
                .padding()
                              
                
                HStack { // Icons and activity ring
                    VStack(spacing: 13){
                        // This is the 3 water icons with tap feature
                        ForEach(0..<3) { index in
                            Image(systemName: icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .foregroundColor(selectedIndex == index ? .blue : .gray)
                                .onTapGesture {
                                    selectedIndex = index
                                    sizeOfWaterContainer = value[index]
                                }
                            Text(String(value[index])+"ml")
                                .foregroundColor(selectedIndex == index ? .blue : .gray)
                        }// ForEach Icon
                        
                        
                    }// VStack with water icons
                    
                    
                    WaterActivityRingWithButton(userData: data.first ?? UserData(), isTapped: $isTapped, goals: defaultGoals.first ?? GoalDefaults(), sizeOfWaterContainer: sizeOfWaterContainer)
                        .padding()

                     
                } // HStack Icon and Activity Ring
                
                HStack {
                    
                    Text("Tap the BIG circle to input")
                        .foregroundStyle(.primary)
                        .padding(.leading)
                    Spacer()
                    Text("UNDO")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    // undo button
                    Button {
                        data.first?.amountofWater = max(0, (data.first?.amountofWater ?? 0) - sizeOfWaterContainer) // stops the value going into the negatives.

                        isTapped = false
                    }
                    label: {
                        
                            Image(systemName: "repeat.circle.fill")
                                .foregroundStyle((isTapped) ? .blue :.gray)
                                .font(.system(size: 40))
                    }
                    .disabled(!isTapped) // disables the button
                } // undo last drink HStack
                .padding(.trailing)
            } // Top VStack
            .padding()
            
            
            VStack { // History
                HStack {
                    Text("History")
                        .font(.title)
                    Image(systemName: "chart.bar.yaxis")
                        .foregroundStyle(.blue)
                    
                    Spacer()
                }
                                
                WaterChart7Days(data: last7Days, keyPath: \.amountofWater) // at the bottom of the view
                
                WaterChartMonth(data: lastMonth)
                
                WaterTrends(sevenDays: last7Days, thirtyDays: lastMonth, goal: defaultGoals.first?.waterGoal ?? 0)
                
            }// history VStack
            .padding(.horizontal)

        } // scrollview
    }// some view
        
    // history query
    
    
    var last7Days: [UserData] {
            let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
            return historyData
                .filter { $0.date >= cutoff }
                .sorted { $0.date < $1.date }
        }
    
    
    var lastMonth: [UserData] {
            let cutoff = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date()))!
            return historyData
                .filter { $0.date >= cutoff }
                .sorted { $0.date < $1.date }
        }
} // view





#Preview {
    WaterView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
