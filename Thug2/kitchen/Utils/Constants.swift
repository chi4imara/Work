import Foundation
import SwiftUI

struct AppConstants {
    static let appName = "Interior Ideas"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "16.0"
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 50
        static let tabBarHeight: CGFloat = 83
        static let headerHeight: CGFloat = 60
        
        struct Padding {
            static let small: CGFloat = 8
            static let medium: CGFloat = 16
            static let large: CGFloat = 20
            static let extraLarge: CGFloat = 24
        }
        
        struct Spacing {
            static let small: CGFloat = 8
            static let medium: CGFloat = 16
            static let large: CGFloat = 24
            static let extraLarge: CGFloat = 32
        }
    }
    
    struct TextLimits {
        static let ideaTitleMaxLength = 100
        static let ideaNoteMaxLength = 1000
        static let searchMaxLength = 50
    }
    
    struct UserDefaultsKeys {
        static let savedIdeas = "SavedInteriorIdeas"
        static let filterSettings = "FilterSettings"
        static let isFirstLaunch = "IsFirstLaunch"
        static let appVersion = "AppVersion"
        static let lastOpenDate = "LastOpenDate"
    }
    
    struct URLs {
        static let termsOfUse = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let licenseAgreement = "https://google.com"
        static let appStore = "https://apps.apple.com/app/id"
    }
    
    struct SystemImages {
        static let house = "house"
        static let houseFill = "house.fill"
        static let star = "star"
        static let starFill = "star.fill"
        static let chart = "chart.bar"
        static let chartFill = "chart.bar.fill"
        static let gear = "gearshape"
        static let gearFill = "gearshape.fill"
        static let plus = "plus.circle.fill"
        static let pencil = "pencil"
        static let trash = "trash"
        static let filter = "line.3.horizontal.decrease.circle"
        static let search = "magnifyingglass"
        static let checkmark = "checkmark"
        static let xmark = "xmark"
        static let chevronDown = "chevron.down"
        static let chevronRight = "chevron.right"
        static let arrowRight = "arrow.right"
        static let clock = "clock"
        static let calendar = "calendar"
        static let envelope = "envelope"
        static let lock = "lock.shield"
        static let doc = "doc.text"
        static let lightbulb = "lightbulb.fill"
        static let folder = "folder.fill"
    }
    
    struct SampleData {
        static let sampleIdeas: [InteriorIdea] = [
            InteriorIdea(
                title: "Modern Living Room",
                category: .livingRoom,
                note: "Minimalist design with neutral colors, comfortable sectional sofa, and ambient lighting.",
                isFavorite: true
            ),
            InteriorIdea(
                title: "Scandinavian Kitchen",
                category: .kitchen,
                note: "White cabinets, wooden countertops, and plenty of natural light.",
                isFavorite: false
            ),
            InteriorIdea(
                title: "Cozy Bedroom",
                category: .bedroom,
                note: "Warm colors, soft textures, and reading nook by the window.",
                isFavorite: true
            ),
            InteriorIdea(
                title: "Spa-like Bathroom",
                category: .bathroom,
                note: "Natural stone, plants, and rainfall shower for a relaxing atmosphere.",
                isFavorite: false
            ),
            InteriorIdea(
                title: "Welcoming Hallway",
                category: .hallway,
                note: "Gallery wall, console table, and statement mirror.",
                isFavorite: false
            )
        ]
    }
}

struct AppEnvironment {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
