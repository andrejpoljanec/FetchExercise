//
//  RecipeView.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI
import SwiftData

struct RecipeView: View {
    
    let recipe: Recipe
    
    @ObservedObject var recipesViewModel: RecipesViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: recipe.photoUrlSmallDataURL) { phase in
                if let image = phase.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .onTap { self.recipesViewModel.tappedRecipeImage = recipe }
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()
                }
            }.task {
                await recipesViewModel.downloadImageFor(recipe: recipe)
            }
            .frame(width: 50, height: 50)
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 1))
            .shadow(radius: 2)
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let sourceUrl = recipe.sourceUrl?.url, UIApplication.shared.canOpenURL(sourceUrl) {
                Button(action: {
                    UIApplication.shared.open(sourceUrl, options: [:], completionHandler: nil)
                }) {
                    Image("www")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            if let youtubeUrl = recipe.youtubeUrl?.url, UIApplication.shared.canOpenURL(youtubeUrl) {
                Button(action: {
                    UIApplication.shared.open(youtubeUrl, options: [:], completionHandler: nil)
                }) {
                    Image("youtube")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
 

    
}
