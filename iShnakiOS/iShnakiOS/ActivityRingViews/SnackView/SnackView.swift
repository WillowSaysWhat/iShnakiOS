//
//  SnackView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct SnackView: View {
    @Environment(\.modelContext) private var Context
    // get theme (light/dark)
    
    // get data
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var data: [UserData]
    
    @Query private var defaultGoals: [GoalDefaults]
    
    @State private var isTapped: Bool = false
    @State var calories: Int = 650
    @State private var selectedIndex: Int? = 1
    
    private let icons = ["carrot.fill", "carrot", "carrot"]
    private let value = [800, 650, 450]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Meal Consumption")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "carrot")
                        .foregroundColor(.red)
                    Spacer()
                    Button("Reset") {
                        data.first?.amountofSnack = 0
                        data.first?.snackCalories = 0
                        data.first?.caloriesConsumed -= calories
                    }
                    .foregroundStyle(.red)
                    
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
                                .foregroundColor(selectedIndex == index ? .red : .gray)
                                .onTapGesture {
                                    selectedIndex = index
                                    calories = value[index]
                                }
                            Text(String(value[index])+"kcal")
                                .foregroundColor(selectedIndex == index ? .red : .gray)
                        }// ForEach Icon
                        
                        
                    }// VStack with water icons
                    
                    SnackActivityRingWithButton(userData: data.first ?? UserData(), isTapped: $isTapped, goals: defaultGoals.first ?? GoalDefaults(), calories: calories)
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
                            .foregroundStyle((isTapped) ? .red :.gray)
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
                        .foregroundStyle(.red)
                    
                    Spacer()
                }
                                
                SnackChart7Days(data: last7Days, keyPath: \.amountofSnack, colour: .red, postfix: " snacks") // at the bottom of the view
                
                SnackChartMonth(data: lastMonth, colour: .red, keyPath: \.amountofSnack, postfix: " snacks")
                SnackChart7Days(data: last7Days, keyPath: \.snackCalories, colour: .red, postfix: " kcal") // at the bottom of the view
                
                SnackChartMonth(data: lastMonth, colour: .red, keyPath: \.snackCalories, postfix: " kcal")
                
                MealTrends(sevenDays: last7Days, thirtyDays: lastMonth, goal: defaultGoals.first?.snackGoal ?? 0, colour: .red, postfix: " snacks a day", keyPath: \.amountofSnack)
                
            }// history VStack
            .padding(.horizontal)

        } // scrollview
    }// some view
    // history query
    @Query(sort: \UserData.date, order:.reverse) private var historyData: [UserData]
    
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
    SnackView()
}
