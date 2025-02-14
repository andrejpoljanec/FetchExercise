//
//  TapToDismissViewModifier.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI

struct TapViewModifier: ViewModifier {
    
    var action: () -> () = {}
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                withAnimation {
                    self.action()
                }
            }
    }
}

extension View {
    func onTap(action: @escaping () -> () = {}) -> some View {
        modifier(TapViewModifier(action: action))
    }
}
