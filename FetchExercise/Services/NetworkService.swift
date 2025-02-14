//
//  NetworkService.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {
    }
    
    func fetchData(endpointUrl: String = Constants.RECIPES_API) async throws -> [Recipe] {
        let url = URL(string: endpointUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RecipesResponse.self, from: data)
        return response.recipes
    }
    
    func downloadImageFor(recipe: Recipe) async throws -> URL? {
        guard let url = recipe.photoUrlSmall?.url else { return nil }
        return try await downloadImage(url: url)
    }
    
    func downloadLargeImageFor(recipe: Recipe) async throws -> URL? {
        guard let url = recipe.photoUrlLarge?.url else { return nil }
        return try await downloadImage(url: url)
    }
    
    func downloadImage(url: URL) async throws -> URL? {
        let (data, _) = try await URLSession.shared.data(from: url)
        let dataURL = URL(string: "data:image/png;base64," + data.base64EncodedString())
        return dataURL
    }
    
}
