//
//  OnboardingView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 08/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colourScheme
    
    @Binding var hasCompletedOnboarding: Bool
    @State private var water: String = "Enter a Number"
    @State private var beverages: String = "Enter a Number"
    @State private var meals: String = "Enter a Number"
    @State private var snacks: String = "Enter a Number"
    @State private var calories: String = "Enter a Number"
    @State private var StepGoal: String = "Enter a Number"
    var lightOrDarkTheme: Color {
        colourScheme == .light ? .red : .greenish
    }
    @State var errorMessage = ""
    var body: some View {
        ScrollView {
            HStack {
                Text("Set Your Goals")
                    .font(.title)
                    .foregroundColor(.primary)
                
                Image(systemName: "figure.gymnastics")
                    .font(.largeTitle)
                    .foregroundStyle(lightOrDarkTheme)
                
            } // HStack at the top
            
            VStack(spacing: 10) {
                
                Text("take a moment to imput your daily goals.")
                    .font(.caption)
                
                Prompt(goal: $water, title: "Amount of water (ml) in a day?")
                Prompt(goal: $beverages, title: "Amount of beverages (ml) in a day?")
                Prompt(goal: $meals, title: "Amount of meals (3) in a day?")
                Prompt(goal: $snacks, title: "Amount of snacks (2) in a day?")
                Prompt(goal: $calories, title: "Amount of calories (kcal) in a day?")
                Prompt(goal: $StepGoal, title: "Amount of steps in a day?")
                
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.callout)
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
                        modelContext.insert(goals)
                        // saves user data and notifications
                        let data = UserData()
                        let notifications = UserNotificationSettings()
                        modelContext.insert(data)
                        modelContext.insert(notifications)
                        try modelContext.save()
                        hasCompletedOnboarding = true
                        hideKeyboard()
                    }catch {
                        errorMessage = "check all your goals are entered!"
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding(.horizontal)
            
                      
            
        }

        
        
    } // some view

} // view

// removes the 0 from the initial textfield and places something else

// the numpad will not close by default, so we have to create an extra tool for the view.
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    OnboardingView( hasCompletedOnboarding: .constant(false))
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}

