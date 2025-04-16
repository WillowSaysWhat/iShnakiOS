//
//  iShnakiOSApp.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI
import SwiftData

@main
struct iShnakiOSApp: App {
    
    // Create a shared SwiftData model container
    let iShnakContainer: ModelContainer
    
    init(){
        // Get the shared app group container URL
        let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.iShnak.shared")!
        
        // Define the SwiftData schema used in the app
        let schema = Schema([UserData.self, GoalDefaults.self, UserNotificationSettings.self])
        
        // Create a configuration using the shared URL path
        let config = ModelConfiguration(schema: schema, url: sharedURL.appending(path: "MyiShnakDB.db"))
        
        // Attempt to initialize the model container
        do {
            iShnakContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            // Crash the app if the container fails to initialize
            fatalError("Could not configure container.")
        }

        // Print the shared container path for debugging purposes
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.iShnak.shared") {
            print("Shared container is at: \(url.path())")
        }
    }

    var body: some Scene {
        WindowGroup {
            // Launch the main ContentView
            ContentView()
        }
        // Inject the configured SwiftData model container into the app environment
        .modelContainer(iShnakContainer)
    }
}
