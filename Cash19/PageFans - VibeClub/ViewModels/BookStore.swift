import Foundation
import SwiftUI

class BookStore: ObservableObject {
    @Published var books: [Book] = []
    @Published var selectedFilter: BookStatus? = nil
    
    private let userDefaults = UserDefaults.standard
    private let booksKey = "SavedBooks"
    
    init() {
        loadBooks()
    }
    
    func addBook(_ book: Book) {
        books.append(book)
        saveBooks()
    }
    
    func updateBook(_ book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
            saveBooks()
        }
    }
    
    func deleteBook(_ book: Book) {
        books.removeAll { $0.id == book.id }
        saveBooks()
    }
    
    func deleteBooks(_ booksToDelete: [Book]) {
        let idsToDelete = Set(booksToDelete.map { $0.id })
        books.removeAll { idsToDelete.contains($0.id) }
        saveBooks()
    }
    
    func clearAllBooks() {
        books.removeAll()
        saveBooks()
    }
    
    var filteredBooks: [Book] {
        let filtered = selectedFilter == nil ? books : books.filter { $0.status == selectedFilter }
        return filtered.sorted { $0.lastModified > $1.lastModified }
    }
    
    var readingBooks: [Book] {
        books.filter { $0.status == .reading }
            .sorted { $0.lastModified > $1.lastModified }
    }
    
    var completedBooks: [Book] {
        books.filter { $0.status == .completed }
            .sorted { $0.dateCompleted ?? Date.distantPast > $1.dateCompleted ?? Date.distantPast }
    }
    
    var wantToReadBooks: [Book] {
        books.filter { $0.status == .wantToRead }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func setFilter(_ status: BookStatus?) {
        selectedFilter = status
    }
    
    func clearFilters() {
        selectedFilter = nil
    }
    
    func startReading(_ book: Book) {
        var updatedBook = book
        updatedBook.updateStatus(.reading)
        updateBook(updatedBook)
    }
    
    func markAsCompleted(_ book: Book, rating: Int? = nil) {
        var updatedBook = book
        updatedBook.updateStatus(.completed)
        updatedBook.rating = rating
        updateBook(updatedBook)
    }
    
    func moveToWantToRead(_ book: Book) {
        var updatedBook = book
        updatedBook.updateStatus(.wantToRead)
        updateBook(updatedBook)
    }
    
    private func saveBooks() {
        if let encoded = try? JSONEncoder().encode(books) {
            userDefaults.set(encoded, forKey: booksKey)
        }
    }
    
    private func loadBooks() {
        if let data = userDefaults.data(forKey: booksKey),
           let decoded = try? JSONDecoder().decode([Book].self, from: data) {
            books = decoded
        }
    }
}
