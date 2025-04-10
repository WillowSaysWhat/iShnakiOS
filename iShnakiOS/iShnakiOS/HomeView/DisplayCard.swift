//
//  DisplayCard.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI

struct DisplayCard: View {
    
    let titleOfCard: String
    let goal: Int
    let image: String
    let colour: Color
    
    
    var data: Int
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack{
                HStack(alignment: .top, spacing:8){
                    VStack {
                        Text(titleOfCard)
                            .bold()
                        Text(whichStringToDisplayInGoal(titleOfCard, goal))
                    }
                    Spacer()
                    Image(systemName: image)
                        .foregroundStyle(colour)
                }
                
                Text(String(data) + "\(whichStringToDisplayInProgress(titleOfCard, goal))")
                    .font(.title)
                    .bold()
                    .foregroundStyle(goGreenWhenComplete(goal, data))
                    .padding()
                    
            }
            .padding()
        }
    }
    // displays the correct string for the current amount. (ml)
    func whichStringToDisplayInProgress(_ checkString: String, _ goal: Int = 99) -> String {
        
        if checkString == "Meals" || checkString == "Snacks" {
            return "/\(goal)"
        }
        if checkString == "Steps" {
            return ""
        }
        if checkString == "Active" {
            return " mins"
        }
        else {
            return "ml"
        }
    }
    func whichStringToDisplayInGoal(_ checkString: String, _ goal: Int) -> String {
        
        if checkString == "Water" || checkString == "Beverage" {
            return "Goal \(goal)ml"
        }
        if checkString == "Steps" {
            return "\(goal) Steps"
        }
        else {
            return ""
        }
    }
    func goGreenWhenComplete(_ goal: Int, _ data: Int ) -> Color {
        
            if goal >= data {
                return .green
            
            } else {
                return .primary
        }
    }
}


#Preview {
    DisplayCard(titleOfCard: "Water", goal: 3000, image: "waterbottle.fill", colour: .blue, data: 2000)
}
