//
//  DayChartsView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 13/04/2025.
//

import SwiftUI
import Charts

struct DayChartsView: View {
    // Passed-in data for the selected day
    let data: UserData
    
    // Access the current color scheme
    @Environment(\.colorScheme) private var colourScheme
    
    // Adjust yellow color for light/dark mode
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }
    
    var body: some View {
        ScrollView {
            // --- Water & Beverage Donut Chart ---
            ZStack {
                // Background styling
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 1)  {
                    // Section header
                    HStack {
                        Text("Consumption (ml)")
                            .font(.system(size: 18, weight: .heavy))
                            .bold()
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        // Display values on the left
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Water").font(.caption)
                                Text("\(data.amountofWater) ml").font(.caption)
                            }
                            HStack {
                                Text("Beverage").font(.caption)
                                Text("\(data.amountofBeverage) ml").font(.caption)
                            }
                        }
                        
                        // Donut chart for Water vs Beverage
                        Chart {
                            SectorMark(
                                angle: .value("Amount", data.amountofWater),
                                innerRadius: .ratio(0.5),
                                angularInset: 1
                            )
                            .foregroundStyle(.blue)
                            .annotation(position: .overlay) {
                                Text("Water")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                            
                            SectorMark(
                                angle: .value("Amount", data.amountofBeverage),
                                innerRadius: .ratio(0.5),
                                angularInset: 1
                            )
                            .foregroundStyle(.brown)
                            .annotation(position: .overlay) {
                                Text("Beverage")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                }
                .padding()
            } // End ZStack (Donut chart)

            // --- Water Health Info Text ---
            Text("Staying hydrated is essential for maintaining energy levels, supporting digestion, and regulating body temperature...")
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .padding()
            
            // --- Calorie Bar Chart ---
            ZStack {
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 1){
                    HStack {
                        Text("calories")
                            .font(.system(size: 18, weight: .heavy))
                            .bold()
                        Image(systemName: "fork.knife")
                            .foregroundColor(lightOrDarkThemeForYellow)
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        // Bar chart for calories from each source
                        Chart {
                            BarMark(
                                x: .value("Beverage", "beverage"),
                                y: .value("amount", data.beverageCalories),
                                width: 20
                            )
                            .foregroundStyle(.brown)
                            
                            BarMark(
                                x: .value("Meal", "meal"),
                                y: .value("amount", data.mealCalories),
                                width: 20
                            )
                            .foregroundStyle(lightOrDarkThemeForYellow)
                            
                            BarMark(
                                x: .value("Snack", "snack"),
                                y: .value("amount", data.snackCalories),
                                width: 20
                            )
                            .foregroundStyle(.red)
                        }
                    }
                }
                .padding()
            } // End ZStack (Calorie chart)

            // --- Calorie Health Info Text ---
            Text("The number of calories a person should consume daily depends on various factors such as age, gender, activity level, and overall health goals...")
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .padding()
        } // ScrollView
    }
}
