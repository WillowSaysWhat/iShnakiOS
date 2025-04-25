# Home View

`HomeView` is the central dashboard of the iShnak iOS app. It provides a comprehensive summary of the user's daily health and nutrition data in a visually engaging and interactive layout. This view is typically the first screen the user interacts with after onboarding, offering immediate insight into progress toward daily goals.

__Key Features:__

* _Title and Theme Adaptation_
The view starts with a title ("Home") and a dynamic icon that changes color based on the current light or dark mode. This subtle touch aligns the interface with the system theme for a consistent look and feel.

* _Daily Summary_
A VStack displays key statistics including:
  * Calories Consumed
  * Water Intake (in milliliters)
  * Walking Distance (converted from meters to kilometers using HealthKit)

```swift
        // Line 53 HomeView.swift
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
```

* _Activity Rings_
The FourActivityRings component shows visual progress indicators for:
  * Water
  * Beverages
  * Meals
  * Snacks
Each ring is tappable and links to a dedicated view for detailed logging and charting. [Find out more.](/Docs/FourActivityRings.md)

```swift
    // line 73 HomeView.swift
    FourActivityRings()
        .accessibilityIdentifier("toRingView")
```

* _Display Cards Grid_
A grid of DisplayCard views offers quick overviews of all major tracked metrics including steps, stairs, and hydration, with color-coded feedback indicating whether goals have been met. [Find out more.](/Docs/DisplayCards.md)

```swift
LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2)) { // Line 79 HomeView.seift
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
} // only two cards for brev.
```

* _Daily Record Management_
On appearance, HomeView calls isThisANewDay(), which checks whether a UserData record exists for the current date. If not, it seeds a new entry, ensuring that tracking is continuous and accurate. Function is on line 126.

```swift
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
                        .accessibilityIdentifier("toRingView")
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

```

__Purpose__
The HomeView serves as the hub for daily tracking, making it easy for users to monitor their habits at a glance and encouraging consistency through visual feedback and quick navigation. It ties together hydration, calorie intake, and activity into a single, streamlined experience.