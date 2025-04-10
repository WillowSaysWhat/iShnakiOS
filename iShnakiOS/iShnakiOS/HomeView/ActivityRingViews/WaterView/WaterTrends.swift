//
//  WaterTrends.swift
//  iShnakiOS
//
//  Created by Huw Williams on 10/04/2025.
//

import SwiftUI

struct WaterTrends: View {
    var sevenDays: [UserData]
    var thirtyDays: [UserData]
    var goal: Int
    @State private var weekColor: Color = .gray
    @State private var monthColor: Color = .gray
    
    
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
                    colouredIcon(averageOverSevenDays)
                    VStack(alignment: .leading) {
                        
                        Text("WEEKLY AVG")
                        Text(String(averageOverSevenDays / 1000) + "L")
                            .font(.system(size: 12, weight: .heavy))
                        
                    }
                    Spacer()
                    colouredIcon(averageOverThirtyDays)
                    VStack(alignment: .leading) {
                        Text("MONTHLY AVG")
                        Text(String(averageOverThirtyDays / 1000) + "L")
                            .font(.system(size: 12, weight: .heavy))
                        
                        
                    }
                }
                .padding()
                
            }
        }
        
    }
    var averageOverSevenDays: Double {
        var total = 0.0
        var days = 0.0
        for data in sevenDays {
            total += Double(data.amountofWater)
            days += 1
        }
        return total / days
    }
    var averageOverThirtyDays: Double {
        var total = 0.0
        var days = 0.0
        for data in thirtyDays {
            total += Double(data.amountofWater)
            days += 1
        }
        return total / days
    }
    
    
   
    // decides whether the icon is chevron up or down.
    func colouredIcon(_ amountLitres: Double  ) -> Image {
        let tempCast = Double(goal)
        
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

#Preview {
    WaterView()
}
