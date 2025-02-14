//
//  FilterTypeView.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI

struct FilterTypeView: View {
    
    @ObservedObject var recipesViewModel: RecipesViewModel
    
    var body: some View {
        HStack {
            ForEach(FilterType.allCases) { filterType in
                Button(action: {
                    self.recipesViewModel.filterType = filterType
                }) {
                    Text(filterType.title)
                        .font(.caption)
                }
                .buttonStyle(SelectableButtonStyle(selected: self.recipesViewModel.filterType == filterType))
            }
        }
    }
    
}

// make these buttons a bit nicer, kind of like those in the Fetch app
struct SelectableButtonStyle: ButtonStyle {
    
    var selected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label.foregroundColor(.black)
        }
        .padding(8)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .background(Capsule().foregroundColor(selected ? Color.orange.opacity(0.2) : Color.white))
        .overlay(
            ButtonGradient(selected: selected)
        )
    }
}

var orangeGradient = Gradient(
    colors: [
        Color.filterGradientStartColor(),
        Color.filterGradientEndColor(),
        Color.filterGradientStartColor()
    ]
)

struct ButtonGradient: View {
    
    var selected: Bool
    
    var body: some View {
        if selected {
            Capsule()
                .stroke(
                    LinearGradient(
                        gradient: orangeGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        } else {
            Capsule()
                .stroke(.gray, lineWidth: 1)
        }
    }
}
