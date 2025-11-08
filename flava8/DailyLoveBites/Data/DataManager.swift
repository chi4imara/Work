import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var recipes: [Recipe] = []
    @Published var tags: [Tag] = []
    
    private let recipesKey = "SavedRecipes"
    private let tagsKey = "SavedTags"
    
    private init() {
        loadData()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        updateTagsFromRecipes()
        saveData()
    }
    
    func updateRecipe(_ updatedRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            var recipe = updatedRecipe
            recipe.updatedAt = Date()
            recipes[index] = recipe
            updateTagsFromRecipes()
            saveData()
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        updateTagsFromRecipes()
        saveData()
    }
    
    func toggleRecipeFavorite(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].toggleFavorite()
            saveData()
        }
    }
    
    func duplicateRecipe(_ recipe: Recipe) -> Recipe {
        let duplicatedRecipe = Recipe(
            name: "\(recipe.name) (Copy)",
            servings: recipe.servings,
            cookingTime: recipe.cookingTime,
            difficulty: recipe.difficulty,
            tags: recipe.tags,
            ingredients: recipe.ingredients,
            steps: recipe.steps,
            isFavorite: false,
            notes: recipe.notes
        )
        
        addRecipe(duplicatedRecipe)
        return duplicatedRecipe
    }
    
    func addTag(_ tagName: String) -> Bool {
        let trimmedName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("🏷️ DataManager: Attempting to add tag '\(trimmedName)'")
        print("🏷️ DataManager: Current tags count: \(tags.count)")
        
        guard Tag.isValidTagName(trimmedName) else {
            print("❌ DataManager: Tag name '\(trimmedName)' is invalid")
            return false
        }
        
        guard !tags.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            print("❌ DataManager: Tag '\(trimmedName)' already exists")
            return false
        }
        
        let newTag = Tag(name: trimmedName)
        tags.append(newTag)
        tags.sort { $0.name.lowercased() < $1.name.lowercased() }
        print("✅ DataManager: Added tag '\(trimmedName)', total tags: \(tags.count)")
        saveData()
        return true
    }
    
    func updateTag(_ tag: Tag, newName: String) -> Bool {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard Tag.isValidTagName(trimmedName),
              !tags.contains(where: { $0.id != tag.id && $0.name.lowercased() == trimmedName.lowercased() }) else {
            return false
        }
        
        let oldName = tag.name
        
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags[index].name = trimmedName
        }
        
        for i in recipes.indices {
            if let tagIndex = recipes[i].tags.firstIndex(of: oldName) {
                recipes[i].tags[tagIndex] = trimmedName
                recipes[i].updatedAt = Date()
            }
        }
        
        tags.sort { $0.name.lowercased() < $1.name.lowercased() }
        saveData()
        return true
    }
    
    func deleteTag(_ tag: Tag) {
        tags.removeAll { $0.id == tag.id }
        
        for i in recipes.indices {
            recipes[i].tags.removeAll { $0 == tag.name }
            if !recipes[i].tags.isEmpty {
                recipes[i].updatedAt = Date()
            }
        }
        
        saveData()
    }
    
    func getRecipesWithTag(_ tagName: String) -> [Recipe] {
        return recipes.filter { $0.tags.contains(tagName) }
    }
    
    func getTagUsageCount(_ tagName: String) -> Int {
        return recipes.filter { $0.tags.contains(tagName) }.count
    }
    
    func searchRecipes(query: String, 
                      showFavoritesOnly: Bool = false,
                      selectedTags: [String] = [],
                      timeFilter: TimeFilter? = nil,
                      difficultyFilter: Recipe.Difficulty? = nil,
                      servingsFilter: ServingsFilter? = nil) -> [Recipe] {
        
        var filteredRecipes = recipes
        
        if !query.isEmpty {
            filteredRecipes = filteredRecipes.filter { $0.matchesSearchQuery(query) }
        }
        
        if showFavoritesOnly {
            let beforeCount = filteredRecipes.count
            filteredRecipes = filteredRecipes.filter { $0.isFavorite }
            print("🔍 DataManager: Favorites filter - before: \(beforeCount), after: \(filteredRecipes.count)")
        }
        
        if !selectedTags.isEmpty {
            filteredRecipes = filteredRecipes.filter { recipe in
                selectedTags.allSatisfy { tag in recipe.tags.contains(tag) }
            }
        }
        
        if let timeFilter = timeFilter {
            filteredRecipes = filteredRecipes.filter { recipe in
                guard let cookingTime = recipe.cookingTime else { return false }
                return timeFilter.matches(cookingTime)
            }
        }
        
        if let difficultyFilter = difficultyFilter {
            filteredRecipes = filteredRecipes.filter { $0.difficulty == difficultyFilter }
        }
        
        if let servingsFilter = servingsFilter {
            filteredRecipes = filteredRecipes.filter { recipe in
                servingsFilter.matches(recipe.servings)
            }
        }
        
        return filteredRecipes
    }
    
    func sortRecipes(_ recipes: [Recipe], by sortOption: SortOption) -> [Recipe] {
        switch sortOption {
        case .nameAscending:
            return recipes.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .cookingTimeAscending:
            return recipes.sorted { (first, second) in
                let firstTime = first.cookingTime ?? Int.max
                let secondTime = second.cookingTime ?? Int.max
                return firstTime < secondTime
            }
        case .cookingTimeDescending:
            return recipes.sorted { (first, second) in
                let firstTime = first.cookingTime ?? -1
                let secondTime = second.cookingTime ?? -1
                return firstTime > secondTime
            }
        case .recentlyAdded:
            return recipes.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    private func updateTagsFromRecipes() {
        let allTagNames = Set(recipes.flatMap { $0.tags })
        let existingTagNames = Set(tags.map { $0.name })
        
        let newTagNames = allTagNames.subtracting(existingTagNames)
        for tagName in newTagNames {
            let newTag = Tag(name: tagName)
            tags.append(newTag)
        }
        
        tags.removeAll { tag in
            !allTagNames.contains(tag.name)
        }
        
        tags.sort { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    private func saveData() {
        print("💾 Saving data to UserDefaults...")
        
        if let recipesData = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(recipesData, forKey: recipesKey)
            print("✅ Saved \(recipes.count) recipes to UserDefaults")
        } else {
            print("❌ Failed to encode recipes")
        }
        
        if let tagsData = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(tagsData, forKey: tagsKey)
            print("✅ Saved \(tags.count) tags to UserDefaults")
        } else {
            print("❌ Failed to encode tags")
        }
        
        UserDefaults.standard.synchronize()
        print("💾 Data synchronization completed")
    }
    
    private func loadData() {
        print("🔄 Loading data from UserDefaults...")
        
        if let recipesData = UserDefaults.standard.data(forKey: recipesKey),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: recipesData) {
            recipes = decodedRecipes
            print("✅ Loaded \(recipes.count) recipes from UserDefaults")
        } else {
            print("⚠️ No recipes found in UserDefaults")
        }
        
        if let tagsData = UserDefaults.standard.data(forKey: tagsKey),
           let decodedTags = try? JSONDecoder().decode([Tag].self, from: tagsData) {
            tags = decodedTags
            print("✅ Loaded \(tags.count) tags from UserDefaults")
        } else {
            print("⚠️ No tags found in UserDefaults")
        }
        
        updateTagsFromRecipes()
        print("📊 Final state: \(recipes.count) recipes, \(tags.count) tags")
    }
    
    private func createSampleDataIfNeeded() {
        guard recipes.isEmpty && UserDefaults.standard.object(forKey: "hasCreatedSampleData") == nil else { return }
        
        let sampleRecipes = [
            Recipe(
                name: "Classic Pasta Carbonara",
                servings: 4,
                cookingTime: 20,
                difficulty: .easy,
                tags: ["pasta", "quick", "italian"],
                ingredients: [
                    Ingredient(quantity: "400g", name: "spaghetti"),
                    Ingredient(quantity: "200g", name: "pancetta"),
                    Ingredient(quantity: "4", name: "eggs"),
                    Ingredient(quantity: "100g", name: "parmesan cheese"),
                    Ingredient(quantity: "2 cloves", name: "garlic")
                ],
                steps: [
                    CookingStep(description: "Cook spaghetti according to package instructions until al dente."),
                    CookingStep(description: "While pasta cooks, fry pancetta in a large pan until crispy."),
                    CookingStep(description: "Beat eggs with grated parmesan and black pepper."),
                    CookingStep(description: "Drain pasta and add to pancetta pan. Remove from heat."),
                    CookingStep(description: "Quickly stir in egg mixture to create creamy sauce. Serve immediately.")
                ],
                isFavorite: true,
                notes: "The key is to work quickly when adding the eggs to avoid scrambling them."
            ),
            Recipe(
                name: "Chocolate Chip Cookies",
                servings: 24,
                cookingTime: 25,
                difficulty: .easy,
                tags: ["dessert", "baking", "cookies"],
                ingredients: [
                    Ingredient(quantity: "2 1/4 cups", name: "all-purpose flour"),
                    Ingredient(quantity: "1 cup", name: "butter"),
                    Ingredient(quantity: "3/4 cup", name: "brown sugar"),
                    Ingredient(quantity: "1/2 cup", name: "white sugar"),
                    Ingredient(quantity: "2", name: "eggs"),
                    Ingredient(quantity: "2 cups", name: "chocolate chips")
                ],
                steps: [
                    CookingStep(description: "Preheat oven to 375°F (190°C)."),
                    CookingStep(description: "Cream together butter and both sugars until fluffy."),
                    CookingStep(description: "Beat in eggs one at a time, then add vanilla."),
                    CookingStep(description: "Gradually mix in flour, then fold in chocolate chips."),
                    CookingStep(description: "Drop rounded tablespoons of dough onto ungreased baking sheets."),
                    CookingStep(description: "Bake for 9-11 minutes until golden brown. Cool on baking sheet for 2 minutes.")
                ],
                isFavorite: false
            )
        ]
        
        for recipe in sampleRecipes {
            addRecipe(recipe)
        }
        
        UserDefaults.standard.set(true, forKey: "hasCreatedSampleData")
    }
}

