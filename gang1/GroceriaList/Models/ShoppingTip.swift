import Foundation

struct ShoppingTip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    
    static let tips = [
        ShoppingTip(
            title: "Plan before shopping",
            description: "Make a list in advance before shopping. This reduces the likelihood of impulse spending and helps you not forget what you need."
        ),
        ShoppingTip(
            title: "Don't shop when hungry",
            description: "Hunger increases the desire to buy more. Eat before shopping — it's a simple way to save money."
        ),
        ShoppingTip(
            title: "Compare prices",
            description: "Sometimes the price difference between brands reaches 20–30%. Check alternatives — especially for standard goods."
        ),
        ShoppingTip(
            title: "Check expiration dates",
            description: "When buying products with a short shelf life, make sure they don't spoil before use."
        ),
        ShoppingTip(
            title: "Use categories",
            description: "Divide your list by categories — this speeds up shopping and helps you not miss anything."
        )
    ]
}
