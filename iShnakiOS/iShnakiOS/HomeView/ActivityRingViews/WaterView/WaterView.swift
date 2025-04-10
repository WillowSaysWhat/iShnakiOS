//
//  WaterView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

struct WaterView: View {
    @Environment(\.modelContext) private var defaultGoalsContext
    // get data
    @Query private var data: [UserData]
    @Query private var defaultGoals: [GoalDefaults]
    
    @State var sizeOfWaterContainer: Int = 1000
    @State private var selectedIndex: Int? = 0
    private let icons = ["drop.fill", "drop.halffull", "drop"]
    private let value = [1000, 600, 250]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Water Consumption")
                        .font(.title2)
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Spacer()
                    Button("Reset") {
                        data.first?.amountofWater = 0
                    }
                    .padding(.trailing, 10)
                    
                }// HStack Heading
                .padding()
                              
                
                HStack { // Icons and activity ring
                    VStack(spacing: 13){
                        // This is the 3 water icons with tap feature
                        ForEach(0..<3) { index in
                            Image(systemName: icons[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35)
                                .foregroundColor(selectedIndex == index ? .blue : .gray)
                                .onTapGesture {
                                    selectedIndex = index
                                    sizeOfWaterContainer += value[index]
                                }
                            Text(String(value[index])+"ml")
                                .foregroundColor(selectedIndex == index ? .blue : .gray)
                        }// ForEach Icon
                        
                        
                    }// VStack with water icons
                    .padding(.trailing, 15)
                    .padding(.leading, 10)
                    WaterActivityRingWithButton(userData: data.first ?? UserData(), goals: defaultGoals.first ?? GoalDefaults(), sizeOfWaterContainer: sizeOfWaterContainer)

                     
                } // HStack Icon and Activity Ring
                .padding(.trailing, 20)
                HStack {
                    
                    Text("Tap the BIG circle to input")
                        .foregroundStyle(.primary)
                        .padding(.leading)
                    Spacer()
                    
                    Button {
                        data.first?.amountofWater -= sizeOfWaterContainer
                    }label: {
                        
                        ZStack {
                            Image(systemName: "repeat.circle.fill")
                                .foregroundStyle(.blue)
                                .font(.system(size: 40))
                        } // ZStack for undo
                    }
                } // undo last drink HStack
                .padding(.trailing, 30)
                
                
            } // Top VStack
        } // scrollview
    }// some view
} // view





#Preview {
    WaterView()
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
}
