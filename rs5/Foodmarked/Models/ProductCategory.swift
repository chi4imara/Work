import Foundation
import SwiftUI

enum ProductCategory: String, CaseIterable, Codable {
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case dairy = "Dairy"
    case meat = "Meat"
    case grains = "Grains"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .fruits:
            return "🍎"
        case .vegetables:
            return "🥬"
        case .dairy:
            return "🥛"
        case .meat:
            return "🥩"
        case .grains:
            return "🌾"
        case .beverages:
            return "🥤"
        case .snacks:
            return "🍪"
        case .other:
            return "📦"
        }
    }
    
    var color: Color {
        switch self {
        case .fruits:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case .vegetables:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .dairy:
            return Color(red: 1.0, green: 1.0, blue: 0.9)
        case .meat:
            return Color(red: 0.8, green: 0.3, blue: 0.3)
        case .grains:
            return Color(red: 0.9, green: 0.7, blue: 0.4)
        case .beverages:
            return Color(red: 0.3, green: 0.6, blue: 1.0)
        case .snacks:
            return Color(red: 0.9, green: 0.6, blue: 0.3)
        case .other:
            return Color(red: 0.6, green: 0.6, blue: 0.6)
        }
    }
    
    static func detectCategory(from name: String) -> ProductCategory {
        let lowercased = name.lowercased()
        
        let fruits = ["apple", "banana", "orange", "berry", "grape", "mango", "pineapple", "strawberry", "peach", "pear"]
        let vegetables = ["spinach", "broccoli", "carrot", "lettuce", "tomato", "cucumber", "pepper", "onion", "potato", "cabbage"]
        let dairy = ["milk", "cheese", "yogurt", "butter", "cream", "dairy"]
        let meat = ["chicken", "beef", "pork", "fish", "salmon", "turkey", "meat", "sausage"]
        let grains = ["bread", "rice", "pasta", "quinoa", "oats", "wheat", "cereal", "grain"]
        let beverages = ["juice", "soda", "water", "coffee", "tea", "drink", "beverage"]
        let snacks = ["cookie", "chip", "cracker", "candy", "chocolate", "snack", "bar"]
        
        if fruits.contains(where: lowercased.contains) {
            return .fruits
        } else if vegetables.contains(where: lowercased.contains) {
            return .vegetables
        } else if dairy.contains(where: lowercased.contains) {
            return .dairy
        } else if meat.contains(where: lowercased.contains) {
            return .meat
        } else if grains.contains(where: lowercased.contains) {
            return .grains
        } else if beverages.contains(where: lowercased.contains) {
            return .beverages
        } else if snacks.contains(where: lowercased.contains) {
            return .snacks
        }
        
        return .other
    }
}