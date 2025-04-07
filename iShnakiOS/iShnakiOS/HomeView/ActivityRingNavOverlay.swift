//
//  ActivityRingNavOverlay.swift
//  iShnakiOS
//
//  Created by Huw Williams on 07/04/2025.
//

import SwiftUI

struct ActivityRingNavOverlay: View {
    @State var navigateNow = false
    let width: CGFloat
    
    
    init(width: CGFloat) {
        self.width = width
        
    }
    
    var body: some View {
        Button {
            navigateNow = true
        }label: {
            Circle()
                .foregroundStyle(.white)
                .opacity(0.05)
                
        }
        .navigationDestination(isPresented: $navigateNow) {
            
        }
    }
}

#Preview {
    ActivityRingNavOverlay(width: 150)
}
