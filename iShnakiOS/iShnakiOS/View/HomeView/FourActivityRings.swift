//
//  FourActivityRings.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

/// Displays four activity rings with navigation links to their respective tracking views:
/// Water, Beverage, Meal, and Snack.
struct FourActivityRings: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.modelContext) private var defaultGoalsContext
    @Environment(\.colorScheme) private var colourScheme
    
    // Dynamically adjust yellow color depending on system appearance (light/dark)
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }

    // Query for today's user data
    @Query(
        filter: UserData.todayPredicate(),
        sort: \UserData.date,
        order: .reverse
    )
    private var data: [UserData]
    
    // Query for user's default goal settings
    @Query private var defaultGoals: [GoalDefaults]
    
    // Sizing for layout
    let paddingWidth: CGFloat = 150
    var ringWidth: CGFloat = 30

    var body: some View {
        VStack(spacing: 37) { // Vertical stack of two rows, each with 2 activity rings
            
            // Top Row: Water and Beverage
            HStack(spacing: 5) {
                
                // WATER ACTIVITY RING
                NavigationLink {
                    WaterView()
                } label: {
                    if let defaults = defaultGoals.first,
                       let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        ActivityRing(amount: Binding(
                            get: { today.amountofWater },
                            set: { today.amountofWater = $0 }
                        ), goal: defaults.waterGoal, colour: .blue, width: ringWidth, image: "waterbottle.fill")
                        .frame(width: paddingWidth)
                    } else {
                        // Fallback dummy ring
                        ActivityRing(amount: .constant(0), goal: 10, colour: .blue, width: ringWidth, image: "waterbottle.fill")
                            .frame(width: paddingWidth)
                    }
                }
                
                // BEVERAGE ACTIVITY RING
                NavigationLink {
                    BeverageView()
                } label: {
                    if let defaults = defaultGoals.first,
                       let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        ActivityRing(amount: Binding(
                            get: { today.amountofBeverage },
                            set: { today.amountofBeverage = $0 }
                        ), goal: defaults.BeverageGoal, colour: .brown, width: ringWidth, image: "cup.and.heat.waves.fill")
                        .frame(width: paddingWidth)
                    } else {
                        ActivityRing(amount: .constant(0), goal: 10, colour: .brown, width: ringWidth, image: "cup.and.heat.waves.fill")
                            .frame(width: paddingWidth)
                    }
                }
            } // End HStack (Top Row)
            
            // Bottom Row: Meal and Snack
            HStack(spacing: 5) {
                
                // MEAL ACTIVITY RING
                NavigationLink {
                    MealView()
                } label: {
                    if let defaults = defaultGoals.first,
                       let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        ActivityRing(amount: Binding(
                            get: { today.amountofMeal },
                            set: { today.amountofMeal = $0 }
                        ), goal: defaults.mealGoal, colour: lightOrDarkThemeForYellow, width: ringWidth, image: "fork.knife")
                        .frame(width: paddingWidth)
                    } else {
                        ActivityRing(amount: .constant(0), goal: 10, colour: lightOrDarkThemeForYellow, width: ringWidth, image: "fork.knife")
                            .frame(width: paddingWidth)
                    }
                }
                
                // SNACK ACTIVITY RING
                NavigationLink {
                    SnackView()
                } label: {
                    if let defaults = defaultGoals.first,
                       let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        ActivityRing(amount: Binding(
                            get: { today.amountofSnack },
                            set: { today.amountofSnack = $0 }
                        ), goal: defaults.snackGoal, colour: .red, width: ringWidth, image: "carrot")
                        .frame(width: paddingWidth)
                    } else {
                        ActivityRing(amount: .constant(0), goal: 10, colour: .red, width: ringWidth, image: "carrot")
                            .frame(width: paddingWidth)
                    }
                }
            } // End HStack (Bottom Row)
        } // End VStack
    } // End body
}

#Preview {
    // Preview for development and design inspection
    FourActivityRings()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
