//
//  FourActivityRings.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct FourActivityRings: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.modelContext) private var defaultGoalsContext
    // get data
    @Query private var data: [UserData]
    @Query private var defaultGoals: [GoalDefaults]
    let paddingWidth: CGFloat = 150
    var ringWidth: CGFloat = 30
    var body: some View {
        VStack(spacing: 37) { // Vertical alignment for all activity Rings
            
            HStack(spacing: 5) { // Horisontal alignment for top 2 rings
                
                
                    
                    //  WATER
                    NavigationLink {
                        
                        WaterView()
                        
                    } label: {
                        if let defaults = defaultGoals.first,
                           let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                            ActivityRing(amount: Binding(
                                get: { today.amountofWater},
                                set: { today.amountofWater = $0 }
                            ), goal: defaults.waterGoal , colour: .blue, width: ringWidth, image: "waterbottle.fill")
                            .frame(width: paddingWidth)
                            
                            // Text over activity ring
                            
                            
                        } else {
                            
                            ActivityRing(amount: .constant(0), goal: 10, colour: .blue, width: ringWidth, image: "waterbottle.fill")
                                .frame(width: paddingWidth)
                        }
                    }
                
                    NavigationLink {
                        
                        BeverageView()
                        
                    } label: {
                        
                        // requests both contextModels - WATER
                        if let defaults = defaultGoals.first,
                           let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                            ActivityRing(amount: Binding(
                                get: { today.amountofBeverage},
                                set: { today.amountofBeverage = $0 }
                            ), goal: defaults.BeverageGoal , colour: .brown, width: ringWidth, image: "cup.and.heat.waves.fill")
                            .frame(width: paddingWidth)
                            
                            // Text over activity ring
                            
                            
                        } else {
                            ActivityRing(amount: .constant(0), goal: 10, colour: .brown, width: ringWidth, image: "cup.and.heat.waves.fill")
                                .frame(width: paddingWidth)
                        }
                    }
                    
            } // HStack water and bev
            
            HStack(spacing: 5) {
                
                    NavigationLink {
                        
                        MealView()
                        
                    } label: {
                        // requests both contextModels - WATER
                        if let defaults = defaultGoals.first,
                           let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                            ActivityRing(amount: Binding(
                                get: { today.amountofMeal},
                                set: { today.amountofMeal = $0 }
                            ), goal: defaults.mealGoal , colour: .yellow, width: ringWidth, image: "fork.knife")
                            .frame(width: paddingWidth)
                            
                            // Text over activity ring
                            
                            
                        } else {
                            ActivityRing(amount: .constant(0), goal: 10, colour: .yellow, width: ringWidth, image: "fork.knife")
                                .frame(width: paddingWidth)
                        }
                    }
                
                    NavigationLink {
                        
                        SnackView()
                        
                    } label: {
                        
                        if let defaults = defaultGoals.first,
                           let today = data.first(where: { Calendar.current.isDateInToday($0.date) }) {
                            ActivityRing(amount: Binding(
                                get: { today.amountofSnack},
                                set: { today.amountofSnack = $0 }
                            ), goal: defaults.snackGoal , colour: .red, width: ringWidth, image: "carrot")
                            .frame(width: paddingWidth)
                            
                            // Text over activity ring
                            
                            
                        } else {
                            
                            ActivityRing(amount: .constant(0), goal: 10, colour: .red, width: ringWidth, image: "carrot")
                                .frame(width: paddingWidth)
                        }
                    }
            }
            
        }
    }
}

#Preview {
    FourActivityRings()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
