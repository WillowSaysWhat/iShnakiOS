//
//  ActivityRingWithButton.swift
//  iShnakiOS
//
//  Created by Huw Williams on 09/04/2025.
//

import SwiftUI

struct WaterActivityRingWithButton: View {
    @Environment(\.modelContext) private var Context
    @Bindable var userData: UserData
    @Binding var isTapped: Bool
    let goals: GoalDefaults
    let sizeOfWaterContainer: Int
   
    let colour: Color = .blue
    let width: CGFloat = 50
    let image: String = "waterbottle"
    
    var body: some View {
       
        let progress = Double(userData.amountofWater) / Double(goals.waterGoal)
        
        ZStack {
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(colour)
                Text(String(userData.amountofWater) + "ml")
                    .foregroundStyle((goals.waterGoal == userData.amountofWater) ? .green : .secondary)
                    .font(.title3)
            }
            
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: width)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(colour, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
                .animation(.easeOut(duration: 0.3), value: progress)
           
        }
        .padding()
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                userData.amountofWater += sizeOfWaterContainer
                isTapped = true // turns on the UNDO button in water view
                try? Context.save()
                
            }
        }
    }
}

#Preview {
    WaterView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}


