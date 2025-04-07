//
//  HomeView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // init model
    @Environment(\.modelContext) private var modelContext
    @Environment(\.modelContext) private var defaultGoalsContext
    // get data
    @Query private var data: [UserData]
    @Query private var defaultGoals: [GoalDefaults]
    
    
    // meal amount
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        Text ("Home")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .padding()
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .foregroundStyle(.red)
                                Text("210 kcal")
                                    .foregroundStyle(.white)
                                    .bold()
                                Text("Water")
                                    .foregroundStyle(.red)
                                Text("200ml")
                                    .foregroundStyle(.white)
                                    .bold()
                                Text("Steps")
                                    .foregroundStyle(.red)
                                Text("5,000")
                                    .foregroundStyle(.white)
                                    .bold()
                            } // VStack data text (cal, water, steps)
                            
                            FourActivityRings()
                                

                        }// HStack for text and activity rings
                        
                        
                    }// first VStack
                    
                } // ScrollView
               
            } // ZStack: - background and ScrollView
        } // NaviagtionStack
    }
    
}

#Preview {
    HomeView()
        .modelContainer(for: UserData.self, inMemory: true)
        .modelContainer(for: GoalDefaults.self, inMemory: true)
}
