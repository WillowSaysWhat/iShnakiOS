//
//  DayChartsView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 13/04/2025.
//

import SwiftUI
import Charts
struct DayChartsView: View {
    let data: UserData
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }
    var body: some View {
        
        ScrollView {
            ZStack {
                
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 1)  {
                    HStack {
                        
                        Text("Consumption (ml)")
                            .font(.system(size: 18, weight: .heavy))
                            .bold()
                            
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            HStack {
                                Text("Water")
                                    .font(.caption)
                                Text("\(data.amountofWater) ml")
                                    .font(.caption)
                            }
                            HStack {
                                Text("Beverage")
                                    .font(.caption)
                                Text("\(data.amountofBeverage) ml")
                                    .font(.caption)
                            }
                        }
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
            } // zstack for donut chart
           
            
            Text("Staying hydrated is essential for maintaining energy levels, supporting digestion, and regulating body temperature. On average, adults should aim to drink about 2 to 2.5 liters of water per day, though individual needs may vary depending on activity level and climate.")
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .padding()
            
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
                        Chart {
                            
                            BarMark(x: .value("Beverage", "beverage"), y:.value("amount", data.beverageCalories), width: 20)
                                .foregroundStyle(.brown)
                            BarMark(x: .value("Meal", "meal"), y: .value("amount", data.mealCalories), width: 20)
                                .foregroundStyle(lightOrDarkThemeForYellow)
                            
                            BarMark(x: .value("Snack", "snack"), y:.value("amount", data.snackCalories), width: 20)
                                .foregroundStyle(.red)
                        }
                    }
                    
                }
                .padding()
                // put padding back here
            }
            Text("The number of calories a person should consume daily depends on various factors such as age, gender, activity level, and overall health goals. On average, adult women need around 2,000 calories per day, while adult men may require about 2,500. These values can vary significantly for individuals who are more active or aiming to lose or gain weight. Maintaining a balanced intake of calories helps support energy levels, bodily functions, and long-term health.")
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }
}



