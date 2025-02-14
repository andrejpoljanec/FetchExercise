//
//  FetchExerciseTests.swift
//  FetchExerciseTests
//
//  Created by Andrej Poljanec on 2/12/25.
//

import Testing
@testable import FetchExercise

struct FetchExerciseTests {

    @MainActor @Test func testFilterRecipes() {
        let cuisine1 = "Cuisine1"
        let cuisine2 = "Cuisine2"
        let recipe1 = Recipe(cuisine: cuisine1, name: "Abc", uuid: "")
        let recipe2 = Recipe(cuisine: cuisine1, name: "Bcd", uuid: "")
        let recipe3 = Recipe(cuisine: cuisine1, name: "Cde", uuid: "")
        let recipe4 = Recipe(cuisine: cuisine1, name: "Def", uuid: "")
        let recipesViewModel = RecipesViewModel(swiftDataService: .shared, networkService: .shared)
        recipesViewModel.recipes = [recipe1, recipe2, recipe3, recipe4]

        #expect(recipesViewModel.filteredRecipes.count == 4)

        recipesViewModel.searchText = "D"
        #expect(recipesViewModel.filteredRecipes.count == 3)
        
        recipesViewModel.searchText = "Z"
        #expect(recipesViewModel.filteredRecipes.isEmpty)
        
        recipesViewModel.searchText = "C"
        #expect(recipesViewModel.filteredRecipes.count == 4)
    }
    
    @MainActor @Test func testEmptyData() async throws {
        let recipesViewModel = RecipesViewModel(swiftDataService: .shared, networkService: .shared)
        await recipesViewModel.fetchRecipes(endpointUrl: Constants.RECIPES_EMPTY)
        #expect(recipesViewModel.recipes.isEmpty)
        
        await recipesViewModel.fetchRecipes(endpointUrl: Constants.RECIPES_MALFORMED)
        #expect(recipesViewModel.recipes.isEmpty)
        
        await recipesViewModel.fetchRecipes()
        #expect(!recipesViewModel.recipes.isEmpty)
    }
    
    @MainActor @Test func testImageDownload() async throws {
        let recipesViewModel = RecipesViewModel(swiftDataService: .shared, networkService: .shared)
        await recipesViewModel.fetchRecipes()
        let recipe = recipesViewModel.recipes.first
        try #require(recipe != nil, "There should be at least one recipe")
        await recipesViewModel.downloadImageFor(recipe: recipe!)
        #expect(recipe?.photoUrlSmallDataURL != nil)
    }
    
    @MainActor @Test func testSwiftDataUpdates() async throws {
        let recipesViewModel = RecipesViewModel(swiftDataService: .shared, networkService: .shared)
        await recipesViewModel.fetchRecipes()
        let recipe = recipesViewModel.recipes.last
        try #require(recipe != nil, "There should be at least one recipe")
        let updatingRecipe = Recipe(cuisine: recipe!.cuisine,
                                   name: "New name",
                                   photoUrlLarge: recipe!.photoUrlLarge,
                                   photoUrlSmall: recipe!.photoUrlSmall,
                                   uuid: recipe!.uuid,
                                   sourceUrl: recipe!.sourceUrl,
                                   youtubeUrl: recipe!.youtubeUrl
        )
        try SwiftDataService.shared.updateRecipe(oldRecipe: recipe!, withRecipe: updatingRecipe)
        let updatedRecipe = try SwiftDataService.shared.getRecipes().first(where: { $0.uuid == recipe!.uuid })
        #expect(updatedRecipe != nil)
        #expect(updatedRecipe!.name == "New name")
    }

}
