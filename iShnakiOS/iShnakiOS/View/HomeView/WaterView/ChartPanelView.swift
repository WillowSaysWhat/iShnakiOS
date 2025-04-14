//
//  ChartPanelView.swift
//  iShnakiOS
//
//  Created by Huw Williams on 10/04/2025.
//

import SwiftUI

struct ChartPanelView: View {
    let title: String
    var total: Int?
    var body: some View {
        ZStack {
            // background
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            // title and
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(String(total ?? 0))
                    .font(.title)
            }
                
        }
    }
}

#Preview {
    ChartPanelView(title: "SEVEN DAYS")
        
}
