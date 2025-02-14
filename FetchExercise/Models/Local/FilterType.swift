//
//  FilterType.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

enum FilterType: CaseIterable, Identifiable {
    case AToZ
    case Cuisine
    
    var title: String {
        switch self {
        case .AToZ:
            return "A to Z"
        case .Cuisine:
            return "Cuisine"
        }
    }
    
    var id: Self {
        self
    }
}
