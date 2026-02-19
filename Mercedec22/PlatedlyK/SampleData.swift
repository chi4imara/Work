import Foundation

enum SampleData {
    
    static var sampleRecipes: [Recipe] {
        [
            Recipe(
                name: "Oatmeal with Berries",
                cookingTime: 15,
                difficulty: .beginner,
                calories: 280,
                category: .breakfast,
                ingredients: [
                    Ingredient(name: "Oats", amount: "1", unit: "cup"),
                    Ingredient(name: "Milk", amount: "1", unit: "cup"),
                    Ingredient(name: "Mixed berries", amount: "1/2", unit: "cup"),
                    Ingredient(name: "Honey", amount: "1", unit: "tbsp")
                ],
                instructions: [
                    "Bring milk to a boil.",
                    "Add oats and cook for 5 minutes.",
                    "Top with berries and honey."
                ],
                macros: Macros(protein: 10, carbs: 45, fat: 6, fiber: 6),
                tags: ["Quick", "Healthy", "Breakfast"]
            ),
            Recipe(
                name: "Grilled Chicken Salad",
                cookingTime: 25,
                difficulty: .beginner,
                calories: 320,
                category: .lunch,
                ingredients: [
                    Ingredient(name: "Chicken breast", amount: "200", unit: "g"),
                    Ingredient(name: "Mixed greens", amount: "100", unit: "g"),
                    Ingredient(name: "Cherry tomatoes", amount: "5", unit: "pcs"),
                    Ingredient(name: "Olive oil", amount: "1", unit: "tbsp")
                ],
                instructions: [
                    "Grill chicken until cooked through.",
                    "Toss greens with tomatoes.",
                    "Slice chicken and place on top. Drizzle with oil."
                ],
                macros: Macros(protein: 35, carbs: 8, fat: 16, fiber: 3),
                tags: ["High Protein", "Low Carb"]
            ),
            Recipe(
                name: "Salmon with Vegetables",
                cookingTime: 35,
                difficulty: .intermediate,
                calories: 420,
                category: .dinner,
                ingredients: [
                    Ingredient(name: "Salmon fillet", amount: "200", unit: "g"),
                    Ingredient(name: "Broccoli", amount: "150", unit: "g"),
                    Ingredient(name: "Carrots", amount: "2", unit: "pcs"),
                    Ingredient(name: "Lemon", amount: "1/2", unit: "pcs")
                ],
                instructions: [
                    "Season salmon and bake at 180°C for 20 min.",
                    "Steam broccoli and carrots.",
                    "Serve with lemon wedge."
                ],
                macros: Macros(protein: 38, carbs: 15, fat: 22, fiber: 5),
                tags: ["Omega-3", "Dinner"]
            ),
            Recipe(
                name: "Greek Yogurt Parfait",
                cookingTime: 5,
                difficulty: .beginner,
                calories: 220,
                category: .snack,
                ingredients: [
                    Ingredient(name: "Greek yogurt", amount: "150", unit: "g"),
                    Ingredient(name: "Granola", amount: "30", unit: "g"),
                    Ingredient(name: "Banana", amount: "1/2", unit: "pcs")
                ],
                instructions: [
                    "Layer yogurt, granola, and banana in a glass.",
                    "Repeat layers. Serve cold."
                ],
                macros: Macros(protein: 15, carbs: 28, fat: 6, fiber: 2),
                tags: ["Quick", "Snack"]
            ),
            Recipe(
                name: "Vegetable Stir-Fry",
                cookingTime: 20,
                difficulty: .beginner,
                calories: 250,
                category: .dinner,
                ingredients: [
                    Ingredient(name: "Bell peppers", amount: "2", unit: "pcs"),
                    Ingredient(name: "Broccoli", amount: "100", unit: "g"),
                    Ingredient(name: "Soy sauce", amount: "2", unit: "tbsp"),
                    Ingredient(name: "Rice", amount: "1", unit: "cup")
                ],
                instructions: [
                    "Cook rice according to package.",
                    "Stir-fry vegetables in a wok.",
                    "Add soy sauce. Serve over rice."
                ],
                macros: Macros(protein: 8, carbs: 42, fat: 4, fiber: 4),
                tags: ["Vegetarian", "Quick"]
            ),
            Recipe(
                name: "Avocado Toast",
                cookingTime: 10,
                difficulty: .beginner,
                calories: 290,
                category: .breakfast,
                ingredients: [
                    Ingredient(name: "Whole grain bread", amount: "2", unit: "slices"),
                    Ingredient(name: "Avocado", amount: "1", unit: "pcs"),
                    Ingredient(name: "Egg", amount: "1", unit: "pcs"),
                    Ingredient(name: "Salt and pepper", amount: "to taste", unit: "")
                ],
                instructions: [
                    "Toast bread. Mash avocado and spread on toast.",
                    "Fry egg. Place on top. Season."
                ],
                macros: Macros(protein: 12, carbs: 22, fat: 18, fiber: 10),
                tags: ["Breakfast", "Healthy Fats"]
            )
        ]
    }
    
    static func sampleMealPlans(using recipes: [Recipe]) -> [MealPlan] {
        guard recipes.count >= 4 else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let day1 = calendar.date(byAdding: .day, value: -2, to: today)!
        let day2 = calendar.date(byAdding: .day, value: -1, to: today)!
        let day3 = today
        let day4 = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return [
            MealPlan(
                date: day1,
                meals: [
                    PlannedMeal(recipe: recipes[0], category: .breakfast),
                    PlannedMeal(recipe: recipes[1], category: .lunch)
                ]
            ),
            MealPlan(
                date: day2,
                meals: [
                    PlannedMeal(recipe: recipes[0], category: .breakfast),
                    PlannedMeal(recipe: recipes[2], category: .dinner)
                ]
            ),
            MealPlan(
                date: day3,
                meals: [
                    PlannedMeal(recipe: recipes[5], category: .breakfast),
                    PlannedMeal(recipe: recipes[1], category: .lunch),
                    PlannedMeal(recipe: recipes[2], category: .dinner)
                ]
            ),
            MealPlan(
                date: day4,
                meals: [
                    PlannedMeal(recipe: recipes[3], category: .snack),
                    PlannedMeal(recipe: recipes[4], category: .dinner)
                ]
            )
        ]
    }
    
    static var sampleUser: User {
        User(
            name: "Sample User",
            email: "sample@cookher.app",
            goals: [.healthyEating, .maintenance],
            allergies: ["Nuts"],
            favoriteIngredients: ["Chicken", "Salmon", "Oats"],
            dietaryPreferences: [.lowCarb],
            notificationSettings: NotificationSettings(
                newRecipes: true,
                mealReminders: true,
                nutritionTips: true
            )
        )
    }
}
