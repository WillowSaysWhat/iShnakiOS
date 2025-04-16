//
//  Prompt.swift
//  iShnakiOS
//
//  Created by Huw Williams on 08/04/2025.
//

import SwiftUI

// A reusable view for displaying a labeled input field (used for setting goal values)
struct Prompt: View {
    
    // Binding to the string value entered by the user
    @Binding var goal: String
    
    // Focus state to determine if the text field is active
    @FocusState private var isFocused: Bool
    
    // The label/title shown above the field
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Title label
            Text(title)
                .font(.headline)
            
            // Text field for user input
            TextField("Enter a number", text: $goal)
                .focused($isFocused) // Enables programmatic focus control
                .keyboardType(.numberPad) // Number keyboard only
                .padding()
                .background(Color(.systemGray6)) // Light gray background
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .onChange(of: isFocused) { focused in
                    // Clear placeholder value when the field gains focus
                    if focused {
                        goal = ""
                    }
                }
        }
        .padding()
        .background(
            // Background card-style container
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    Prompt(
        goal: .init(get: { "Enter a Number" }, set: { _ in }),
        title: "How much water do you drink a day?"
    )
}
