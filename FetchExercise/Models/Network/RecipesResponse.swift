//
//  RecipesResponse.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/12/25.
//

struct RecipesResponse: Decodable {
    
    enum CodingKeys: CodingKey {
        case recipes
    }
    
    var recipes: [Recipe]
}
