//
//  iShnackWidget.swift
//  iShnackWidget
//
//  Created by Huw Williams on 16/04/2025.
//

import WidgetKit
import SwiftUI
import SwiftData

// TimelineProvider for the widget — provides data for rendering the widget over time
struct Provider: @preconcurrency TimelineProvider {
    
    // Store the shared SwiftData model container once
    private let container: ModelContainer?

    // Initialize and attempt to create the shared model container
    init() {
        self.container = try? Provider.makeSharedContainer()
    }

    // Provides placeholder data while widget loads
    @MainActor
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), waterGoal: 2000, calorieGoal: 2500, amountOfWater: 0, amountOfCalories: 0)
    }

    // Provides a snapshot for preview or when the widget is being configured
    @MainActor
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }

    // Provides a timeline with updated entries every 3 minutes
    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = createEntry()
        // updates every 3 minutes.
        let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 3)))
        completion(timeline)
    }

    // MARK: - Shared container setup

    // Creates the shared SwiftData container used by both app and widget
    static func makeSharedContainer() throws -> ModelContainer {
        
        // Get the shared app group container URL
        guard let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.iShnak.shared") else {
            throw NSError(domain: "iShnak", code: 1, userInfo: [NSLocalizedDescriptionKey: "Shared App Group URL not found."])
        }

        // Define the SwiftData schema
        let schema = Schema([UserData.self, GoalDefaults.self, UserNotificationSettings.self])

        // Configure with shared URL path to DB
        let config = ModelConfiguration(
            schema: schema,
            url: sharedURL.appending(path: "MyiShnakDB.db")
        )

        // Create and return the container
        return try ModelContainer(for: schema, configurations: config)
    }

    // MARK: - Fetch and create entry

    // Fetches SwiftData from shared container and creates a timeline entry
    @MainActor
    private func createEntry() -> SimpleEntry {
        // Fallback if context is unavailable
        guard let context = container?.mainContext else {
            return SimpleEntry(date: Date(), waterGoal: 2000, calorieGoal: 2500, amountOfWater: 0, amountOfCalories: 0)
        }

        // Fetch the latest goal and user data
        let goals: [GoalDefaults] = (try? context.fetch(FetchDescriptor<GoalDefaults>())) ?? []
        let data: [UserData] = (try? context.fetch(FetchDescriptor<UserData>(sortBy: [SortDescriptor(\.date, order: .reverse)]))) ?? []

        // Get first available goal and data
        let goal = goals.first
        let dataPoint = data.first

        // Return a widget entry
        return SimpleEntry(
            date: dataPoint?.date ?? Date(),
            waterGoal: goal?.waterGoal ?? 2000,
            calorieGoal: goal?.calorieGoal ?? 2500,
            amountOfWater: dataPoint?.amountofWater ?? 0,
            amountOfCalories: dataPoint?.caloriesConsumed ?? 0
        )
    }
}


// SimpleEntry holds all data for rendering a widget at a point in time
struct SimpleEntry: TimelineEntry {
    let date: Date
    let waterGoal: Int
    let calorieGoal: Int
    let amountOfWater: Int
    let amountOfCalories: Int
}

// Widget view rendering logic
struct iShnackWidgetEntryView : View {
    var entry: Provider.Entry
   
    var body: some View {
        HStack(spacing: 40) {
            // Water intake ring
            WidgetActivityRing(colour: .blue, amount: entry.amountOfWater , goal: entry.waterGoal, image: "waterbottle")
            
            // Calories ring
            WidgetActivityRing(colour: .indigo, amount: entry.amountOfCalories, goal: entry.calorieGoal, image: "heart")
        }
    }
}

// Widget declaration
struct iShnackWidget: Widget {
    let kind: String = "iShnackWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                iShnackWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                iShnackWidgetEntryView(entry: entry)
                    .background()
            }
        }
        .configurationDisplayName("iShnak")
        .description("Health App")
        .supportedFamilies([.systemMedium])
    }
}

// View that displays a circular progress ring with a label and icon
struct WidgetActivityRing: View {
    
    let colour: Color
    let width: CGFloat = 30
    let amount: Int
    let goal: Int
    let image: String

    var body: some View {
        ZStack {
            // Label with icon and value
            HStack(spacing: 1) {
                Image(systemName: image)
                    .font(.caption)
                    .foregroundColor(colour)
                Text("\(String(amount))\(colour == .blue ? "ml" : "kcal")")
                    .font(.caption)
            }
            .frame(width: 100)
            
            // Background circle
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: width)
            // Progress circle
            Circle()
                .trim(from: 0, to: CGFloat(amount) / CGFloat(goal))
                .stroke(colour, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .shadow(radius: 6)
        }
        .padding(10)
    }
}
