//
//  MealActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI
import SwiftData

struct MealActivityRingWithButton: View {
    
    // Access the SwiftData context to persist updates
    @Environment(\.modelContext) private var Context
    
    // Detect light or dark mode to apply appropriate color theme
    @Environment(\.colorScheme) private var colourScheme

    // Ring and icon color for light/dark mode
    var lightOrDarkTheme: Color {
        colourScheme == .light ? .orange : .yellow
    }

    // Background ring color with lower opacity
    var lightOrDarkThemeOpacity: Color {
        colourScheme == .light ? .orange.opacity(0.3) : .yellow.opacity(0.3)
    }

    // The current user's data for the day (bound to SwiftData model)
    @Bindable var userData: UserData

    // Flag to indicate a tap has occurred (used for undo functionality)
    @Binding var isTapped: Bool

    // Daily meal goal, fetched from GoalDefaults
    let goals: GoalDefaults

    // Calories added per meal tap
    let calories: Int

    // Visual configuration
    let width: CGFloat = 50
    let image: String = "fork.knife"
    
    var body: some View {
        
        // Calculate meal progress as a percentage
        let progress = min(Double(userData.amountofMeal) / Double(goals.mealGoal), 1.0)
        
        ZStack {
            // Left-side meal icon and info display
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(lightOrDarkTheme)
                
                VStack {
                    // Show current progress count and calories
                    Text(String(userData.amountofMeal) + "/" + String(goals.mealGoal))
                    Text(String(userData.mealCalories) + "kcal")
                }
            }
            
            // Outer circle ring (faint background)
            Circle()
                .stroke(lightOrDarkThemeOpacity, lineWidth: width)
            
            // Foreground progress ring (shows percentage filled)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    lightOrDarkTheme,
                    style: StrokeStyle(lineWidth: width, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -90)) // rotate so it starts at the top
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress) // animate change
        }
        .padding()
        
        // Tapping the ring adds one meal and calories
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofMeal += 1
                userData.mealCalories += calories
                isTapped = true // enable undo
                try? Context.save() // persist data
            }
        }
        
        // When view disappears, calories are finalized (only if tapped)
        .onDisappear {
            if isTapped {
                userData.caloriesConsumed += userData.mealCalories
                try? Context.save()
            }
        }
    }
}

#Preview {
    MealView()
}
