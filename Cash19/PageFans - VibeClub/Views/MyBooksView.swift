import SwiftUI

struct MyBooksView: View {
    @EnvironmentObject var bookStore: BookStore
    @State private var showingAddBook = false
    @State private var showingFilterMenu = false
    @State private var showingClearConfirmation = false
    @State private var selectedBooks: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var bookToEdit: Book?
    @State private var showingEditBook = false
    
    let onBookSelected: ((Book) -> Void)?
    
    init(onBookSelected: ((Book) -> Void)? = nil) {
        self.onBookSelected = onBookSelected
    }
    
    var body: some View {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if bookStore.filteredBooks.isEmpty {
                        emptyStateView
                    } else {
                        bookListView
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingAddBook = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(AppColors.primaryBlue)
                                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 110)
                    }
                }
            }
        .sheet(isPresented: $showingAddBook) {
            AddEditBookView(bookStore: bookStore)
        }
        .sheet(isPresented: $showingEditBook) {
            if let book = bookToEdit {
                AddEditBookView(bookToEdit: book, bookStore: bookStore)
            }
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
        .alert("Clear All Books", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                bookStore.clearAllBooks()
            }
        } message: {
            Text("Are you sure you want to delete all books? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Books")
                .font(FontManager.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingFilterMenu = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppColors.cardBackground)
                            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(BackgroundView())
    }
    
    private var bookListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bookStore.filteredBooks) { book in
                    BookCardView(
                        book: book,
                        isSelected: selectedBooks.contains(book.id),
                        isSelectionMode: isSelectionMode,
                        onTap: {
                            if isSelectionMode {
                                toggleSelection(book.id)
                            } else {
                                onBookSelected?(book)
                            }
                        },
                        onEdit: {
                            bookToEdit = book
                            showingEditBook = true
                        },
                        onDelete: {
                            bookStore.deleteBook(book)
                        },
                        onLongPress: {
                            if !isSelectionMode {
                                isSelectionMode = true
                                selectedBooks.insert(book.id)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
        .overlay(
            selectionBottomBar,
            alignment: .bottom
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text("Your books will appear here")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start building your reading library")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddBook = true
            }) {
                Text("Add Your First Book")
                    .font(FontManager.buttonText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.primaryBlue)
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var selectionBottomBar: some View {
        Group {
            if isSelectionMode && !selectedBooks.isEmpty {
                HStack {
                    Button("Cancel") {
                        isSelectionMode = false
                        selectedBooks.removeAll()
                    }
                    .font(FontManager.buttonText)
                    .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                    
                    Button("Delete Selected (\(selectedBooks.count))") {
                        let booksToDelete = bookStore.books.filter { selectedBooks.contains($0.id) }
                        bookStore.deleteBooks(booksToDelete)
                        isSelectionMode = false
                        selectedBooks.removeAll()
                    }
                    .font(FontManager.buttonText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.destructiveColor)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var filterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Filter Options"),
            buttons: [
                .default(Text("All Books")) {
                    bookStore.setFilter(nil)
                },
                .default(Text("Currently Reading")) {
                    bookStore.setFilter(.reading)
                },
                .default(Text("Completed")) {
                    bookStore.setFilter(.completed)
                },
                .default(Text("Want to Read")) {
                    bookStore.setFilter(.wantToRead)
                },
                .default(Text("Clear Filters")) {
                    bookStore.clearFilters()
                },
                .destructive(Text("Clear All Books")) {
                    showingClearConfirmation = true
                },
                .cancel()
            ]
        )
    }
    
    private func toggleSelection(_ bookId: UUID) {
        if selectedBooks.contains(bookId) {
            selectedBooks.remove(bookId)
        } else {
            selectedBooks.insert(bookId)
        }
        
        if selectedBooks.isEmpty {
            isSelectionMode = false
        }
    }
}
