import Foundation
import Combine

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    private let booksKey = "SavedBooks"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func createBook(title: String, author: String?, totalPages: Int32) -> BookModel {
        var books = fetchBooks()
        let newBook = BookModel(title: title, author: author, totalPages: totalPages)
        books.append(newBook)
        saveBooks(books)
        return newBook
    }
    
    func updateBook(_ bookId: UUID, title: String, author: String?, totalPages: Int32) {
        var books = fetchBooks()
        
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].title = title
            books[index].author = author
            books[index].totalPages = totalPages
            
            if books[index].currentPages >= totalPages {
                books[index].isCompleted = true
                if books[index].dateCompleted == nil {
                    books[index].dateCompleted = Date()
                }
            } else {
                books[index].isCompleted = false
                books[index].dateCompleted = nil
            }
            
            saveBooks(books)
        }
    }
    
    func deleteBook(_ bookId: UUID) {
        var books = fetchBooks()
        books.removeAll { $0.id == bookId }
        saveBooks(books)
    }
    
    func addReadingProgress(to bookId: UUID, pagesRead: Int32) {
        var books = fetchBooks()
        
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            let progress = ReadingProgressModel(pagesRead: pagesRead)
            books[index].readingProgress.append(progress)
            
            let newCurrentPages = books[index].currentPages + pagesRead
            let maxPages = min(newCurrentPages, books[index].totalPages)
            books[index].currentPages = maxPages
            
            if books[index].currentPages >= books[index].totalPages {
                books[index].isCompleted = true
                if books[index].dateCompleted == nil {
                    books[index].dateCompleted = Date()
                }
            }
            
            saveBooks(books)
        }
    }
    
    func fetchBooks() -> [BookModel] {
        guard let data = userDefaults.data(forKey: booksKey) else {
            return []
        }
        
        do {
            let books = try JSONDecoder().decode([BookModel].self, from: data)
            return books.sorted { $0.dateAdded > $1.dateAdded }
        } catch {
            print("Failed to decode books: \(error)")
            return []
        }
    }
    
    func searchBooks(query: String) -> [BookModel] {
        let books = fetchBooks()
        
        if query.isEmpty {
            return books
        }
        
        return books.filter { book in
            book.title.localizedCaseInsensitiveContains(query) ||
            (book.author?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }
    
    func deleteAllBooks() {
        userDefaults.removeObject(forKey: booksKey)
    }
    
    private func saveBooks(_ books: [BookModel]) {
        do {
            let data = try JSONEncoder().encode(books)
            userDefaults.set(data, forKey: booksKey)
        } catch {
            print("Failed to encode books: \(error)")
        }
    }
    
    func getStatistics() -> BookStatistics {
        let books = fetchBooks()
        let completedBooks = books.filter { $0.isCompleted }
        
        let totalPagesRead = books.reduce(0) { $0 + Int($1.currentPages) }
        
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentProgress = getRecentReadingProgress(since: thirtyDaysAgo, from: books)
        let recentPagesRead = recentProgress.reduce(0) { $0 + Int($1.pagesRead) }
        let averagePagesPerDay = recentPagesRead / 30
        
        let dailyTotals = Dictionary(grouping: recentProgress) { progress in
            Calendar.current.startOfDay(for: progress.date)
        }.mapValues { progressArray in
            progressArray.reduce(0) { $0 + Int($1.pagesRead) }
        }
        
        let recordPagesPerDay = dailyTotals.values.max() ?? 0
        
        return BookStatistics(
            totalBooks: books.count,
            completedBooks: completedBooks.count,
            totalPagesRead: totalPagesRead,
            averagePagesPerDay: averagePagesPerDay,
            recordPagesPerDay: recordPagesPerDay,
            completedBooksList: completedBooks
        )
    }
    
    private func getRecentReadingProgress(since date: Date, from books: [BookModel]) -> [ReadingProgressModel] {
        var allProgress: [ReadingProgressModel] = []
        
        for book in books {
            let recentProgress = book.readingProgress.filter { $0.date >= date }
            allProgress.append(contentsOf: recentProgress)
        }
        
        return allProgress
    }
}

struct BookStatistics {
    let totalBooks: Int
    let completedBooks: Int
    let totalPagesRead: Int
    let averagePagesPerDay: Int
    let recordPagesPerDay: Int
    let completedBooksList: [BookModel]
}
