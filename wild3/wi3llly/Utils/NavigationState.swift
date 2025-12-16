import Foundation
import SwiftUI
import Combine

class NavigationState: ObservableObject {
    static let shared = NavigationState()
    
    @Published var selectedTagForFilter: String? = nil
    @Published var shouldNavigateToDreams = false
    
    private init() {}
    
    func filterByTag(_ tagName: String) {
        selectedTagForFilter = tagName
        shouldNavigateToDreams = true
    }
    
    func clearFilter() {
        selectedTagForFilter = nil
        shouldNavigateToDreams = false
    }
}
