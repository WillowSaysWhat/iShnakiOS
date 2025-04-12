//
//  DayView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 12/04/2025.
//

import SwiftUI

struct DayView: View {
    let day: UserData
    
    var body: some View {
        ZStack {
            // background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
                .shadow(color: Color(uiColor: .systemGray6), radius: 2)
            
            VStack(alignment: .leading) {
                Text(String(day.date.formatted()))
                    .bold()
                    .font(.headline)
                
                
                    // water
                    HStack {
                        Text("Water: ")
                            .bold()
                        Text(String(day.amountofWater))
                            
                        Spacer()
                        
                        Text("Beverage: ")
                            .bold()
                        Text(String(day.amountofBeverage))
                    }
                    .padding()
                    
                    HStack {
                        Text("Meal: ")
                            .bold()
                        Text(String(day.amountofMeal))
                            
                        Spacer()
                        
                        Text("Snack: ")
                            .bold()
                        Text(String(day.amountofSnack))
                    }
                    .padding()
                    
            }
            .padding()
            
        }
        
        
        
    }
}


