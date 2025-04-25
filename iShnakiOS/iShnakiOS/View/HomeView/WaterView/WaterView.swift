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
    @Environment(\.modelContext) private var Context // Access to SwiftData context

    // Query today's data
    @Query(
        filter: UserData.todayPredicate(), sort: \UserData.date, order: .reverse,  animation: .bouncy
    ) private var data: [UserData]

    // Full history of UserData
    @Query(sort: \UserData.date, order:.reverse,  animation: .bouncy) private var historyData: [UserData]

    // User's goal data
    @Query private var defaultGoals: [GoalDefaults]

    // UI State
    @State private var isTapped: Bool = false // Whether the user tapped the ring
    @State var sizeOfWaterContainer: Int = 250 // ml value of selected water container
    @State private var selectedIndex: Int = 2 // selected icon index (default: smallest)

    // Icon and values for the water buttons
    private let icons = ["drop.fill", "drop.halffull", "drop"]
    private let value = [1000, 600, 250]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // Header section
                HStack {
                    Text("Water Consumption")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Spacer()
                    Button("Reset") {
                        data.first?.amountofWater = 0
                    }
                    .accessibilityIdentifier("ResetButton")
                }
                .padding()
                
                // Icon selection + activity ring
                HStack {
                    VStack(spacing: 13) {
                        // Water amount icons (3 options)
                        ForEach(0..<3) { index in
                            Image(systemName: icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .foregroundColor(selectedIndex == index ? .blue : .gray)
                                .accessibilityIdentifier("waterIcon_\(icons[index])")
                                .onTapGesture {
                                    selectedIndex = index
                                    sizeOfWaterContainer = value[index]
                                }
                            Text(String(value[index]) + "ml")
                                .foregroundColor(selectedIndex == index ? .blue : .gray)
                        }
                    }

                    // Interactive ring to track water
                    WaterActivityRingWithButton(
                        userData: data.first ?? UserData(),
                        isTapped: $isTapped,
                        goals: defaultGoals.first ?? GoalDefaults(),
                        sizeOfWaterContainer: sizeOfWaterContainer
                    )
                    .padding()
                    .accessibilityIdentifier("WaterRing")
                }

                // Undo button
                HStack {
                    Text("Tap the BIG circle to input")
                        .foregroundStyle(.primary)
                        .padding(.leading)
                    Spacer()
                    Text("UNDO")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button {
                        // Undo last added value
                        data.first?.amountofWater = max(0, (data.first?.amountofWater ?? 0) - sizeOfWaterContainer)
                        isTapped = false
                    } label: {
                        Image(systemName: "repeat.circle.fill")
                            .foregroundStyle((isTapped) ? .blue : .gray)
                            .font(.system(size: 40))
                    }
                    .accessibilityIdentifier("UndoButton")
                    .disabled(!isTapped)
                }
                .padding(.trailing)
            }
            .padding()
            
            // History Charts Section
            VStack {
                HStack {
                    Text("History")
                        .font(.title)
                    Image(systemName: "chart.bar.yaxis")
                        .foregroundStyle(.blue)
                    Spacer()
                }

                // Weekly and Monthly Bar Charts
                WaterChart7Days(data: last7Days, keyPath: \.amountofWater)
                WaterChartMonth(data: lastMonth)
                
                // Trend comparisons
                WaterTrends(
                    sevenDays: last7Days,
                    thirtyDays: lastMonth,
                    goal: defaultGoals.first?.waterGoal ?? 0
                )
            }
            .padding(.horizontal)
        }
    }

    // Get the last 7 days of water data
    var last7Days: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }

    // Get the last month of water data
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
