//
//  CuisineView.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI

struct CuisineView: View {
    
    let cuisine: String
    @Binding var toggledCuisines: [String]
    
    var body: some View {
        HStack {
            Text(cuisine)
                .font(.title2)
            Spacer()
            if toggledCuisines.contains(where: { $0 == cuisine }) {
                Image(systemName: "chevron.up")
            } else {
                Image(systemName: "chevron.down")
            }
        }
        .onTapGesture {
            if let index = toggledCuisines.firstIndex(where: { $0 == cuisine }) {
                toggledCuisines.remove(at: index)
            } else {
                toggledCuisines.append(cuisine)
            }
        }
    }
    
}
