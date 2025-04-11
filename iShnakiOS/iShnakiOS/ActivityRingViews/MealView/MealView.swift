//
//  MealView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct MealView: View {
    @Environment(\.modelContext) private var Context
    // get theme (light/dark)
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkTheme: Color {
        colourScheme == .light ? .orange : .yellow
    }
    // get data
    @Query private var data: [UserData]
    @Query private var defaultGoals: [GoalDefaults]
    
    @State private var isTapped: Bool = false
    @State var calories: Int = 650
    @State private var selectedIndex: Int? = 1
    
    private let icons = ["fork.knife.circle.fill", "fork.knife.circle", "fork.knife"]
    private let value = [800, 650, 450]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Meal Consumption")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "fork.knife")
                        .foregroundColor(lightOrDarkTheme)
                    Spacer()
                    Button("Reset") {
                        data.first?.amountofMeal = 0
                        data.first?.mealCalories = 0
                    }
                    .foregroundStyle(lightOrDarkTheme)
                    
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
                                .foregroundColor(selectedIndex == index ? lightOrDarkTheme : .gray)
                                .onTapGesture {
                                    selectedIndex = index
                                    calories = value[index]
                                }
                            Text(String(value[index])+"ml")
                                .foregroundColor(selectedIndex == index ? lightOrDarkTheme : .gray)
                        }// ForEach Icon
                        
                        
                    }// VStack with water icons
                    
                    MealActivityRingWithButton(userData: data.first ?? UserData(), isTapped: $isTapped, goals: defaultGoals.first ?? GoalDefaults(), calories: calories)
                    //MealActivityRingWithButton(userData: data.first ?? UserData(), isTapped: $isTapped, goals: defaultGoals.first ?? GoalDefaults(), sizeOfWaterContainer: calories)
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
                        data.first?.amountofMeal = max(0, (data.first?.amountofMeal ?? 0) - 1) // stops the value going into the negatives.
                        data.first?.mealCalories = max(0, (data.first?.mealCalories ?? 0) - calories)

                        isTapped = false
                    }
                    label: {
                        
                            Image(systemName: "repeat.circle.fill")
                                .foregroundStyle((isTapped) ? lightOrDarkTheme :.gray)
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
                        .foregroundStyle(lightOrDarkTheme)
                    
                    Spacer()
                }
                                
                MealChart7Days(data: last7Days, keyPath: \.amountofMeal, colour: lightOrDarkTheme, postfix: " meals") // at the bottom of the view
                MealChartMonth(data: lastMonth, colour: lightOrDarkTheme, keyPath: \.amountofMeal, postfix: " meals")
                
                MealChart7Days(data: last7Days, keyPath: \.mealCalories, colour: lightOrDarkTheme, postfix: " kcal ") // at the bottom of the view
                MealChartMonth(data: lastMonth, colour: lightOrDarkTheme, keyPath: \.mealCalories, postfix: " kcal ")
                
                MealTrends(sevenDays: last7Days, thirtyDays: lastMonth, goal: defaultGoals.first?.mealGoal ?? 0, colour: lightOrDarkTheme, postfix: " meals a day", keyPath: \.amountofMeal)
                
            }// history VStack
            .padding(.horizontal)

        } // scrollview
    }// some view
    
    var last7Days: [UserData] {
            let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
            return data
                .filter { $0.date >= cutoff }
                .sorted { $0.date < $1.date }
        }
    
    
    var lastMonth: [UserData] {
            let cutoff = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date()))!
            return data
                .filter { $0.date >= cutoff }
                .sorted { $0.date < $1.date }
        }
}

#Preview {
    MealView()
}
