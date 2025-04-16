//
//  OnboardingView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 08/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    
    // Environment values
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colourScheme
    
    // Tracks onboarding completion state
    @Binding var hasCompletedOnboarding: Bool
    
    // User input values as Strings (initial text prompts)
    @State private var water: String = "Enter a Number"
    @State private var beverages: String = "Enter a Number"
    @State private var meals: String = "Enter a Number"
    @State private var snacks: String = "Enter a Number"
    @State private var calories: String = "Enter a Number"
    @State private var StepGoal: String = "Enter a Number"
    
    // Dynamic color for icons depending on light/dark mode
    var lightOrDarkTheme: Color {
        colourScheme == .light ? .red : .greenish
    }

    // Displays an error if form is not complete
    @State var errorMessage = ""

    var body: some View {
        ScrollView {
            // Title and icon
            HStack {
                Text("Set Your Goals")
                    .font(.title)
                    .foregroundColor(.primary)
                
                Image(systemName: "figure.gymnastics")
                    .font(.largeTitle)
                    .foregroundStyle(lightOrDarkTheme)
            }
            
            VStack(spacing: 10) {
                Text("take a moment to imput your daily goals.")
                    .font(.caption)
                
                // TextField prompts for each goal input
                Prompt(goal: $water, title: "Amount of water (ml) in a day?")
                Prompt(goal: $beverages, title: "Amount of beverages (ml) in a day?")
                Prompt(goal: $meals, title: "Amount of meals (3) in a day?")
                Prompt(goal: $snacks, title: "Amount of snacks (2) in a day?")
                Prompt(goal: $calories, title: "Amount of calories (kcal) in a day?")
                Prompt(goal: $StepGoal, title: "Amount of steps in a day?")
                
                // Display any input error
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.callout)
                
                // Button to save and complete onboarding
                Button("Continue") {
                    // Save to SwiftData
                    do {
                        let goals = GoalDefaults()
                        goals.waterGoal = Int(water)!
                        goals.BeverageGoal = Int(beverages)!
                        goals.mealGoal = Int(meals)!
                        goals.snackGoal = Int(snacks)!
                        goals.calorieGoal = Int(calories)!
                        goals.stepGoal = Int(StepGoal)!
                        
                        // Insert goals and user data into model
                        modelContext.insert(goals)
                        
                        let data = UserData()
                        let notifications = UserNotificationSettings()
                        modelContext.insert(data)
                        modelContext.insert(notifications)
                        
                        try modelContext.save()
                        
                        // Toggle onboarding state
                        hasCompletedOnboarding = true
                        hideKeyboard()
                        
                    } catch {
                        // Catch if any values are nil or not castable to Int
                        errorMessage = "check all your goals are entered!"
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Helper Extension to dismiss keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
