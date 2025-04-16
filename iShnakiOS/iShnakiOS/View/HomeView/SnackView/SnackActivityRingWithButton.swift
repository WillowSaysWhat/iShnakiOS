//
//  SnackActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct SnackActivityRingWithButton: View {
    @Environment(\.modelContext) private var Context // Access to SwiftData model context

    @Bindable var userData: UserData // Current day's user data (bindable)
    @Binding var isTapped: Bool // Flag to trigger undo functionality
    let goals: GoalDefaults // User's snack goal data
    let calories: Int // Calories added per snack

    let width: CGFloat = 50 // Ring width
    let image: String = "carrot" // Icon image name

    var body: some View {
        // Calculate progress toward snack goal
        let progress = min(Double(userData.amountofSnack) / Double(goals.snackGoal), 1.0)
        
        ZStack {
            // Snack icon + text display
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(.red)
                VStack {
                    Text(String(userData.amountofSnack) + "/" + String(goals.snackGoal))
                    Text(String(userData.snackCalories) + "kcal")
                }
            }

            // Background ring
            Circle()
                .stroke(.red.opacity(0.3), lineWidth: width)
            
            // Foreground progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.red, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress)
        }
        .padding()
        .onTapGesture {
            // When user taps ring, log snack + calories
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofSnack += 1
                userData.snackCalories += calories
                isTapped = true // Enable undo
                try? Context.save()
            }
        }
        .onDisappear {
            // When view disappears, commit snack calories to total if user tapped
            if isTapped {
                userData.caloriesConsumed += userData.snackCalories
                try? Context.save()
            }
        }
    }
}
