import SwiftUI
import UIKit

struct SearchView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var searchText = ""
    @State private var selectedCategory: RecipeCategory? = nil
    @State private var sortOption: SortOption = .title
    @State private var selectedRecipe: Recipe?
    
    enum SortOption: String, CaseIterable {
        case title = "By Title"
        case date = "By Date"
        case category = "By Category"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    private var filteredRecipes: [Recipe] {
        var recipes = recipeViewModel.recipes
        
        if !searchText.isEmpty {
            recipes = recipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                recipe.instructions.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            recipes = recipes.filter { $0.category == category }
        }
        
        switch sortOption {
        case .title:
            recipes = recipes.sorted { $0.title < $1.title }
        case .date:
            recipes = recipes.sorted { $0.createdAt > $1.createdAt }
        case .category:
            recipes = recipes.sorted { $0.category.rawValue < $1.category.rawValue }
        }
        
        return recipes
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(.ubuntuTitle)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                .padding()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textSecondary)
                    
                    TextField("Search recipes, ingredients...", text: $searchText)
                        .font(.ubuntuBody)
                        .foregroundColor(.textPrimary)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                VStack(spacing: 15) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("All Categories")
                                    .font(.ubuntuCaption)
                                    .foregroundColor(selectedCategory == nil ? .white : .textSecondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == nil ?
                                        Color.primaryPurple : Color.white.opacity(0.1)
                                    )
                                    .cornerRadius(20)
                            }
                            
                            ForEach(RecipeCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category.displayName)
                                        .font(.ubuntuCaption)
                                        .foregroundColor(selectedCategory == category ? .white : .textSecondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedCategory == category ?
                                            Color.primaryPurple : Color.white.opacity(0.1)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    HStack {
                        Text("Sort by:")
                            .font(.ubuntuCaption)
                            .foregroundColor(.textSecondary)
                        
                        Picker("Sort", selection: $sortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.displayName).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.ubuntuCaption)
                        .foregroundColor(.primaryPurple)
                        
                        Spacer()
                        
                        Text("\(filteredRecipes.count) recipes")
                            .font(.ubuntuCaption)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 15)
                
                if filteredRecipes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: searchText.isEmpty ? "magnifyingglass" : "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.textSecondary)
                        
                        Text(searchText.isEmpty ? "Start searching" : "Recipes not found")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                        
                        Text(searchText.isEmpty ?
                             "Enter recipe name, ingredient or instruction" :
                                "Try changing your search query or filters")
                        .font(.ubuntuBody)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                                SearchRecipeCard(recipe: recipe, searchText: searchText, viewModel: recipeViewModel) {
                                    selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipeId: recipe.id, viewModel: recipeViewModel)
        }
    }
}

struct SearchRecipeCard: View {
    let recipe: Recipe
    let searchText: String
    @ObservedObject var viewModel: RecipeViewModel
    @State private var isPressed = false
    
    let onTap: () -> Void
    
    private var highlightedTitle: AttributedString {
        var attributedString = AttributedString(recipe.title)
        
        if !searchText.isEmpty {
            let ranges = recipe.title.ranges(of: searchText, options: .caseInsensitive)
            for range in ranges {
                if let attributedRange = Range(range, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = .primaryPurple
                    attributedString[attributedRange].font = .ubuntuHeadline
                }
            }
        }
        
        return attributedString
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(highlightedTitle)
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        HStack {
                            Text(recipe.category.displayName)
                                .font(.ubuntuCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.primaryPurple.opacity(0.2))
                                .cornerRadius(8)
                            
                            Button(action: {
                                viewModel.toggleFavorite(for: recipe)
                            }) {
                                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 16))
                                    .foregroundColor(recipe.isFavorite ? .red : .textSecondary)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryPurple.opacity(0.3), Color.primaryBlue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "book.closed")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryPurple)
                    }
                }
                
                if !recipe.ingredients.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ingredients:")
                            .font(.ubuntuCaption)
                            .foregroundColor(.textSecondary)
                        
                        Text(recipe.ingredients.prefix(3).joined(separator: ", ") +
                             (recipe.ingredients.count > 3 ? "..." : ""))
                        .font(.ubuntuSmall)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                    }
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                        
                        Text("\(recipe.ingredients.count) ingredients")
                            .font(.ubuntuSmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(recipe.createdAt, style: .date)
                        .font(.ubuntuSmall)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .opacity(isPressed ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

extension String {
    func ranges(of searchString: String, options: String.CompareOptions = []) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: searchString, options: options, range: searchStartIndex..<self.endIndex) {
            ranges.append(range)
            searchStartIndex = range.upperBound
        }
        
        return ranges
    }
}


