import SwiftUI

struct AppFonts {
    static let primaryFontName = "Avenir"
    static let secondaryFontName = "Avenir-Medium"
    static let boldFontName = "Avenir-Heavy"
    
    static let largeTitle = Font.custom(boldFontName, size: 34)
    static let title1 = Font.custom(boldFontName, size: 24)
    static let title2 = Font.custom(secondaryFontName, size: 22)
    static let title3 = Font.custom(secondaryFontName, size: 17)
    static let headline = Font.custom(secondaryFontName, size: 17)
    static let body = Font.custom(primaryFontName, size: 12)
    static let callout = Font.custom(primaryFontName, size: 16)
    static let subheadline = Font.custom(primaryFontName, size: 15)
    static let footnote = Font.custom(primaryFontName, size: 13)
    static let caption1 = Font.custom(primaryFontName, size: 12)
    static let caption2 = Font.custom(primaryFontName, size: 11)
}

extension Font {
    static let appLargeTitle = AppFonts.largeTitle
    static let appTitle1 = AppFonts.title1
    static let appTitle2 = AppFonts.title2
    static let appTitle3 = AppFonts.title3
    static let appHeadline = AppFonts.headline
    static let appBody = AppFonts.body
    static let appCallout = AppFonts.callout
    static let appSubheadline = AppFonts.subheadline
    static let appFootnote = AppFonts.footnote
    static let appCaption1 = AppFonts.caption1
    static let appCaption2 = AppFonts.caption2
}
