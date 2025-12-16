import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var booksViewModel = BooksViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search Books")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.secondaryText)
                    
                    TextField("Enter title or author...", text: $searchText)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .onChange(of: searchText) { newValue in
                            viewModel.searchBooks(query: newValue)
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if searchText.isEmpty {
                    EmptySearchView()
                } else if viewModel.searchResults.isEmpty {
                    NoResultsView()
                } else {
                    SearchResultsView(
                        books: viewModel.searchResults,
                        onSelect: { book in
                            viewModel.selectedBook = book
                        }
                    )
                }
            }
        }
        .sheet(item: $viewModel.selectedBook) { book in
            BookDetailView(bookId: book.id, onAddProgress: { pages in
                booksViewModel.addReadingProgress(to: book, pages: pages)
                viewModel.searchBooks(query: searchText)
            }, viewModel: booksViewModel)
        }
    }
}

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            Text("Start typing to search")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Text("Search by book title or author name")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            Text("No matches found")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Text("Try searching with different keywords")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct SearchResultsView: View {
    let books: [BookModel]
    let onSelect: (BookModel) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(books) { book in
                    SearchResultCard(book: book) {
                        onSelect(book)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct SearchResultCard: View {
    let book: BookModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    if let author = book.author, !author.isEmpty {
                        Text(author)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                HStack {
                    Text(book.progressText)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.accentText)
                    
                    Spacer()
                    
                    Text(book.statusText)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(book.isCompleted ? AppColors.success : AppColors.primaryYellow)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(AppColors.primaryText.opacity(0.2))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: geometry.size.width * (book.progressPercentage / 100), height: 4)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

class SearchViewModel: ObservableObject {
    @Published var searchResults: [BookModel] = []
    @Published var selectedBook: BookModel?
    
    private let userDefaultsManager = UserDefaultsManager.shared
    
    func searchBooks(query: String) {
        searchResults = userDefaultsManager.searchBooks(query: query)
    }
    
    func clearSearch() {
        searchResults = []
    }
    
    func addReadingProgress(to book: BookModel, pages: Int32) {
        userDefaultsManager.addReadingProgress(to: book.id, pagesRead: pages)
        searchBooks(query: "")
    }
}

#Preview {
    SearchView()
}
