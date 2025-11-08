import SwiftUI
import Foundation

struct WeatherColor: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let displayName: String
    let color: ColorComponents
    let description: String
    
    init(name: String, displayName: String, color: Color, description: String) {
        self.name = name
        self.displayName = displayName
        self.color = ColorComponents(color: color)
        self.description = description
    }
    
    var swiftUIColor: Color {
        Color(red: color.red, green: color.green, blue: color.blue, opacity: color.alpha)
    }
}

struct ColorComponents: Codable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.alpha = Double(a)
    }
}

struct WeatherEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let weatherColor: WeatherColor
    let createdAt: Date
    
    init(date: Date, weatherColor: WeatherColor) {
        self.date = date
        self.weatherColor = weatherColor
        self.createdAt = Date()
    }
}

extension WeatherColor {
    static let predefinedColors: [WeatherColor] = [
        WeatherColor(name: "sunny", displayName: "Sunny", color: .yellow, description: "Bright sunny day"),
        WeatherColor(name: "clear", displayName: "Clear", color: Color(red: 0.5, green: 0.8, blue: 1.0), description: "Clear and cool"),
        WeatherColor(name: "cloudy", displayName: "Cloudy", color: .gray, description: "Overcast and cloudy"),
        WeatherColor(name: "snowy", displayName: "Snowy", color: Color(red: 0.25, green: 0.35, blue: 0.45), description: "Snow and winter"),
        WeatherColor(name: "cold", displayName: "Cold", color: .blue, description: "Cold weather"),
        WeatherColor(name: "fresh", displayName: "Fresh", color: .green, description: "Fresh spring day"),
        WeatherColor(name: "warm", displayName: "Warm", color: .orange, description: "Warm pleasant day"),
        WeatherColor(name: "evening", displayName: "Evening", color: .purple, description: "Evening mood"),
        WeatherColor(name: "hot", displayName: "Hot", color: .red, description: "Very hot weather"),
        WeatherColor(name: "muddy", displayName: "Muddy", color: .brown, description: "Rainy and muddy"),
        WeatherColor(name: "stormy", displayName: "Stormy", color: .black, description: "Storm and heavy clouds"),
        WeatherColor(name: "gentle", displayName: "Gentle", color: .pink, description: "Gentle and mild weather")
    ]
}
