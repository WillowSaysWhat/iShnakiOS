//
//  MealActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI
import SwiftData

struct MealActivityRingWithButton: View {
        
    @Environment(\.modelContext) private var Context
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkTheme: Color {
            colourScheme == .light ? .orange : .yellow
        }
    var lightOrDarkThemeOpacity: Color {
        colourScheme == .light ? .orange.opacity(0.3) : .yellow.opacity(0.3)
    }
    
    @Bindable var userData: UserData
    @Binding var isTapped: Bool
    let goals: GoalDefaults
    let calories: Int
       
        
    let width: CGFloat = 50
    let image: String = "fork.knife"
        
    var body: some View {
           
            let progress = min(Double(userData.amountofMeal) / Double(goals.mealGoal), 1.0)
            
            ZStack {
                HStack {
                    Image(systemName: image)
                        .font(.largeTitle)
                        .foregroundColor(lightOrDarkTheme)
                    VStack {
                        Text(String(userData.amountofMeal) + "/" + String(goals.mealGoal))
                        Text(String(userData.mealCalories) + "kcal")
                    }
                }
                
                Circle()
                    .stroke(lightOrDarkThemeOpacity, lineWidth: width)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(lightOrDarkTheme, style: StrokeStyle(lineWidth: width, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90))
                    .shadow(radius: 6)
                    .animation(.easeOut(duration: 0.3), value: progress)
                
               
            }
            
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.3)) {
                    userData.amountofMeal += 1
                    userData.mealCalories += calories
                    isTapped = true // turns on the UNDO button in water view
                    try? Context.save()
                }
            }
            .onDisappear {
                userData.caloriesConsumed += userData.mealCalories
                try? Context.save()
        }
    }
}

#Preview {
    MealView()
}
