//
//  ActivityRing.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI

struct ActivityRing: View {
    @Binding var amount: Int
    
    var goal: Int
    var colour: Color
    var width: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: width)
            Circle()
                .trim(from: 0, to: CGFloat(amount) / CGFloat(goal))
                .stroke(colour, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
        }// ZStack
        .padding(.horizontal)
    }// View
}// End

#Preview {
    ActivityRing(amount: .constant(100), goal: 200, colour: .greenish, width: 30)
}
