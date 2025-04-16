//
//  ActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 09/04/2025.
//

import SwiftUI

struct WaterActivityRingWithButton: View {
    @Environment(\.modelContext) private var Context // Access to SwiftData context
    
    @Bindable var userData: UserData // Bound model for today’s water data
    @Binding var isTapped: Bool // Tracks if user tapped the ring (used for undo)
    
    let goals: GoalDefaults // Goal values for the user
    let sizeOfWaterContainer: Int // Amount of water added per tap (in ml)
   
    // Appearance constants
    let colour: Color = .blue
    let width: CGFloat = 50
    let image: String = "waterbottle"
    
    var body: some View {
        
        // Progress calculation (0.0 to 1.0)
        let progress = Double(userData.amountofWater) / Double(goals.waterGoal)
        
        ZStack {
            // Icon and water amount text
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(colour)
                
                Text(String(userData.amountofWater) + "ml")
                    .foregroundStyle((goals.waterGoal == userData.amountofWater) ? .green : .secondary)
                    .font(.title3)
            }
            
            // Background ring (full circle)
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: width)
            
            // Foreground ring (trimmed based on progress)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    colour,
                    style: StrokeStyle(lineWidth: width, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -90)) // Start at top
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress)
        }
        .padding()
        
        // Tap gesture to increment water intake
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofWater += sizeOfWaterContainer
                isTapped = true // Enables the undo button in WaterView
                try? Context.save() // Save updated data
            }
        }
    }
}

#Preview {
    WaterView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
