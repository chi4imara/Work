import Foundation

enum SheetIdentifier: Identifiable {
    case gratitudeEntry(date: Date)
    case gratitudeDetail(date: Date)
    case menu
    case editEntry(date: Date)
    
    var id: String {
        switch self {
        case .gratitudeEntry(let date):
            return "gratitudeEntry_\(date.timeIntervalSince1970)"
        case .gratitudeDetail(let date):
            return "gratitudeDetail_\(date.timeIntervalSince1970)"
        case .menu:
            return "menu"
        case .editEntry(let date):
            return "editEntry_\(date.timeIntervalSince1970)"
        }
    }
}
