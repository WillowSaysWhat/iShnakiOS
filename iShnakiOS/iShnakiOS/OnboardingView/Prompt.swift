//
//  Prompt.swift
//  iShnakiOS
//
//  Created by Huw Williams on 08/04/2025.
//

import SwiftUI

struct Prompt: View {
    @Binding var goal: String
    @FocusState private var isFocused: Bool
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            TextField("Enter a number", text: $goal)
                .focused($isFocused)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .onChange(of: isFocused) {focused in
                    if focused {
                        goal = ""
                    }
                }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        
    }
}
    
    // converts int binding to a string binding for the TextField
   




#Preview {
    Prompt(goal: .init(get: { "Enter a Number" }, set: { _ in }), title: "How much water do you drink a day?")
}
