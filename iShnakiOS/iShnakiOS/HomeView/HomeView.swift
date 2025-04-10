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
    
    // get data
    @Query private var data: [UserData]
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
                                .foregroundStyle(.red)
                            
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .foregroundStyle(.red)
                                Text("210 kcal")
                                    
                                    .bold()
                                Text("Water")
                                    .foregroundStyle(.blue)
                                Text("200ml")
                                    
                                    .bold()
                                Text("Walking")
                                    .foregroundStyle(.yellow)
                                Text("2.9km")
                                    
                                    .bold()
                            } // VStack data text (cal, water, steps)
                            .padding(.leading)
                            
                            FourActivityRings()
                                
                        }// HStack for text and activity rings
                        .padding(.bottom)
                        LazyVGrid(columns:Array(repeating: GridItem(spacing: 15), count: 2)) {
                            DisplayCard(titleOfCard: "Water",
                                        goal: existOrReturnZero(goal: defaultGoals.first?.waterGoal),
                                        image: "waterbottle.fill", colour: .blue,
                                        data: data.first?.amountofWater ?? 0)
                            
                            
                            DisplayCard(titleOfCard: "Beverage", goal: existOrReturnZero(goal: defaultGoals.first?.BeverageGoal), image: "cup.and.heat.waves.fill", colour: .brown, data: data.first?.amountofBeverage ?? 0)
                            
                            DisplayCard(titleOfCard: "Meals", goal: defaultGoals.first?.mealGoal ?? 0, image: "fork.knife", colour: .yellow, data: data.first?.amountofMeal ?? 0)
                            DisplayCard(titleOfCard: "Snacks", goal: defaultGoals.first?.snackGoal ?? 0, image: "carrot", colour: .red, data: data.first?.amountofSnack ?? 0)
                            // healthkit needs tp be implemented here *********
                            DisplayCard(titleOfCard: "Steps", goal: defaultGoals.first?.stepGoal ?? 0, image: "figure.walk", colour: .green, data: 3000) //***** fix this
                            DisplayCard(titleOfCard: "Active", goal: 0, image: "figure.cooldown", colour: .orange, data: 59)
                            
                        }
                        .padding()
                    }// first VStack
                    
                } // ScrollView
        
    }
    // used in the Display card to ensure that a record is in the DB.
    func existOrReturnZero(goal: Int?) -> Int {
        if let thisGoal = goal {
            return thisGoal
        } else {
            print("No Goal Available — using default value of 1")
            return 1
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
