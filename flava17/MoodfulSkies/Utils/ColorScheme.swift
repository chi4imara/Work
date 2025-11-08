import SwiftUI
import Combine

class AppColors: ObservableObject {
    static let shared = AppColors()
    
    @Published var selectedScheme: ThemeManager.ColorScheme = .light {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
                self.objectWillChange.send()
            }
        }
    }
    @Published var selectedAccent: ThemeManager.AccentColor = .orange {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
                self.objectWillChange.send()
            }
        }
    }
    
    var primaryBlue: Color {
        switch selectedAccent {
        case .blue: return Color(red: 0.4, green: 0.7, blue: 1.0)
        case .orange: return Color(red: 1.0, green: 0.6, blue: 0.2)
        case .green: return Color(red: 0.3, green: 0.8, blue: 0.5)
        case .purple: return Color(red: 0.6, green: 0.4, blue: 0.9)
        case .pink: return Color(red: 1.0, green: 0.4, blue: 0.7)
        case .red: return Color.red
        }
    }
    
    var primaryOrange: Color {
        switch selectedAccent {
        case .blue: return Color(red: 0.4, green: 0.7, blue: 1.0)
        case .orange: return Color(red: 1.0, green: 0.6, blue: 0.2)
        case .green: return Color(red: 0.3, green: 0.8, blue: 0.5)
        case .purple: return Color(red: 0.6, green: 0.4, blue: 0.9)
        case .pink: return Color(red: 1.0, green: 0.4, blue: 0.7)
        case .red: return Color.red
        }
    }
    
    var backgroundWhite: Color {
        switch selectedScheme {
        case .light: return Color.white
        case .dark: return Color(red: 0.1, green: 0.1, blue: 0.1)
        case .auto: return Color(UIColor.systemBackground)
        }
    }
    
    var backgroundBlue: Color {
        switch selectedScheme {
        case .light: return Color(red: 0.95, green: 0.98, blue: 1.0)
        case .dark: return Color(red: 0.05, green: 0.08, blue: 0.1)
        case .auto: return Color(UIColor.secondarySystemBackground)
        }
    }
    
    var textPrimary: Color {
        switch selectedScheme {
        case .light: return Color(red: 0.2, green: 0.5, blue: 0.8)
        case .dark: return Color.white
        case .auto: return Color(UIColor.label)
        }
    }
    
    var textSecondary: Color {
        switch selectedScheme {
        case .light: return Color(red: 0.4, green: 0.4, blue: 0.4)
        case .dark: return Color(red: 0.7, green: 0.7, blue: 0.7)
        case .auto: return Color(UIColor.secondaryLabel)
        }
    }
    
    var textLight: Color {
        return Color.white
    }
    
    var accentGreen: Color {
        return Color(red: 0.3, green: 0.8, blue: 0.5)
    }
    
    var accentPurple: Color {
        return Color(red: 0.6, green: 0.4, blue: 0.9)
    }
    
    var accentPink: Color {
        return Color(red: 1.0, green: 0.4, blue: 0.7)
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundWhite, backgroundBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [backgroundWhite.opacity(0.8), backgroundWhite.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var buttonGradient: LinearGradient {
        LinearGradient(
            colors: [primaryOrange, primaryOrange.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primaryBlue, primaryBlue.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private init() {
        loadSettings()
    }
    
    private func loadSettings() {
        let userDefaults = UserDefaults.standard
        let schemeKey = "selected_color_scheme"
        let accentKey = "selected_accent_color"
        
        if let schemeRaw = userDefaults.string(forKey: schemeKey),
           let scheme = ThemeManager.ColorScheme(rawValue: schemeRaw) {
            selectedScheme = scheme
        }
        
        if let accentRaw = userDefaults.string(forKey: accentKey),
           let accent = ThemeManager.AccentColor(rawValue: accentRaw) {
            selectedAccent = accent
        }
    }
    
    func saveSettings() {
        let userDefaults = UserDefaults.standard
        let schemeKey = "selected_color_scheme"
        let accentKey = "selected_accent_color"
        
        userDefaults.set(selectedScheme.rawValue, forKey: schemeKey)
        userDefaults.set(selectedAccent.rawValue, forKey: accentKey)
    }
}
