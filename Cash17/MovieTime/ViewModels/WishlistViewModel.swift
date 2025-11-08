import Foundation
import SwiftUI

class WishlistViewModel: ObservableObject {
    @Published var wishlistMovies: [WishlistMovie] = []
    @Published var isLoading = false
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadWishlistMovies()
    }
    
    func loadWishlistMovies() {
        isLoading = true
        wishlistMovies = coreDataManager.fetchWishlistMovies()
        isLoading = false
    }
    
    func addWishlistMovie(title: String, genre: String?, note: String?, isPriority: Bool) {
        let _ = coreDataManager.createWishlistMovie(
            title: title,
            genre: genre,
            note: note,
            isPriority: isPriority
        )
        loadWishlistMovies()
    }
    
    func updateWishlistMovie(_ movie: WishlistMovie, title: String, genre: String?, note: String?, isPriority: Bool) {
        movie.title = title
        movie.genre = genre
        movie.note = note
        movie.isPriority = isPriority
        movie.updatedAt = Date()
        coreDataManager.save()
        loadWishlistMovies()
    }
    
    func togglePriority(_ movie: WishlistMovie) {
        movie.isPriority.toggle()
        movie.updatedAt = Date()
        coreDataManager.save()
        loadWishlistMovies()
    }
    
    func deleteWishlistMovie(_ movie: WishlistMovie) {
        coreDataManager.deleteWishlistMovie(movie)
        loadWishlistMovies()
    }
    
    var priorityMovies: [WishlistMovie] {
        return wishlistMovies.filter { $0.isPriority }
    }
    
    var regularMovies: [WishlistMovie] {
        return wishlistMovies.filter { !$0.isPriority }
    }
}
