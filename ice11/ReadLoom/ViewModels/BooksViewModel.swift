import Foundation
import Combine

class BooksViewModel: ObservableObject {
    @Published var books: [BookModel] = []
    @Published var isLoading = false
    @Published var showingAddBook = false
    @Published var showingMenu = false
    @Published var selectedBook: BookModel?
    
    private let userDefaultsManager = UserDefaultsManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadBooks()
    }
    
    func loadBooks() {
        isLoading = true
        books = userDefaultsManager.fetchBooks()
        isLoading = false
    }
    
    func addBook(title: String, author: String?, totalPages: Int32) {
        let _ = userDefaultsManager.createBook(title: title, author: author, totalPages: totalPages)
        loadBooks()
    }
    
    func updateBook(_ book: BookModel, title: String, author: String?, totalPages: Int32) {
        userDefaultsManager.updateBook(book.id, title: title, author: author, totalPages: totalPages)
        loadBooks()
    }
    
    func deleteBook(_ book: BookModel) {
        userDefaultsManager.deleteBook(book.id)
        loadBooks()
    }
    
    func deleteAllBooks() {
        userDefaultsManager.deleteAllBooks()
        loadBooks()
    }
    
    func addReadingProgress(to book: BookModel, pages: Int32) {
        userDefaultsManager.addReadingProgress(to: book.id, pagesRead: pages)
        loadBooks()
    }
}
