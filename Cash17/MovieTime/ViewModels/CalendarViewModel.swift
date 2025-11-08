import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var currentMonth = Date()
    @Published var moviesForSelectedDate: [Movie] = []
    @Published var moviesByDate: [String: [Movie]] = [:]
    
    private let coreDataManager = CoreDataManager.shared
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init() {
        loadMoviesForMonth()
        loadMoviesForSelectedDate()
    }
    
    func loadMoviesForMonth() {
        let movies = coreDataManager.fetchMovies()
        var moviesByDateDict: [String: [Movie]] = [:]
        
        for movie in movies {
            let dateKey = dateFormatter.string(from: movie.watchDate)
            if moviesByDateDict[dateKey] == nil {
                moviesByDateDict[dateKey] = []
            }
            moviesByDateDict[dateKey]?.append(movie)
        }
        
        moviesByDate = moviesByDateDict
    }
    
    func loadMoviesForSelectedDate() {
        let dateKey = dateFormatter.string(from: selectedDate)
        moviesForSelectedDate = moviesByDate[dateKey] ?? []
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        loadMoviesForSelectedDate()
    }
    
    func moveToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = nextMonth
        }
    }
    
    func moveToPreviousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = previousMonth
        }
    }
    
    func getMovieCount(for date: Date) -> Int {
        let dateKey = dateFormatter.string(from: date)
        return moviesByDate[dateKey]?.count ?? 0
    }
    
    func getDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let lastOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstOfMonth)!
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDaysInMonth = calendar.component(.day, from: lastOfMonth)
        
        var days: [Date] = []
        
        for _ in 1..<firstWeekday {
            days.append(Date.distantPast)
        }
        
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: selectedDate)
    }
}
