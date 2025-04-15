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
    @Environment(\.colorScheme) private var colourScheme
    var lightOrDarkThemeForTitle: Color {
        colourScheme == .light ? .orange : .yellow
    }
    @Query private var notificationSettings: [UserNotificationSettings]
    @Query private var goals: [GoalDefaults]
    // object wit
    
    
    @State private var breakfastToggle: Bool = false
    @State private var lunchToggle: Bool = false
    @State private var dinnerToggle: Bool = false
    @State private var waterToggle: Bool = false
    
    @State private var showNotificationSetOverlay = false
    
    var body: some View {
        ZStack { // this is the "Notification Set/removed" stack. it is at the bottom
            ScrollView {
                
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(uiColor: .systemGray6))
                            .frame(height: 120)
                            .offset(y: -60)
                            ZStack {
                                Circle()
                                    .padding()
                                    .frame(width: 120)
                                Image(systemName: "heart.circle.fill")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 100))
                            }
                            
                        }
                        
                HStack(spacing: 5) {
                    Text("Notifications")
                        .font(.largeTitle)
                        .bold()
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
                
                Text("Set your breakfast, lunch, and dinner reminder times to match your daily routine. It's a good idea to schedule them slightly earlier than when you actually plan to eat. This gives you time to prepare your meal, eat at a relaxed pace, and clean up without feeling rushed. Planning ahead ensures you stay on track with your nutrition goals and creates space in your day for a healthier, more mindful eating experience.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding()

                Spacer()
                
                ZStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Meals")
                                .font(.title)
                            Image(systemName: "fork.knife")
                                .foregroundStyle(lightOrDarkThemeForTitle)
                        }
                        if let settings = notificationSettings.first {
                            
                            // breakfast picker and toggle
                            ZStack {
                                Color(uiColor: .systemGray6)
                                    .cornerRadius(15)
                                    .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                                VStack {
                                    MealTimePicker(
                                        title: "",
                                        hour: Binding(get: { settings.breakfastHour },
                                                      set: { settings.breakfastHour = $0 }),
                                        minute: Binding(get: { settings.breakfastMin },
                                                        set: { settings.breakfastMin = $0 })
                                    )
                                    ToggleButton(title: "Breakfast", colour: lightOrDarkThemeForTitle, isOn: $breakfastToggle)
                                        .onChange(of: breakfastToggle) {
                                            settings.breakfastBool = breakfastToggle
                                            
                                            if breakfastToggle {
                                                Notifications.scheduleMealReminder(identifier: "breakfast",
                                                                                 title: "Breakfast Reminder",
                                                                                 mealHour: settings.breakfastHour,
                                                                                 mealMin: settings.breakfastMin)
                                                showWithAnimation()
                                            } else {
                                                 // removes breakfast notificactions
                                                UNUserNotificationCenter.current()
                                                    .removePendingNotificationRequests(withIdentifiers: ["breakfast"])
                                                showWithAnimation()
                                            }
                                        }
                                }
                                .padding()
                            } // breakfast ZStack
                            
                            // lunch picker and toggle
                            ZStack {
                                Color(uiColor: .systemGray6)
                                    .cornerRadius(15)
                                    .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                                VStack {
                                    MealTimePicker(
                                        title: "",
                                        hour: Binding(get: { settings.lunchHour },
                                                      set: { settings.lunchHour = $0 }),
                                        minute: Binding(get: { settings.lunchMin },
                                                        set: { settings.lunchMin = $0 })
                                    )
                                    
                                    ToggleButton(title: "Lunch", colour: lightOrDarkThemeForTitle, isOn: $lunchToggle)
                                        .onChange(of: lunchToggle) {
                                            settings.lunchBool = lunchToggle
                                            if lunchToggle {
                                                Notifications.scheduleMealReminder(identifier: "lunch",
                                                                                   title: "Lunch Reminder",
                                                                                   mealHour: settings.lunchHour,
                                                                                   mealMin: settings.lunchMin)
                                                showWithAnimation()
                                            } else {
                                                // removes breakfast notificactions
                                                UNUserNotificationCenter.current()
                                                    .removePendingNotificationRequests(withIdentifiers: ["lunch"])
                                                showWithAnimation()
                                            }
                                            
                                        }
                                }
                                .padding()
                                
                            }
                            // dinner picker and toggle
                            
                            ZStack {
                                Color(uiColor: .systemGray6)
                                    .cornerRadius(15)
                                    .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                                VStack {
                                    MealTimePicker(
                                        title: "",
                                        hour: Binding(get: { settings.dinnerHour },
                                                      set: { settings.dinnerHour = $0 }),
                                        minute: Binding(get: { settings.dinnerHour },
                                                        set: { settings.dinnerHour = $0 })
                                    )
                                    ToggleButton(title: "Dinner", colour: lightOrDarkThemeForTitle, isOn: $dinnerToggle)
                                        .onChange(of: dinnerToggle) {
                                            settings.dinnerBool = dinnerToggle
                                            if dinnerToggle {
                                                Notifications.scheduleMealReminder(identifier: "dinner",
                                                                                   title: "Dinner Reminder",
                                                                                   mealHour: settings.dinnerHour,
                                                                                   mealMin: settings.dinnerMin)
                                                showWithAnimation()
                                               
                                            } else {
                                                 // removes breakfast notificactions
                                                UNUserNotificationCenter.current()
                                                    .removePendingNotificationRequests(withIdentifiers: ["lunch"])
                                               showWithAnimation()
                                            }
                                            
                                        }
                                }
                                .padding() //
                            }
                        }
                        if let settings = notificationSettings.first {
                            VStack(alignment: .leading){
                                
                                HStack {
                                    Text("Water")
                                        .font(.title)
                                    Image(systemName: "drop")
                                        .foregroundStyle(.blue)
                                }
                                .padding()
                                
                                
                                
                                // breakfast picker and toggle
                                ZStack {
                                    Color(uiColor: .systemGray6)
                                        .cornerRadius(15)
                                        .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                                    VStack {
                                        Picker("Hour", selection: Binding(get: { settings.waterReminder },
                                                                          set: { settings.waterReminder = $0 })) {
                                            ForEach(0..<24, id: \.self) { hour in
                                                Text("\(hour)").tag(hour)
                                                
                                            }
                                        }
                                                                          .pickerStyle(.wheel)
                                                                          .frame(width: 100, height: 120)
                                        
                                        ToggleButton(title: "Water (hourly)  ", colour: lightOrDarkThemeForTitle, isOn: $waterToggle)
                                            .onChange(of: waterToggle) {
                                                settings.waterReminderBool = waterToggle
                                                
                                                if breakfastToggle {
                                                    Notifications.scheduleMealReminder(identifier: "breakfast",
                                                                                       title: "Breakfast Reminder",
                                                                                       mealHour: settings.breakfastHour,
                                                                                       mealMin: settings.breakfastMin)
                                                    showWithAnimation()
                                                } else {
                                                    // removes breakfast notificactions
                                                    UNUserNotificationCenter.current()
                                                    .removePendingNotificationRequests(withIdentifiers: ["breakfast"])
                                                    showWithAnimation()
                                                }
                                            }
                                        
                                    }
                                    .padding()
                                    
                                }
                                
                                
                                Text("Staying hydrated throughout the day is essential for maintaining energy levels, focus, and overall health. Drinking water every hour helps your body regulate temperature, support digestion, and keep your mind sharp—especially during long or busy workdays. When life gets hectic, it’s easy to forget to drink enough water. Enabling regular hydration reminders can gently prompt you to pause, take a sip, and give your body the refresh it needs to keep going strong.")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                
                                
                                HStack {
                                    Text("Goals")
                                        .font(.title)
                                    Image(systemName: "target")
                                        .foregroundStyle(.red)
                                }
                                .padding(.horizontal)
                                
                                // sets user goals.
                                if let goals = goals.first {
                                    
                                    
                                    
                                    
                                    GoalPickerCard(title: "Water Goal", unit: "ml", range: stride(from: 100, to: 7000, by: 50), icon: "drop.fill", colour: .blue, value: Binding(get: { goals.waterGoal },
                                                                                                                                                                                 set: { goals.waterGoal = $0 }),
                                                   onSave: {
                                        do {
                                            try modelContext.save()
                                            showWithAnimation() // your overlay feedback
                                        } catch {
                                            print("Failed to save water goal.")
                                        }
                                    })// end of do-catch
                                    
                                    GoalPickerCard(title: "Calorie Goal",
                                                   unit: "kcal",
                                                   range: stride(from: 100, to: 4000, by: 100), icon: "takeoutbag.and.cup.and.straw.fill", colour: .reddish,
                                                   value: Binding(get: { goals.calorieGoal },
                                                                  set: { goals.calorieGoal = $0 }),
                                                   onSave: {
                                        do {
                                            try modelContext.save()
                                            showWithAnimation()
                                        } catch {
                                            print("Failed to save calorie goal.")
                                        }
                                    })
                                    
                                    GoalPickerCard(title: "Beverage Goal",
                                                   unit: "ml",
                                                   range: stride(from: 1, to: 8, by: 1), icon: "cup.and.heat.waves.fill", colour: .brown,
                                                   value: Binding(get: { goals.BeverageGoal},
                                                                  set: { goals.BeverageGoal = $0 }),
                                                   onSave: {
                                        do {
                                            try modelContext.save()
                                            showWithAnimation()
                                        } catch {
                                            print("Failed to save Beverage goal.")
                                        }
                                    })
                                    
                                    .padding()
                                    GoalPickerCard(title: "Meal Goal",
                                                   unit: "",
                                                   range: stride(from: 1, to: 8, by: 1), icon: "fork.knife", colour: lightOrDarkThemeForTitle,
                                                   value: Binding(get: { goals.mealGoal },
                                                                  set: { goals.mealGoal = $0 }),
                                                   onSave: {
                                        do {
                                            try modelContext.save()
                                            showWithAnimation()
                                        } catch {
                                            print("Failed to save meal goal.")
                                        }
                                    })
                                    
                                    GoalPickerCard(title: "Snack Goal",
                                                   unit: "",
                                                   range: stride(from: 1, to: 8, by: 1), icon: "carrot.fill", colour: .red,
                                                   value: Binding(get: { goals.snackGoal },
                                                                  set: { goals.snackGoal = $0 }),
                                                   onSave: {
                                        do {
                                            try modelContext.save()
                                            showWithAnimation()
                                        } catch {
                                            print("Failed to save snack goal.")
                                        }
                                    })
                                }
                                
                                
        
                            }
                        }
                    } // vstack at the top of the toggle and picker panel
                    .padding()
                    .onAppear {
                        breakfastToggle = notificationSettings.first?.breakfastBool ?? true
                        lunchToggle = notificationSettings.first?.lunchBool ?? false
                        dinnerToggle = notificationSettings.first?.dinnerBool ?? false
                        waterToggle = notificationSettings.first?.waterReminderBool ?? false
                        
                        Notifications.requestNotificationPermissions()
                    }
                    .onDisappear {
                        try? modelContext.save()
                    }
                }

            }
            // here
            if showNotificationSetOverlay {
                notificationSetRemoved(title: "changed.")
                    .transition(.opacity)
                    .zIndex(1)
                
    }// if statement for showNoificationSetOverlay
            
        }
        

}
   

    func showWithAnimation() {
        withAnimation {
            showNotificationSetOverlay = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation {
                showNotificationSetOverlay = false
            }
        }
    }

    
} //view

