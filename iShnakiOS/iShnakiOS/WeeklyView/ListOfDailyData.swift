//
//  ListOfDailyData.swift
//  iShnakiOS
//
//  Created by Huw Williams on 12/04/2025.
//

import SwiftUI
import SwiftData

struct ListOfDailyData: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserData.date, order:.reverse) private var data: [UserData]
    
    var body: some View {
        
        ScrollView {
            ForEach(data) { day in
                DayView(day: day)
            }
        }
    }
}

#Preview {
    ListOfDailyData()
}
