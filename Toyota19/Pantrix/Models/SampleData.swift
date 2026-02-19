import Foundation

enum SampleData {
    
    static var recipes: [Recipe] {
        [
            Recipe(
                name: "Scrambled Eggs with Toast",
                cookingTime: 5,
                ingredients: ["2 eggs", "2 slices of bread", "butter", "salt", "pepper"],
                instructions: ["Beat eggs in a bowl", "Heat butter in pan", "Add eggs and scramble", "Toast bread", "Serve together"],
                category: .protein
            ),
            Recipe(
                name: "Oatmeal with Berries",
                cookingTime: 8,
                ingredients: ["1 cup oats", "1 cup milk", "mixed berries", "honey"],
                instructions: ["Boil milk", "Add oats and cook for 5 minutes", "Add berries", "Drizzle with honey"],
                category: .healthy
            ),
            Recipe(
                name: "Pancakes",
                cookingTime: 12,
                ingredients: ["1 cup flour", "1 egg", "1 cup milk", "2 tbsp sugar", "baking powder"],
                instructions: ["Mix dry ingredients", "Add wet ingredients", "Cook on griddle", "Flip when bubbles form", "Serve hot"],
                category: .sweet
            ),
            Recipe(
                name: "Avocado Toast",
                cookingTime: 3,
                ingredients: ["1 avocado", "2 slices bread", "salt", "pepper", "lemon juice"],
                instructions: ["Toast bread", "Mash avocado", "Add seasonings", "Spread on toast", "Serve immediately"],
                category: .quick
            ),
            Recipe(
                name: "Greek Yogurt Bowl",
                cookingTime: 2,
                ingredients: ["Greek yogurt", "granola", "honey", "fresh fruits"],
                instructions: ["Add yogurt to bowl", "Top with granola", "Add fruits", "Drizzle honey"],
                category: .healthy
            )
        ]
    }
    
    static var sampleIngredients: [String] {
        ["eggs", "bread", "milk", "oats", "honey", "berries"]
    }
}