struct ToggleButton: View {
    let title: String
    let colour: Color
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .bold()
            .font(.headline)
            .padding(.horizontal)
            .tint(colour)
    }
}

struct MealTimePicker: View {
    let title: String
    @Binding var hour: Int
    @Binding var minute: Int

    var body: some View {
        VStack(alignment: .leading) {

            HStack(spacing: 5) {
                Picker("Hour", selection: $hour) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                Picker("Min", selection: $minute) {
                    ForEach(0..<60, id: \.self) { min in
                        Text(String(format: "%02d", min)).tag(min)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .frame(height: 100)
        }
        
    }
}

struct notificationSetRemoved: View {
    let title: String
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(9)
                .shadow(color: Color(uiColor: .systemGray2), radius: 2)
            Text(title)
                .bold()
                .padding()
        }
        .frame(width: 110, height: 50)
    }
       
}

struct GoalPickerCard: View {
    let title: String
    let unit: String
    let range: StrideTo<Int>
    let icon: String
    let colour: Color
    @Binding var value: Int
    let onSave: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text (title)
                    .bold()
                    .font(.subheadline)
                                                        
                Image(systemName: icon)
                    .foregroundStyle(colour)
            }
            .padding()
            ZStack {
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                    .shadow(color: Color(uiColor: .systemBackground), radius: 2)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Spacer()
                        
                        Picker(title, selection: $value) {
                            ForEach(Array(range), id: \.self) { val in
                                Text("\(val) \(unit)").tag(val)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100, height: 120)
                        
                        Spacer()
                        
                        Button {
                            onSave()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.blue)
                                Text("SAVE")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(width: 120, height: 40)
                        .padding()
                    }
                }
            }
        }
    }
}
