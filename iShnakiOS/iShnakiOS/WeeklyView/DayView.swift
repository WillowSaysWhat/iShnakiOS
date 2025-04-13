//
//  DayView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 12/04/2025.
//

import SwiftUI

struct DayView: View {
    let day: UserData
    
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }
    
    var body: some View {
        NavigationLink {
            
            DayChartsView(data: day)
            
        } label: {
            
            ZStack {
                // background
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                    .shadow(color: Color(uiColor: .systemGray6), radius: 2)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                        Text(String(day.date.formatted(.dateTime.day().month(.wide).year())))
                            .foregroundStyle(.white)
                            .bold()
                            .font(.headline)
                    }
                    
                    
                    // water
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                        Text("Water: ")
                            .bold()
                            .foregroundStyle(.blue)
                        Text(String(day.amountofWater) + "ml")
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Image(systemName: "cup.and.heat.waves.fill")
                            .foregroundColor(.brown)
                        Text("Beverage: ")
                            .foregroundStyle(.brown)
                            .bold()
                        Text(String(day.amountofBeverage) + "ml")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(lightOrDarkThemeForYellow)
                        Text("Meal: ")
                            .foregroundStyle(lightOrDarkThemeForYellow)
                            .bold()
                        Text(String(day.amountofMeal))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Image(systemName: "carrot.fill")
                            .foregroundColor(.red)
                        Text("Snack: ")
                            .foregroundStyle(.red)
                            .bold()
                        Text(String(day.amountofSnack))
                            .foregroundStyle(.white)
                    }
                    .padding()
                    
                }
                .padding()
                
            }
            
        }
        
    }
}


