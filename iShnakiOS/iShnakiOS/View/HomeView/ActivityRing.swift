//
//  ActivityRing.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI

/// A reusable ring component to visually represent progress towards a goal
struct ActivityRing: View {
    // Binding to the current value (e.g., amount of water or calories)
    @Binding var amount: Int

    // The target goal (e.g., water goal or calorie goal)
    var goal: Int

    // Customizable color of the ring
    let colour: Color

    // Width of the ring stroke
    let width: CGFloat

    // System image to show in the center of the ring
    let image: String
    
    var body: some View {
        ZStack {
            // Display a system image centered inside the ring
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundColor(colour)
            
            // Background ring (static, low opacity)
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: width)
            
            // Foreground ring showing actual progress
            Circle()
                .trim(from: 0, to: CGFloat(amount) / CGFloat(goal))
                .stroke(colour, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(Angle(degrees: -90)) // Start progress from the top
                .shadow(radius: 6) // Adds depth
        }
        .padding(.horizontal)
    }
}

#Preview {
    // Preview with constant sample data
    ActivityRing(amount: .constant(100), goal: 200, colour: .greenish, width: 30, image: "plus")
}
