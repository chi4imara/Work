import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var selectedScheme: ColorScheme = .light {
        didSet {
            saveSettings()
        }
    }
    @Published var selectedAccent: AccentColor = .orange {
        didSet {
            saveSettings()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let schemeKey = "selected_color_scheme"
    private let accentKey = "selected_accent_color"
    
    private init() {
        loadSettings()
    }
    
    private func loadSettings() {
        if let schemeRaw = userDefaults.string(forKey: schemeKey),
           let scheme = ColorScheme(rawValue: schemeRaw) {
            selectedScheme = scheme
        }
        
        if let accentRaw = userDefaults.string(forKey: accentKey),
           let accent = AccentColor(rawValue: accentRaw) {
            selectedAccent = accent
        }
        
        AppColors.shared.selectedScheme = selectedScheme
        AppColors.shared.selectedAccent = selectedAccent
    }
    
    func saveSettings() {
        userDefaults.set(selectedScheme.rawValue, forKey: schemeKey)
        userDefaults.set(selectedAccent.rawValue, forKey: accentKey)
        
        AppColors.shared.selectedScheme = selectedScheme
        AppColors.shared.selectedAccent = selectedAccent
        AppColors.shared.saveSettings()
    }
    
    enum ColorScheme: String, CaseIterable {
        case light = "light"
        case dark = "dark"
        case auto = "auto"
        
        var displayName: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .auto: return "Auto"
            }
        }
        
        var description: String {
            switch self {
            case .light: return "Always use light theme"
            case .dark: return "Always use dark theme"
            case .auto: return "Follow system setting"
            }
        }
    }
    
    enum AccentColor: String, CaseIterable {
        case orange = "orange"
        case blue = "blue"
        case green = "green"
        case purple = "purple"
        case pink = "pink"
        case red = "red"
        
        var displayName: String {
            switch self {
            case .orange: return "Orange"
            case .blue: return "Blue"
            case .green: return "Green"
            case .purple: return "Purple"
            case .pink: return "Pink"
            case .red: return "Red"
            }
        }
        
        var color: Color {
            switch self {
            case .orange: return Color(red: 1.0, green: 0.6, blue: 0.2)
            case .blue: return Color(red: 0.4, green: 0.7, blue: 1.0)
            case .green: return Color(red: 0.3, green: 0.8, blue: 0.5)
            case .purple: return Color(red: 0.6, green: 0.4, blue: 0.9)
            case .pink: return Color(red: 1.0, green: 0.4, blue: 0.7)
            case .red: return .red
            }
        }
    }
}
