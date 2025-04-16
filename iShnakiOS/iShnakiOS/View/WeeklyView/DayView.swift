//
//  DayView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 12/04/2025.
//

import SwiftUI

struct DayView: View {
    // Represents a single day's data passed into the view
    let day: UserData

    // Detect current light or dark mode
    @Environment(\.colorScheme) private var colourScheme

    // Dynamic color for yellow depending on system theme
    var lightOrDarkThemeForYellow: Color {
        colourScheme == .light ? .orange : .yellow
    }

    var body: some View {
        // Navigation to detailed chart view when this card is tapped
        NavigationLink {
            DayChartsView(data: day)
        } label: {
            ZStack {
                // Card background with light gray color and shadow
                Color(uiColor: .systemGray6)
                    .cornerRadius(15)
                    .shadow(color: Color(uiColor: .systemGray6), radius: 2)

                VStack(alignment: .leading) {
                    // Display date at the top with icon
                    HStack {
                        Image(systemName: "calendar")
                        Text(String(day.date.formatted(.dateTime.day().month(.wide).year())))
                            .foregroundStyle(.primary)
                            .bold()
                            .font(.headline)
                    }

                    // Water and beverage consumption
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                        Text("Water: ")
                            .bold()
                            .foregroundStyle(.blue)
                        Text(String(day.amountofWater) + "ml")
                            .foregroundStyle(.primary)

                        Spacer()

                        Image(systemName: "cup.and.heat.waves.fill")
                            .foregroundColor(.brown)
                        Text("Beverage: ")
                            .foregroundStyle(.brown)
                            .bold()
                        Text(String(day.amountofBeverage) + "ml")
                            .foregroundStyle(.primary)
                    }
                    .padding()

                    // Meal and snack consumption
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(lightOrDarkThemeForYellow)
                        Text("Meal: ")
                            .foregroundStyle(lightOrDarkThemeForYellow)
                            .bold()
                        Text(String(day.amountofMeal))
                            .foregroundStyle(.primary)

                        Spacer()

                        Image(systemName: "carrot.fill")
                            .foregroundColor(.red)
                        Text("Snack: ")
                            .foregroundStyle(.red)
                            .bold()
                        Text(String(day.amountofSnack))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                }
                .padding() // Padding around VStack content
            } // End ZStack
        } // End NavigationLink
    } // End body
} // End DayView
