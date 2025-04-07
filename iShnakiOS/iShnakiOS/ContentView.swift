//
//  ContentView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var newItemText: String = "Home"
    
   

    var body: some View {
        
        TabView(selection: $newItemText) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            
            WeekView()
                .tag("Week")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
        }// tabview
    } // body
}// end

#Preview {
    ContentView()
        
}
