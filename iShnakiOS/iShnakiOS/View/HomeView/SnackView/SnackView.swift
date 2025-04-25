//
//  SnackView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct SnackView: View {
    @Environment(\.modelContext) private var Context // Access to the SwiftData context

    // Query to get today's data
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var data: [UserData]

    // Full user data history sorted newest first
    @Query(sort: \UserData.date, order:.reverse,  animation: .bouncy) private var historyData: [UserData]
    
    // User-defined snack goals
    @Query private var defaultGoals: [GoalDefaults]
    
    // State for tracking if the ring was tapped
    @State private var isTapped: Bool = false
    
    // Current calorie selection and index
    @State var calories: Int = 650
    @State private var selectedIndex: Int? = 1
    
    // Options for snack calories and corresponding icons
    private let icons = ["carrot.fill", "carrot", "carrot"]
    private let value = [800, 650, 450]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // Heading
                HStack {
                    Text("Meal Consumption")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "carrot")
                        .foregroundColor(.red)
                    Spacer()
                    
                    // Reset button: resets today's snack data
                    Button("Reset") {
                        data.first?.amountofSnack = 0
                        data.first?.snackCalories = 0
                        data.first?.caloriesConsumed -= calories
                    }
                    .foregroundStyle(.red)
                }
                .padding()

                // Input icons and activity ring
                HStack {
                    VStack(spacing: 13){
                        // Snack calorie selection icons
                        ForEach(0..<3) { index in
                            Image(systemName: icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .foregroundColor(selectedIndex == index ? .red : .gray)
                                .onTapGesture {
                                    selectedIndex = index
                                    calories = value[index]
                                }
                            Text(String(value[index])+"kcal")
                                .foregroundColor(selectedIndex == index ? .red : .gray)
                        }
                    }
                    
                    // Activity Ring + Tapping logic
                    SnackActivityRingWithButton(
                        userData: data.first ?? UserData(),
                        isTapped: $isTapped,
                        goals: defaultGoals.first ?? GoalDefaults(),
                        calories: calories
                    )
                    .padding()
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
                    
                    // Undo last input
                    Button {
                        data.first?.amountofMeal = max(0, (data.first?.amountofMeal ?? 0) - 1)
                        data.first?.mealCalories = max(0, (data.first?.mealCalories ?? 0) - calories)
                        isTapped = false
                    } label: {
                        Image(systemName: "repeat.circle.fill")
                            .foregroundStyle((isTapped) ? .red : .gray)
                            .font(.system(size: 40))
                    }
                    .disabled(!isTapped)
                }
                .padding(.trailing)
            }
            .padding()
            
            // MARK: - History Section
            VStack {
                HStack {
                    Text("History")
                        .font(.title)
                    Image(systemName: "chart.bar.yaxis")
                        .foregroundStyle(.red)
                    Spacer()
                }

                // Weekly + Monthly Snack Tracking
                SnackChart7Days(data: last7Days, keyPath: \.amountofSnack, colour: .red, postfix: " snacks")
                SnackChartMonth(data: lastMonth, colour: .red, keyPath: \.amountofSnack, postfix: " snacks")
                
                // Weekly + Monthly Snack Calories
                SnackChart7Days(data: last7Days, keyPath: \.snackCalories, colour: .red, postfix: " kcal")
                SnackChartMonth(data: lastMonth, colour: .red, keyPath: \.snackCalories, postfix: " kcal")
                
                // Trend arrows and average values
                MealTrends(
                    sevenDays: last7Days,
                    thirtyDays: lastMonth,
                    goal: defaultGoals.first?.snackGoal ?? 0,
                    colour: .red,
                    postfix: " snacks a day",
                    keyPath: \.amountofSnack
                )
            }
            .padding(.horizontal)
        }
    }

    // Filter data for the past 7 days
    var last7Days: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }

    // Filter data for the past month
    var lastMonth: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }
}

#Preview {
    SnackView()
}
