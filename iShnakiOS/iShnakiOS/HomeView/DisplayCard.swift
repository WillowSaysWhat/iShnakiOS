//
//  DisplayCard.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI

struct DisplayCard: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray4)
            
            VStack {
                HStack {
                    Text("Hello, World!")
                        .font(.headline)
                    Spacer()
                    Text("")
                }
                Text("This is a preview of the iShnaki iOS app.")
                    .font(.caption)
            }
        }
    }
}

#Preview {
    DisplayCard()
}
