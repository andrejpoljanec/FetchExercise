//
//  RecipesViewModel.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI
import SwiftData


class RecipesViewModel: ObservableObject {
    
    private let swiftDataService: SwiftDataService
    private let networkService: NetworkService
    
    @Published var recipes: [Recipe] = []
    @Published var tappedRecipeImage: Recipe? = nil
    @Published var searchText: String = ""
    @Published var filterType: FilterType = .AToZ
    @Published var toggledCuisines: [String] = []
    @Published var error: CustomError? = nil
    
    var filteredRecipes: [Recipe] {
        if searchText == "" {
            return recipes
        } else {
            return recipes.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.cuisine.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init(swiftDataService: SwiftDataService, networkService: NetworkService) {
        self.swiftDataService = swiftDataService
        self.networkService = networkService
    }
    
    @MainActor
    func fetchRecipes(endpointUrl: String = Constants.RECIPES_API) async {
        do {
            let oldRecipes = try swiftDataService.getRecipes()
            let newRecipes = try await networkService.fetchData(endpointUrl: endpointUrl)
            for newRecipe in newRecipes {
                if let oldRecipe = oldRecipes.first(where: { $0.uuid == newRecipe.uuid }) {
                    try swiftDataService.updateRecipe(oldRecipe: oldRecipe, withRecipe: newRecipe, save: false)
                } else {
                    try swiftDataService.insertRecipe(newRecipe, save: false)
                }
            }
            for oldRecipe in oldRecipes {
                if !newRecipes.contains(where: { $0.uuid == oldRecipe.uuid }) {
                    try swiftDataService.removeRecipe(oldRecipe, save: false)
                }
            }
            try swiftDataService.saveContext()
            recipes = newRecipes
        } catch {
            self.error = CustomError(message: "Error fetching recipes", id: error.localizedDescription)
        }
    }
    
    @MainActor
    func downloadLargeImageFor(recipe: Recipe) async {
        do {
            let dataURL = try await networkService.downloadLargeImageFor(recipe: recipe)
            recipe.photoUrlLargeDataURL = dataURL
            try swiftDataService.saveContext()
        } catch {
            if (error as NSError?)?.code != NSURLErrorCancelled {
                // these get cancelled on refresh and should not display an error
                self.error = CustomError(message: "Error downloading image", id: error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func downloadImageFor(recipe: Recipe) async {
        do{
            let dataURL = try await networkService.downloadImageFor(recipe: recipe)
            recipe.photoUrlSmallDataURL = dataURL
            try swiftDataService.saveContext()
        } catch {
            if (error as NSError?)?.code != NSURLErrorCancelled {
                // these get cancelled on refresh and should not display an error
                self.error = CustomError(message: "Error downloading image", id: error.localizedDescription)
            }
        }
    }
}

