//
//  BeverageActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct BeverageActivityRingWithButton: View {
    @Environment(\.modelContext) private var Context
    @Bindable var userData: UserData
    @Binding var isTapped: Bool
    let goals: GoalDefaults
    let sizeOfBevContainer: Int
    let sizeOfBevContainerKcal: Int
   
    let colour: Color = .brown
    let widthOuter: CGFloat = 40
    
    let image: String = "cup.and.heat.waves.fill"
    
    var body: some View {
       
        let progress = min(Double(userData.amountofBeverage) / Double(goals.BeverageGoal), 1.0)
        
        ZStack {
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(colour)
                VStack {
                    Text(String(userData.amountofBeverage) + "ml")
                    Text(String(userData.beverageCalories) + "kcal")
                }
            }
            
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: widthOuter)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(colour, style: StrokeStyle(lineWidth: widthOuter, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress)
            
           
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofBeverage += sizeOfBevContainer
                userData.beverageCalories += sizeOfBevContainerKcal
                isTapped = true // turns on the UNDO button in water view
                try? Context.save()
            }
        }
        .onDisappear {
            // if the undo button is active then a tap has occured and amount can be saved.
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
