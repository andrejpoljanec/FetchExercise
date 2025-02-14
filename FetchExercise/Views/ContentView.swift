//
//  ContentView.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @StateObject private var recipesViewModel: RecipesViewModel = RecipesViewModel(swiftDataService: .shared, networkService: .shared)
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // switch from alphabetical to category/cuisine
                    FilterTypeView(recipesViewModel: recipesViewModel)
                    List {
                        if !recipesViewModel.recipes.isEmpty {
                            switch recipesViewModel.filterType {
                            case .AToZ:
                                // rows for all the recipes
                                ForEach(recipesViewModel.filteredRecipes) { recipe in
                                    RecipeView(recipe: recipe, recipesViewModel: recipesViewModel)
                                }
                            case .Cuisine:
                                // rows for all cuisines
                                ForEach(Set(recipesViewModel.filteredRecipes.map { $0.cuisine }).sorted(), id: \.self) { cuisine in
                                    CuisineView(cuisine: cuisine, toggledCuisines: $recipesViewModel.toggledCuisines)
                                    // if toggled, show recipes for that cuisine
                                    if recipesViewModel.toggledCuisines.contains(where: { $0 == cuisine }) {
                                        ForEach(recipesViewModel.filteredRecipes.filter({ $0.cuisine == cuisine }).sorted(by: { $0.name < $1.name })) { recipe in
                                            RecipeView(recipe: recipe, recipesViewModel: recipesViewModel)
                                        }
                                    }
                                }
                            }
                        } else {
                            Text("There are no recipes to show")
                        }
                    }
                    
                    .refreshable {
                        await recipesViewModel.fetchRecipes()
                    }
                    .task {
                        await recipesViewModel.fetchRecipes()
                    }
                    .searchable(text: $recipesViewModel.searchText, prompt: "Filter recipes")
                }
                // expand image if it exists
                if let tappedRecipeImage = recipesViewModel.tappedRecipeImage, let imageUrl = tappedRecipeImage.photoUrlLargeDataURL ?? tappedRecipeImage.photoUrlSmallDataURL {
                    OverlayView()
                        .onTap { self.recipesViewModel.tappedRecipeImage = nil }
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .onTap { self.recipesViewModel.tappedRecipeImage = nil }
                    .task {
                        // if large one is not yet downloaded, download it now
                        if tappedRecipeImage.photoUrlLargeDataURL == nil {
                            await self.recipesViewModel.downloadLargeImageFor(recipe: tappedRecipeImage)
                        }
                    }
                }
            }
            .navigationBarTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $recipesViewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.message))
            }
        }
    }
    
}
