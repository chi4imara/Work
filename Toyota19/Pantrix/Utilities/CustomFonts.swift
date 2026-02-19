import SwiftUI

struct AppFonts {
    static func regular(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Medium", size: size)
    }
    
    static func light(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Light", size: size)
    }
    
    static func bold(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Bold", size: size)
    }
    
    static func semiBold(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-MediumItalic", size: size)
    }
    
    static let largeTitle = bold(size: 34)
    static let title = bold(size: 28)
    static let title2 = bold(size: 22)
    static let title3 = semiBold(size: 20)
    static let headline = semiBold(size: 17)
    static let body = regular(size: 17)
    static let callout = regular(size: 16)
    static let subheadline = regular(size: 15)
    static let footnote = regular(size: 13)
    static let caption = regular(size: 12)
    static let caption2 = regular(size: 11)
}

extension Font {
    static let appLargeTitle = AppFonts.largeTitle
    static let appTitle = AppFonts.title
    static let appTitle2 = AppFonts.title2
    static let appTitle3 = AppFonts.title3
    static let appHeadline = AppFonts.headline
    static let appBody = AppFonts.body
    static let appCallout = AppFonts.callout
    static let appSubheadline = AppFonts.subheadline
    static let appFootnote = AppFonts.footnote
    static let appCaption = AppFonts.caption
    static let appCaption2 = AppFonts.caption2
}
