import SwiftUI
import Combine

class ColorTheme: ObservableObject {
    static let shared = ColorTheme()
    
    private init() {}
    
    let backgroundBlue = Color(red: 0.4, green: 0.7, blue: 0.9)
    let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.4, green: 0.7, blue: 0.9),
            Color(red: 0.3, green: 0.6, blue: 0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let primaryWhite = Color.white
    let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    let accentPurple = Color(red: 0.7, green: 0.5, blue: 0.9)
    let darkPurple = Color(red: 0.5, green: 0.3, blue: 0.7)
    
    let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    let primaryBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    let moodColors: [MoodColor] = [
        MoodColor(name: "Red", color: Color.red, description: "Passionate"),
        MoodColor(name: "Orange", color: Color.orange, description: "Energetic"),
        MoodColor(name: "Yellow", color: Color.yellow, description: "Joyful"),
        MoodColor(name: "Green", color: Color.green, description: "Peaceful"),
        MoodColor(name: "Blue", color: Color.blue, description: "Calm"),
        MoodColor(name: "Indigo", color: Color.indigo, description: "Thoughtful"),
        MoodColor(name: "Purple", color: Color.purple, description: "Creative"),
        MoodColor(name: "Pink", color: Color.pink, description: "Loving"),
        MoodColor(name: "Gray", color: Color.gray, description: "Neutral")
    ]
    
    func createGridBackground() -> some View {
        Canvas { context, size in
            let gridSize: CGFloat = 20
            let lineWidth: CGFloat = 0.5
            
            context.stroke(
                Path { path in
                    for x in stride(from: 0, through: size.width, by: gridSize) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }
                    
                    for y in stride(from: 0, through: size.height, by: gridSize) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                },
                with: .color(.white.opacity(0.3)),
                lineWidth: lineWidth
            )
        }
    }
}

struct MoodColor: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name, description
        case red, green, blue, alpha
    }
    
    init(name: String, color: Color, description: String) {
        self.name = name
        self.color = color
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let alpha = try container.decode(Double.self, forKey: .alpha)
        
        color = Color(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        try container.encode(Double(red), forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue), forKey: .blue)
        try container.encode(Double(alpha), forKey: .alpha)
    }
    
    static func == (lhs: MoodColor, rhs: MoodColor) -> Bool {
        return lhs.name == rhs.name
    }
}

struct BackgroundView: View {
    @StateObject private var colorTheme = ColorTheme.shared
    
    var body: some View {
        ZStack {
            colorTheme.backgroundGradient
                .ignoresSafeArea()
            
            colorTheme.createGridBackground()
                .ignoresSafeArea()
        }
    }
}
