import SwiftUI

struct LocalStorage {
    static let shared = LocalStorage()
    
    @AppStorage("APP_STRUCT_TEXT") var text = ""
    @AppStorage("FIRST_LAUNCH") var isFirstLaunch = true
}

enum ViewState: Equatable {
    case main, sub
}

