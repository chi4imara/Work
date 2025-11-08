import SwiftUI

extension Font {
    static let largeTitle = Font.custom("Poppins-Bold", size: 34)
    static let title1 = Font.custom("Poppins-Bold", size: 28)
    static let title2 = Font.custom("Poppins-Bold", size: 22)
    static let title3 = Font.custom("Poppins-SemiBold", size: 20)
    
    static let headline = Font.custom("Poppins-SemiBold", size: 17)
    static let body = Font.custom("Poppins-Regular", size: 17)
    static let callout = Font.custom("Poppins-Regular", size: 16)
    static let subheadline = Font.custom("Poppins-Regular", size: 15)
    static let footnote = Font.custom("Poppins-Regular", size: 13)
    static let caption1 = Font.custom("Poppins-Regular", size: 12)
    static let caption2 = Font.custom("Poppins-Regular", size: 11)
    
    static let appTitle = Font.custom("Poppins-Bold", size: 24)
    static let cardTitle = Font.custom("Poppins-SemiBold", size: 18)
    static let cardSubtitle = Font.custom("Poppins-Regular", size: 14)
    static let buttonText = Font.custom("Poppins-SemiBold", size: 16)
    static let tabBarText = Font.custom("Poppins-Medium", size: 8)
}

struct FontModifiers {
    static func customTitle() -> some ViewModifier {
        return CustomTitleModifier()
    }
    
    static func cardTitle() -> some ViewModifier {
        return CardTitleModifier()
    }
    
    static func bodyText() -> some ViewModifier {
        return BodyTextModifier()
    }
}

struct CustomTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.appTitle)
            .foregroundColor(.primaryText)
    }
}

struct CardTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.cardTitle)
            .foregroundColor(.primaryText)
    }
}

struct BodyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(.primaryText)
    }
}

extension View {
    func customTitle() -> some View {
        self.modifier(CustomTitleModifier())
    }
    
    func cardTitle() -> some View {
        self.modifier(CardTitleModifier())
    }
    
    func bodyText() -> some View {
        self.modifier(BodyTextModifier())
    }
}
