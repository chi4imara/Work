import Foundation

struct AppStatistics: Codable {
    var wheelSpins: Int
    var themesGenerated: Int
    var favoritesAdded: Int
    
    init() {
        self.wheelSpins = 0
        self.themesGenerated = 0
        self.favoritesAdded = 0
    }
    
    var totalActions: Int {
        return wheelSpins + themesGenerated + favoritesAdded
    }
    
    var hasData: Bool {
        return totalActions > 0
    }
}
