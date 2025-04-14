//
//  ProfileView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 13/04/2025.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notificationSettings: [UserNotificationSettings]
    
    @State private var breakfastToggle: Bool = false
    @State private var lunchToggle: Bool = false
    @State private var dinnerToggle: Bool = false
    @State private var waterToggle: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack {
                ZStack {
                    Color(uiColor: .systemGray6)
                        .cornerRadius(15)
                        .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                    VStack {
                        ZStack {
                            Circle()
                                .padding()
                            Image(systemName: "heart.circle")
                                .foregroundStyle(.red)
                                .font(.largeTitle)
                        }
                        Text("Profile")
                            .font(.title)
                    }
                } // ZStack background
            }// top VStack
            .padding()
            Text("Notifications")
            
            ZStack {
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                    .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                VStack {
                    HStack {
                        
                        Text("Breakfast")
                            .foregroundStyle(.primary)
                            .bold()
                            .font(.headline)
                        Spacer()
                        Toggle("Breakfast", isOn: $breakfastToggle)
                        
                    }
                    .onAppear {
                        breakfastToggle = notificationSettings.first?.breakfastBool ?? false
                        lunchToggle = notificationSettings.first?.lunchBool ?? false
                        dinnerToggle = notificationSettings.first?.dinnerBool ?? false
                        waterToggle = notificationSettings.first?.waterReminderBool ?? false
                    }
                }
            }
            
        }
    } // some view
} //view

#Preview {
    ProfileView()
}