enum SortOption: String, CaseIterable {
    case nameAscending = "name_asc"
    case cookingTimeAscending = "time_asc"
    case cookingTimeDescending = "time_desc"
    case recentlyAdded = "recent"
    
    var displayName: String {
        switch self {
        case .nameAscending: return "Name A→Z"
        case .cookingTimeAscending: return "Cooking Time ↑"
        case .cookingTimeDescending: return "Cooking Time ↓"
        case .recentlyAdded: return "Recently Added"
        }
    }
}

enum TimeFilter: String, CaseIterable {
    case quick = "≤15"
    case medium = "≤30"
    case long = "≤60"
    case any = "any"
    
    var displayName: String {
        switch self {
        case .quick: return "≤15 min"
        case .medium: return "≤30 min"
        case .long: return "≤60 min"
        case .any: return "Any"
        }
    }
    
    func matches(_ cookingTime: Int) -> Bool {
        switch self {
        case .quick: return cookingTime <= 15
        case .medium: return cookingTime <= 30
        case .long: return cookingTime <= 60
        case .any: return true
        }
    }
}

enum ServingsFilter: String, CaseIterable {
    case small = "1-2"
    case medium = "3-4"
    case large = "5+"
    
    var displayName: String {
        switch self {
        case .small: return "1-2 servings"
        case .medium: return "3-4 servings"
        case .large: return "5+ servings"
        }
    }
    
    func matches(_ servings: Int) -> Bool {
        switch self {
        case .small: return servings >= 1 && servings <= 2
        case .medium: return servings >= 3 && servings <= 4
        case .large: return servings >= 5
        }
    }
}
