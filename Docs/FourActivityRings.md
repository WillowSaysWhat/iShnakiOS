# Four Activity Rings

The `FourActivityRings` view provides a compact yet visually rich representation of the user's progress across four key daily health metrics: `Water`, `Beverages`, `Meals`, and `Snacks`. These are displayed using animated circular progress rings that serve both as progress indicators and navigation elements.

__Layout and Structure__
The rings are arranged in two horizontal rows of two, using two `HStacks` wrapped in a `VStack`. This layout ensures clarity and a balanced visual structure.

Each ring is wrapped in a `NavigationLink`, allowing the user to tap on any ring to go directly to the corresponding detailed view (`WaterView`, `BeverageView`, etc.) for logging and reviewing history.

---

__Data Integration__
* The view uses SwiftData queries to fetch:
  * The current day’s user data (UserData)
  * The default goal values (GoalDefaults)

* It uses SwiftUI Binding to reflect and update the actual data in real time. When a ring is tapped and data is modified in the detail view, the changes are reflected back in the rings.

__Customization__

* Each ring is color-coded for its category:
  * Blue for Water
  * Brown for Beverages
  * Yellow/Orange for Meals (adapted to light/dark mode)
  * Red for Snacks

* The ring component (`ActivityRing`) is reused with dynamic values and icons (e.g., `water bottle`, `cup`, `fork`, `carrot`), allowing consistent behavior and style across categories.



```swift
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
        order: .reverse,
        animation: .bouncy
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
                .accessibilityIdentifier("toWaterView")
                
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

```

__Purpose__
The `FourActivityRings` view offers a quick visual snapshot of the user’s daily progress and encourages engagement through tappable and animated UI elements. It balances function and aesthetics, making it easy for users to track habits and access logging screens from a single, intuitive interface.