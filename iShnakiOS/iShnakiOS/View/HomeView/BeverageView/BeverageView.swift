//
//  BeverageView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct BeverageView: View {
    @Environment(\.modelContext) private var defaultGoalsContext
    // get data for today
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var data: [UserData]
    // query for history
    @Query(sort: \UserData.date, order:.reverse) private var historyData: [UserData]
    
    @Query private var defaultGoals: [GoalDefaults]
    
    @State private var isTapped: Bool = false
    @State var sizeOfBevContainer: Int = 600
    @State var sizeOfBevContainerKcal: Int = 220
    @State private var selectedIndexML: Int? = 0
    @State private var selectedIndexKcal: Int? = 0
    
    private let iconsML = ["drop.fill", "drop.halffull", "drop"]
    private let valueMl = [600, 450, 250]
    private let iconsKcal = ["mug.fill", "mug.fill", "mug"]
    private let valueKcal = [220, 190, 124]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Beverages")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "cup.and.heat.waves.fill")
                        .foregroundColor(.brown)
                    Spacer()
                    Button("Reset") {
                        data.first?.amountofBeverage = 0
                        data.first?.beverageCalories = 0
                        data.first?.caloriesConsumed -= sizeOfBevContainerKcal
                    }// title and icon
                    .foregroundStyle(.brown)
                } // HStack for title and icon
                .padding()
                
                HStack {
                    VStack(spacing: 13){
                        // This is the 3 ML icons with tap feature
                        ForEach(0..<3) { index in
                            Image(systemName: iconsML[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28)
                                .foregroundColor(selectedIndexML == index ? .brown : .gray)
                                .onTapGesture {
                                    selectedIndexML = index
                                    sizeOfBevContainer = valueMl[index]
                                }
                            Text(String(valueMl[index])+"ml")
                                .foregroundColor(selectedIndexML == index ? .brown : .gray)
                        }// ForEach Icon
                        
                        
                        
                    }// VStack with ML icons
                    VStack(spacing: 16){
                        // calories Icons
                        ForEach(0..<3) { index in
                            Image(systemName: iconsKcal[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .foregroundColor(selectedIndexKcal == index ? .brown : .gray)
                                .onTapGesture {
                                    selectedIndexKcal = index
                                    sizeOfBevContainerKcal = valueKcal[index]
                                }
                            Text(String(valueKcal[index])+"kcal")
                                .foregroundColor(selectedIndexKcal == index ? .brown : .gray)
                        }// ForEach Icon
                        
                    }// VStack with water icons
                    BeverageActivityRingWithButton(userData: data.first ?? UserData(), isTapped: $isTapped, goals: defaultGoals.first ?? GoalDefaults(), sizeOfBevContainer: sizeOfBevContainer, sizeOfBevContainerKcal: sizeOfBevContainerKcal)
                        .padding()
                } // HStack for icons and activity ring
                
                
                
                HStack { // undo button
                    Text("Tap the BIG circle to input")
                        .foregroundStyle(.primary)
                        .padding(.leading)
                    Spacer()
                    Text("UNDO")
                        .font(.subheadline)
                        .foregroundStyle(.brown)
                    // undo button
                    Button {
                        data.first?.amountofBeverage = max(0, (data.first?.amountofBeverage ?? 0) - sizeOfBevContainer) // stops the value going into the negatives.
                        data.first?.beverageCalories = max(0, (data.first?.amountofBeverage ?? 0) - sizeOfBevContainerKcal)

                        isTapped = false
                    }
                    label: {
                        
                            Image(systemName: "repeat.circle.fill")
                                .foregroundStyle((isTapped) ? .brown :.gray)
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
                        .foregroundStyle(.brown)
                    
                    Spacer()
                }
                                
                BeverageChart7Days(data: last7Days, keyPath: \.amountofBeverage, postfix: "ml") // at the bottom of the view
                
                BeverageChartMonth(data: lastMonth, keyPath: \.amountofBeverage, postfix: "L")
                
                BeverageChart7Days(data: last7Days, keyPath: \.beverageCalories, postfix: "kcal")
                
                BeverageChartMonth(data: lastMonth, keyPath: \.beverageCalories, postfix: "kcal")
                
                BeverageTrends(sevenDays: last7Days, thirtyDays: lastMonth, goal: data.first?.beverageCalories ?? 0, postfix: "kcal", keyPath: \.amountofBeverage)
                
            }// history VStack
            .padding(.horizontal)
            
            
        } // ScrollView
    } // some View
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
} // View

#Preview {
    BeverageView()
}
