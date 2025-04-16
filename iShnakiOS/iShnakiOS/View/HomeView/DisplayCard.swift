//
//  DisplayCard.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI

/// A reusable display card showing progress toward a specific goal (e.g., Water, Meals, Steps)
struct DisplayCard: View {
    
    // MARK: - Inputs
    
    let titleOfCard: String      // Title of the card (e.g., "Water", "Snacks")
    let goal: Int                // The user's goal amount
    let image: String            // SF Symbol name for the icon
    let colour: Color            // Icon color
    var data: Int                // Current progress value
    
    // MARK: - View Body
    var body: some View {
        ZStack {
            // Card background styling
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
                .shadow(color: Color(uiColor: .systemGray4), radius: 2)
            
            // Card content
            VStack {
                // Top row: Title, goal label, and icon
                HStack(alignment: .top, spacing: 8) {
                    VStack {
                        Text(titleOfCard)
                            .bold()
                        Text(whichStringToDisplayInGoal(titleOfCard, goal)) // Dynamic goal description
                    }
                    Spacer()
                    Image(systemName: image)
                        .foregroundStyle(colour)
                }
                
                // Main value display (e.g., "2000ml", "5/3")
                Text(String(data) + "\(whichStringToDisplayInProgress(titleOfCard, goal))")
                    .font(.title)
                    .bold()
                    .foregroundStyle(goGreenWhenComplete(goal, data)) // Turn green when goal met
                    .padding()
            }
            .padding()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Returns correct unit/postfix for the progress number based on the card type
    func whichStringToDisplayInProgress(_ checkString: String, _ goal: Int = 99) -> String {
        if checkString == "Meals" || checkString == "Snacks" {
            return "/\(goal)"
        }
        if checkString == "Steps" || checkString == "Stairs" {
            return ""
        } else {
            return "ml"
        }
    }
    
    /// Returns formatted goal description string based on the card type
    func whichStringToDisplayInGoal(_ checkString: String, _ goal: Int) -> String {
        if checkString == "Water" || checkString == "Beverage" {
            return "Goal \(goal)ml"
        }
        if checkString == "Steps" {
            return "\(goal) Steps"
        } else {
            return ""
        }
    }
    
    /// Changes the color to green if the goal is achieved
    func goGreenWhenComplete(_ goal: Int, _ data: Int ) -> Color {
        if data >= goal {
            return .green
        } else {
            return .primary
        }
    }
}

#Preview {
    // Preview example with water goal and current progress
    DisplayCard(titleOfCard: "Water", goal: 3000, image: "waterbottle.fill", colour: .blue, data: 2000)
}
