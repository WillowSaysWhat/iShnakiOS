//
//  SnackActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct SnackActivityRingWithButton: View {
    @Environment(\.modelContext) private var Context

    @Bindable var userData: UserData
    @Binding var isTapped: Bool
    let goals: GoalDefaults
    let calories: Int
   
    
    let width: CGFloat = 50
    let image: String = "carrot"
    
    var body: some View {
       
        let progress = min(Double(userData.amountofSnack) / Double(goals.snackGoal), 1.0)
        
        ZStack {
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(.red)
                VStack {
                    Text(String(userData.amountofSnack) + "/" + String(goals.snackGoal))
                    Text(String(userData.snackCalories) + "kcal")
                }
            }
            
            Circle()
                .stroke(.red.opacity(0.3), lineWidth: width)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.red, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress)
            
           
        }
        .padding()
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofSnack += 1
                userData.snackCalories += calories
                isTapped = true // turns on the UNDO button in water view
                try? Context.save()
            }
        }
        .onDisappear {
            userData.caloriesConsumed += userData.snackCalories
            try? Context.save()
    }
}
}


