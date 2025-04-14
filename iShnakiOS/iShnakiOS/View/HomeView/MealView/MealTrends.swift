//
//  MealTrends.swift
//  iShnakiOS
//
//  Created by Huw Williams on 11/04/2025.
//

import SwiftUI

struct MealTrends: View {
    var sevenDays: [UserData]
    var thirtyDays: [UserData]
    let goal: Int
    let colour: Color
    let postfix: String
    let keyPath: KeyPath<UserData, Int>
    // filtered data is at the bottom of the view
    
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack(alignment: .leading){
                Text("Trends")
                    .font(.system(size: 12, weight: .heavy))
                    .bold()
                HStack{
                    chevron(averageOverSevenDays)
                        .foregroundStyle(colour)
                    VStack(alignment: .leading) {
                        
                        Text("WEEKLY AVG")
                            .foregroundStyle(colour)
                        Text(String(averageOverSevenDays) + postfix)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(colour)
                        
                    }
                    Spacer()
                    chevron(averageOverThirtyDays)
                        .foregroundStyle(colour)
                    VStack(alignment: .leading) {
                        Text("MONTHLY AVG")
                            .foregroundStyle(colour)
                        Text(String(averageOverThirtyDays) + postfix)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(colour)
                        
                        
                    }
                }
                .padding()
                
            }
        }
        
    }
    var averageOverSevenDays: Int {
        var total = 0
        var days = 0
        for data in sevenDays {
            total += data[keyPath: keyPath]
            days += 1
        }
        return total / days
    }
    var averageOverThirtyDays: Int {
        var total = 0
        var days = 0
        for data in thirtyDays {
            total += data[keyPath: keyPath]
            days += 1
        }
        return total / days
    }
    
    
    
    // decides whether the icon is chevron up or down.
    func chevron(_ amountLitres: Int  ) -> Image {
        let tempCast = goal
        
        if amountLitres >= tempCast {
            
            return Image(systemName:"chevron.up.circle")
        }
        if amountLitres < tempCast {
            
            return Image(systemName: "chevron.down.circle")
            
        } else {
            return Image(systemName: "exclamationmark.circle")
        }
    }
}



