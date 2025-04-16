//
//  MealView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct MealView: View {
    @Environment(\.modelContext) private var Context // Access to SwiftData context
    @Environment(\.colorScheme) private var colourScheme // Light/dark mode

    // Adjusts the theme color based on the current appearance
    var lightOrDarkTheme: Color {
        colourScheme == .light ? .orange : .yellow
    }

    // Query: Fetch today's UserData
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var data: [UserData]

    // Query: Fetch full history of UserData (descending)
    @Query(sort: \UserData.date, order:.reverse) private var historyData: [UserData]
    
    // Query: Fetch user's default goals
    @Query private var defaultGoals: [GoalDefaults]
    
    // UI state
    @State private var isTapped: Bool = false
    @State var calories: Int = 650
    @State private var selectedIndex: Int? = 1

    // Meal size options
    private let icons = ["fork.knife.circle.fill", "fork.knife.circle", "fork.knife"]
    private let value = [800, 650, 450]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                // Header
                HStack {
                    Text("Meal Consumption")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "fork.knife")
                        .foregroundColor(lightOrDarkTheme)
                    Spacer()
                    Button("Reset") {
                        // Resets today’s meal data
                        data.first?.amountofMeal = 0
                        data.first?.mealCalories = 0
                        data.first?.caloriesConsumed -= calories
                    }
                    .foregroundStyle(lightOrDarkTheme)
                }
                .padding()
                
                // Meal selection + ring
                HStack {
                    // Icon column
                    VStack(spacing: 13) {
                        ForEach(0..<3) { index in
                            Image(systemName: icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .foregroundColor(selectedIndex == index ? lightOrDarkTheme : .gray)
                                .onTapGesture {
                                    selectedIndex = index
                                    calories = value[index]
                                }
                            Text(String(value[index]) + "kcal")
                                .foregroundColor(selectedIndex == index ? lightOrDarkTheme : .gray)
                        }
                    }
                    .padding(.trailing)
                    
                    // Ring with tap-to-log functionality
                    MealActivityRingWithButton(
                        userData: data.first ?? UserData(),
                        isTapped: $isTapped,
                        goals: defaultGoals.first ?? GoalDefaults(),
                        calories: calories
                    )
                }
                
                // Undo row
                HStack {
                    Text("Tap the BIG circle to input")
                        .foregroundStyle(.primary)
                        .padding(.leading)
                    Spacer()
                    Text("UNDO")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button {
                        // Undo last meal input
                        data.first?.amountofMeal = max(0, (data.first?.amountofMeal ?? 0) - 1)
                        data.first?.mealCalories = max(0, (data.first?.mealCalories ?? 0) - calories)
                        isTapped = false
                    } label: {
                        Image(systemName: "repeat.circle.fill")
                            .foregroundStyle(isTapped ? lightOrDarkTheme : .gray)
                            .font(.system(size: 40))
                    }
                    .disabled(!isTapped)
                }
                .padding(.trailing)
            }
            .padding()
            
            // Meal history and charts
            VStack {
                HStack {
                    Text("History")
                        .font(.title)
                    Image(systemName: "chart.bar.yaxis")
                        .foregroundStyle(lightOrDarkTheme)
                    Spacer()
                }
                
                // Weekly & Monthly charts for meals + calories
                MealChart7Days(data: last7Days, keyPath: \.amountofMeal, colour: lightOrDarkTheme, postfix: " meals")
                MealChartMonth(data: lastMonth, colour: lightOrDarkTheme, keyPath: \.amountofMeal, postfix: " meals")
                
                MealChart7Days(data: last7Days, keyPath: \.mealCalories, colour: lightOrDarkTheme, postfix: " kcal ")
                MealChartMonth(data: lastMonth, colour: lightOrDarkTheme, keyPath: \.mealCalories, postfix: " kcal ")
                
                // Trends
                MealTrends(
                    sevenDays: last7Days,
                    thirtyDays: lastMonth,
                    goal: defaultGoals.first?.mealGoal ?? 0,
                    colour: lightOrDarkTheme,
                    postfix: " meals a day",
                    keyPath: \.amountofMeal
                )
            }
            .padding(.horizontal)
        }
    }

    // Last 7 days of meal data
    var last7Days: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }

    // Last 30 days of meal data
    var lastMonth: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }
}

#Preview {
    MealView()
}
