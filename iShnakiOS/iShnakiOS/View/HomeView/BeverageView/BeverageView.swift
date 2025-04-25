//
//  BeverageView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct BeverageView: View {
    
    // Access to the model context
    @Environment(\.modelContext) private var defaultGoalsContext
    
    // Fetch only today's UserData entry
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse,
        animation: .bouncy
    )
    private var data: [UserData]
    
    // Fetch all historical UserData entries (for charts)
    @Query(sort: \UserData.date, order:.reverse,  animation: .bouncy) private var historyData: [UserData]
    
    // Get the user's default goal settings
    @Query private var defaultGoals: [GoalDefaults]
    
    // Tracks whether the ring was tapped (used for enabling undo)
    @State private var isTapped: Bool = false
    
    // Beverage size (ml) and kcal selected by user
    @State var sizeOfBevContainer: Int = 600
    @State var sizeOfBevContainerKcal: Int = 220
    
    // Index of currently selected size (for UI highlighting)
    @State private var selectedIndexML: Int? = 0
    @State private var selectedIndexKcal: Int? = 0
    
    // Icon + value pairs for beverage ml input
    private let iconsML = ["drop.fill", "drop.halffull", "drop"]
    private let valueMl = [600, 450, 250]
    
    // Icon + value pairs for beverage kcal input
    private let iconsKcal = ["mug.fill", "mug.fill", "mug"]
    private let valueKcal = [220, 190, 124]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                // Header
                HStack {
                    Text("Beverages")
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "cup.and.heat.waves.fill")
                        .foregroundColor(.brown)
                    
                    Spacer()
                    
                    // Reset button (clears beverage and kcal values)
                    Button("Reset") {
                        data.first?.amountofBeverage = 0
                        data.first?.beverageCalories = 0
                        data.first?.caloriesConsumed -= sizeOfBevContainerKcal
                    }
                    .foregroundStyle(.brown)
                }
                .padding()
                
                // Input area
                HStack {
                    // ML options
                    VStack(spacing: 13){
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
                        }
                    }
                    
                    // Kcal options
                    VStack(spacing: 16){
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
                        }
                    }
                    
                    // Central activity ring with tap-to-log
                    BeverageActivityRingWithButton(
                        userData: data.first ?? UserData(),
                        isTapped: $isTapped,
                        goals: defaultGoals.first ?? GoalDefaults(),
                        sizeOfBevContainer: sizeOfBevContainer,
                        sizeOfBevContainerKcal: sizeOfBevContainerKcal
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
                        .foregroundStyle(.brown)
                    
                    Button {
                        // Subtracts previous entry (without going negative)
                        data.first?.amountofBeverage = max(0, (data.first?.amountofBeverage ?? 0) - sizeOfBevContainer)
                        data.first?.beverageCalories = max(0, (data.first?.amountofBeverage ?? 0) - sizeOfBevContainerKcal)
                        isTapped = false
                    } label: {
                        Image(systemName: "repeat.circle.fill")
                            .foregroundStyle((isTapped) ? .brown : .gray)
                            .font(.system(size: 40))
                    }
                    .disabled(!isTapped)
                }
                .padding(.trailing)
            }
            .padding()
            
            // MARK: - History Charts
            VStack {
                HStack {
                    Text("History")
                        .font(.title)
                    Image(systemName: "chart.bar.yaxis")
                        .foregroundStyle(.brown)
                    Spacer()
                }
                
                // Weekly + Monthly beverage (ml and kcal) charts
                BeverageChart7Days(data: last7Days, keyPath: \.amountofBeverage, postfix: "ml")
                BeverageChartMonth(data: lastMonth, keyPath: \.amountofBeverage, postfix: "L")
                BeverageChart7Days(data: last7Days, keyPath: \.beverageCalories, postfix: "kcal")
                BeverageChartMonth(data: lastMonth, keyPath: \.beverageCalories, postfix: "kcal")
                
                // Weekly + Monthly average vs goal
                BeverageTrends(
                    sevenDays: last7Days,
                    thirtyDays: lastMonth,
                    goal: data.first?.beverageCalories ?? 0,
                    postfix: "kcal",
                    keyPath: \.amountofBeverage
                )
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Filter last 7 days of history
    var last7Days: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }

    // MARK: - Filter last month of history
    var lastMonth: [UserData] {
        let cutoff = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        return historyData
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }
}

#Preview {
    BeverageView()
}
