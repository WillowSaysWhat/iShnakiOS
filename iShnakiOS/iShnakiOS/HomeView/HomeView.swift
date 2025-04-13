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
    @StateObject var healthkitManager = HealthKitManager()
    // get light/dark theme
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkThemeForTitle: Color {
        colourScheme == .light ? .red : .green
    }
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }
    // get filtered data for today
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var todayData: [UserData]
    
    @Query private var defaultGoals: [GoalDefaults]
    
    
    
    // meal amount
    var body: some View {
        
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                            Text ("Home")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .padding()
                            
                            Image(systemName: "house")
                                .font(.title3)
                                .foregroundStyle(lightOrDarkThemeForTitle)
                            
                        }
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
                            } // VStack data text (cal, water, steps)
                            .padding(.leading, 10)
                            
                            FourActivityRings()
                                
                        }// HStack for text and activity rings
                        .padding(.bottom)
                        LazyVGrid(columns:Array(repeating: GridItem(spacing: 15), count: 2)) {
                            DisplayCard(titleOfCard: "Water",
                                        goal: defaultGoals.first?.waterGoal ?? 0,
                                        image: "waterbottle.fill", colour: .blue,
                                        data: todayData.first?.amountofWater ?? 0)
                            
                            
                            DisplayCard(titleOfCard: "Beverage", goal: defaultGoals.first?.BeverageGoal ?? 0, image: "cup.and.heat.waves.fill", colour: .brown, data: todayData.first?.amountofBeverage ?? 0)
                            
                            DisplayCard(titleOfCard: "Meals", goal: defaultGoals.first?.mealGoal ?? 0, image: "fork.knife", colour: lightOrDarkThemeForTitle, data: todayData.first?.amountofMeal ?? 0)
                            DisplayCard(titleOfCard: "Snacks", goal: defaultGoals.first?.snackGoal ?? 0, image: "carrot", colour: .red, data: todayData.first?.amountofSnack ?? 0)
                            
                            DisplayCard(titleOfCard: "Steps", goal: defaultGoals.first?.stepGoal ?? 0, image: "figure.walk", colour: .green, data: healthkitManager.todayStepCount)
                            DisplayCard(titleOfCard: "Stairs", goal: 5, image: "figure.stairs", colour: .orange, data: Int(healthkitManager.todayStairsCount))
                            
                        }
                        .padding()
                    }// first VStack
                    
                } // ScrollView
                .onAppear {
                    isThisANewDay()
                }
        
    }
    // used in the Display card to ensure that a record is in the DB.
    func isThisANewDay(){
        // make timestamp for today
        let calendar = Calendar.current
        let startofToday = calendar.startOfDay(for: Date())
        // tomorrow
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startofToday)!
        // makes this a UserData type if today is present
        let todayRecord = todayData.first { $0.date >= startofToday && $0.date < startOfTomorrow }
        // if todayRecord is empty it adds a new record to swiftdata
        if todayRecord == nil {
            print("It's a new day")
            let newRecord = UserData()
            modelContext.insert(newRecord)
        }else {
            print("Today's record Already exists")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
