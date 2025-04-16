//
//  BeverageActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct BeverageActivityRingWithButton: View {
    // Access the shared SwiftData model context
    @Environment(\.modelContext) private var Context

    // Bind to the specific user's data
    @Bindable var userData: UserData

    // Flag to track if the ring has been tapped (for showing undo functionality)
    @Binding var isTapped: Bool

    // Goal settings passed from parent view
    let goals: GoalDefaults

    // Size of beverage container (ml) and corresponding calories
    let sizeOfBevContainer: Int
    let sizeOfBevContainerKcal: Int

    // Ring visual configuration
    let colour: Color = .brown
    let widthOuter: CGFloat = 40
    let image: String = "cup.and.heat.waves.fill"

    var body: some View {
        // Calculate progress as a fraction of the goal
        let progress = min(Double(userData.amountofBeverage) / Double(goals.BeverageGoal), 1.0)

        ZStack {
            // Info inside the ring (icon + beverage data)
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(colour)
                VStack {
                    Text(String(userData.amountofBeverage) + "ml")
                    Text(String(userData.beverageCalories) + "kcal")
                }
            }

            // Outer background ring
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: widthOuter)

            // Progress ring showing how close the user is to their goal
            Circle()
                .trim(from: 0, to: progress)
                .stroke(colour, style: StrokeStyle(lineWidth: widthOuter, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress)
        }

        // Handle tap: Add beverage and calories, save state, show undo
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofBeverage += sizeOfBevContainer
                userData.beverageCalories += sizeOfBevContainerKcal
                isTapped = true // Trigger undo functionality
                try? Context.save()
            }
        }

        // On leave: Update total calories if a tap occurred
        .onDisappear {
            if isTapped {
                userData.caloriesConsumed += userData.beverageCalories
                try? Context.save()
            }
        }
    }
}

#Preview {
    BeverageView()
}
