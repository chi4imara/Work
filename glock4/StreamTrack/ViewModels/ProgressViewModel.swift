import Foundation
import Combine

class ProgressViewModel: ObservableObject {
    @Published var totalCount: Int = 0
    @Published var watchedCount: Int = 0
    @Published var unwatchedCount: Int = 0
    @Published var movieStats: (total: Int, watched: Int) = (0, 0)
    @Published var seriesStats: (total: Int, watched: Int) = (0, 0)
    @Published var recentMovies: [Movie] = []
    @Published var recentSeries: [Movie] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let movieListViewModel: MovieListViewModel
    
    init(movieListViewModel: MovieListViewModel) {
        self.movieListViewModel = movieListViewModel
        setupBindings()
    }
    
    private func setupBindings() {
        movieListViewModel.$movies
            .sink { [weak self] movies in
                self?.updateStats(movies: movies)
            }
            .store(in: &cancellables)
    }
    
    private func updateStats(movies: [Movie]) {
        totalCount = movies.count
        watchedCount = movies.filter { $0.isWatched }.count
        unwatchedCount = totalCount - watchedCount
        
        let moviesList = movies.filter { $0.type == .movie }
        let seriesList = movies.filter { $0.type == .series }
        
        movieStats = (
            total: moviesList.count,
            watched: moviesList.filter { $0.isWatched }.count
        )
        
        seriesStats = (
            total: seriesList.count,
            watched: seriesList.filter { $0.isWatched }.count
        )
        
        let sortedMovies = movies.sorted { $0.createdAt > $1.createdAt }
        recentMovies = Array(sortedMovies.filter { $0.type == .movie }.prefix(20))
        recentSeries = Array(sortedMovies.filter { $0.type == .series }.prefix(20))
    }
    
    var watchedPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(watchedCount) / Double(totalCount)
    }
    
    var movieWatchedPercentage: Double {
        guard movieStats.total > 0 else { return 0 }
        return Double(movieStats.watched) / Double(movieStats.total)
    }
    
    var seriesWatchedPercentage: Double {
        guard seriesStats.total > 0 else { return 0 }
        return Double(seriesStats.watched) / Double(seriesStats.total)
    }
}
