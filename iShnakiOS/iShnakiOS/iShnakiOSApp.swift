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
    // making MyiShnakDB so I can find it on the HD
    let iShnakContainer: ModelContainer
    
    init(){
        let schema = Schema([UserData.self, GoalDefaults.self.self])
        let config = ModelConfiguration(schema: schema, url: URL.applicationSupportDirectory.appending(path: "MyiShnakDB.db"))
        
        do {
            iShnakContainer = try ModelContainer(for: schema, configurations: config)
            print(URL.applicationSupportDirectory.path(percentEncoded: false))
        } catch {
            fatalError("Could not configure container. Error: \(error)")
        }
        
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        WindowGroup {
            
            ContentView()
               
        }
        .modelContainer(for: [UserData.self, GoalDefaults.self], inMemory: false)
        
        
    }
   
}
