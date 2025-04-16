//
//  HomeView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var healthkitManager = HealthKitManager() // HealthKit access
    
    // Theme-aware color for title accents
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkThemeForTitle: Color {
        colourScheme == .light ? .red : .green
    }
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }

    // Query for today's data
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var todayData: [UserData]
    
    // Query for user's default goals
    @Query private var defaultGoals: [GoalDefaults]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                // Title row with icon
                HStack(spacing: 2) {
                    Text ("Home")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()
                    
                    Image(systemName: "house")
                        .font(.title3)
                        .foregroundStyle(lightOrDarkThemeForTitle)
                }
                
                // Summary Data (Calories, Water, Walking)
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Calories")
                            .foregroundStyle(.red)
                        Text(String(todayData.first?.caloriesConsumed ?? 0))
                            .bold()
                        
                        Text("Water")
                            .foregroundStyle(.blue)
                        Text(String(todayData.first?.amountofWater ?? 0) + "ml")
                            .bold()
                        
                        Text("Walking")
                            .foregroundStyle(lightOrDarkThemeForYellow)
                        Text(String(healthkitManager.todayDistanceWalking / 1000) + "km")
                            .bold()
                    }
                    .padding(.leading, 10)
                    
                    // Activity Rings
                    FourActivityRings()
                }
                .padding(.bottom)

                // Grid of Display Cards (6 total)
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2)) {
                    DisplayCard(titleOfCard: "Water",
                                goal: defaultGoals.first?.waterGoal ?? 0,
                                image: "waterbottle.fill",
                                colour: .blue,
                                data: todayData.first?.amountofWater ?? 0)
                    
                    DisplayCard(titleOfCard: "Beverage",
                                goal: defaultGoals.first?.BeverageGoal ?? 0,
                                image: "cup.and.heat.waves.fill",
                                colour: .brown,
                                data: todayData.first?.amountofBeverage ?? 0)
                    
                    DisplayCard(titleOfCard: "Meals",
                                goal: defaultGoals.first?.mealGoal ?? 0,
                                image: "fork.knife",
                                colour: lightOrDarkThemeForTitle,
                                data: todayData.first?.amountofMeal ?? 0)
                    
                    DisplayCard(titleOfCard: "Snacks",
                                goal: defaultGoals.first?.snackGoal ?? 0,
                                image: "carrot",
                                colour: .red,
                                data: todayData.first?.amountofSnack ?? 0)
                    
                    DisplayCard(titleOfCard: "Steps",
                                goal: defaultGoals.first?.stepGoal ?? 0,
                                image: "figure.walk",
                                colour: .green,
                                data: healthkitManager.todayStepCount)
                    
                    DisplayCard(titleOfCard: "Stairs",
                                goal: 5,
                                image: "figure.stairs",
                                colour: .orange,
                                data: Int(healthkitManager.todayStairsCount))
                }
                .padding(10)
            } // End of VStack
        } // End of ScrollView
        .onAppear {
            isThisANewDay()
        }
    }
    
    /// Ensures a new `UserData` record is created at the start of each new day.
    func isThisANewDay() {
        let calendar = Calendar.current
        let startofToday = calendar.startOfDay(for: Date())
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startofToday)!

        let todayRecord = todayData.first {
            $0.date >= startofToday && $0.date < startOfTomorrow
        }

        if todayRecord == nil {
            print("It's a new day")
            let newRecord = UserData()
            modelContext.insert(newRecord)
        } else {
            print("Today's record Already exists")
        }
    }
}
