import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
    
    func createMovie(title: String, genre: String, watchDate: Date, rating: Int16, review: String?, watchLocation: String?, notes: [String], isFavorite: Bool) -> Movie {
        let movie = Movie(context: context)
        movie.id = UUID()
        movie.title = title
        movie.genre = genre
        movie.watchDate = watchDate
        movie.rating = rating
        movie.review = review
        movie.watchLocation = watchLocation
        movie.notes = notes
        movie.isFavorite = isFavorite
        movie.isArchived = false
        movie.createdAt = Date()
        movie.updatedAt = Date()
        save()
        return movie
    }
    
    func fetchMovies(includeArchived: Bool = false) -> [Movie] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        if !includeArchived {
            request.predicate = NSPredicate(format: "isArchived == NO")
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.watchDate, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func fetchFavoriteMovies() -> [Movie] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES AND isArchived == NO")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.updatedAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func archiveMovie(_ movie: Movie) {
        movie.isArchived = true
        movie.updatedAt = Date()
        save()
    }
    
    func deleteMovie(_ movie: Movie) {
        context.delete(movie)
        save()
    }
    
    func createWishlistMovie(title: String, genre: String?, note: String?, isPriority: Bool) -> WishlistMovie {
        let wishlistMovie = WishlistMovie(context: context)
        wishlistMovie.id = UUID()
        wishlistMovie.title = title
        wishlistMovie.genre = genre
        wishlistMovie.note = note
        wishlistMovie.isPriority = isPriority
        wishlistMovie.createdAt = Date()
        wishlistMovie.updatedAt = Date()
        save()
        return wishlistMovie
    }
    
    func fetchWishlistMovies() -> [WishlistMovie] {
        let request: NSFetchRequest<WishlistMovie> = WishlistMovie.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \WishlistMovie.isPriority, ascending: false),
            NSSortDescriptor(keyPath: \WishlistMovie.title, ascending: true)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func deleteWishlistMovie(_ movie: WishlistMovie) {
        context.delete(movie)
        save()
    }
}
