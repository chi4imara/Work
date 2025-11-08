import SwiftUI
import UIKit

struct AppFonts {
    static let nunitoRegular = "Nunito-Regular"
    static let nunitoMedium = "Nunito-Medium"
    static let nunitoSemiBold = "Nunito-SemiBold"
    static let nunitoBold = "Nunito-Bold"
    
    static func regular(size: CGFloat) -> Font {
        if FontHelper.shared.isFontAvailable(nunitoRegular) {
            return Font.custom(nunitoRegular, size: size)
        }
        return Font.system(size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        if FontHelper.shared.isFontAvailable(nunitoMedium) {
            return Font.custom(nunitoMedium, size: size)
        }
        return Font.system(size: size, weight: .medium)
    }
    
    static func semiBold(size: CGFloat) -> Font {
        if FontHelper.shared.isFontAvailable(nunitoSemiBold) {
            return Font.custom(nunitoSemiBold, size: size)
        }
        return Font.system(size: size, weight: .semibold)
    }
    
    static func bold(size: CGFloat) -> Font {
        if FontHelper.shared.isFontAvailable(nunitoBold) {
            return Font.custom(nunitoBold, size: size)
        }
        return Font.system(size: size, weight: .bold)
    }
    
    static let largeTitle = bold(size: 34)
    static let title1 = bold(size: 28)
    static let title2 = bold(size: 22)
    static let title3 = semiBold(size: 20)
    static let headline = semiBold(size: 17)
    static let body = regular(size: 17)
    static let callout = regular(size: 16)
    static let subheadline = regular(size: 15)
    static let footnote = regular(size: 13)
    static let caption1 = regular(size: 12)
    static let caption2 = regular(size: 11)
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
