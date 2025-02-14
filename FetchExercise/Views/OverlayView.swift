//
//  OverlayView.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI

// use to cover the background when expanding the image
struct OverlayView: View {
    
    var body: some View {
        Color(.black)
            .opacity(0.6)
            .ignoresSafeArea()
    }
}
