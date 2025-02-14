//
//  SwiftDataService.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftData
import Foundation

class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Recipe.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext
    }
    
    func getRecipes() throws -> [Recipe] {
        return try modelContext.fetch(FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)]))
    }
    
    func insertRecipes(_ recipes: [Recipe]) throws {
        let savedRecipes = try getRecipes()
        recipes.filter { recipe in
            !savedRecipes.contains { $0.uuid == recipe.uuid}
        }.forEach { modelContext.insert($0) }
        try saveContext()
    }
    
    func removeAllRecipes(save: Bool = true) throws {
        try modelContext.delete(model: Recipe.self)
        if save {
            try saveContext()
        }
    }
    
    func updateRecipe(oldRecipe: Recipe, withRecipe recipe: Recipe, save: Bool = true) throws {
        // old one from the db, new one created from the network call (or manually for testing)
        // difference should be only in what's already downloaded
        if oldRecipe.photoUrlSmall == recipe.photoUrlSmall {
            recipe.photoUrlSmallDataURL = oldRecipe.photoUrlSmallDataURL
        }
        if oldRecipe.photoUrlLarge == recipe.photoUrlLarge {
            recipe.photoUrlLargeDataURL = oldRecipe.photoUrlLargeDataURL
        }
        try removeRecipe(oldRecipe, save: false)
        try insertRecipe(recipe, save: save)
    }
    
    func insertRecipe(_ recipe: Recipe, save: Bool = true) throws {
        modelContext.insert(recipe)
        if save {
            try saveContext()
        }
    }
    
    func removeRecipe(_ recipe: Recipe, save: Bool = true) throws {
        modelContext.delete(recipe)
        if save {
            try saveContext()
        }
    }
    
    func saveContext() throws {
        try modelContext.save()
    }
    
}
