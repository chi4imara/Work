import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var bookStore: BookStore
    @State private var showingAddBook = false
    @State private var showingClearConfirmation = false
    @State private var selectedBooks: Set<UUID> = []
    @State private var isSelectionMode = false
    
    let onBookSelected: ((Book) -> Void)?
    
    init(onBookSelected: ((Book) -> Void)? = nil) {
        self.onBookSelected = onBookSelected
    }
    
    var body: some View {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if bookStore.wantToReadBooks.isEmpty {
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
        .alert("Clear Wishlist", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                let wishlistBooks = bookStore.wantToReadBooks
                bookStore.deleteBooks(wishlistBooks)
            }
        } message: {
            Text("Are you sure you want to remove all books from your wishlist? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Want to Read")
                .font(FontManager.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !bookStore.wantToReadBooks.isEmpty {
                Button(action: {
                    showingClearConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.destructiveColor)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(AppColors.cardBackground)
                                .shadow(color: AppColors.destructiveColor.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(BackgroundView())
    }
    
    private var bookListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bookStore.wantToReadBooks) { book in
                    WishlistBookCardView(
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
                        onStartReading: {
                            bookStore.startReading(book)
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
            
            Image(systemName: "star")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text("Your wishlist is empty")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add books you want to read later")
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
                    
                    HStack(spacing: 12) {
                        Button("Start Reading") {
                            let booksToUpdate = bookStore.books.filter { selectedBooks.contains($0.id) }
                            booksToUpdate.forEach { bookStore.startReading($0) }
                            isSelectionMode = false
                            selectedBooks.removeAll()
                        }
                        .font(FontManager.buttonText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.completedColor)
                        )
                        
                        Button("Delete (\(selectedBooks.count))") {
                            let booksToDelete = bookStore.books.filter { selectedBooks.contains($0.id) }
                            bookStore.deleteBooks(booksToDelete)
                            isSelectionMode = false
                            selectedBooks.removeAll()
                        }
                        .font(FontManager.buttonText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.destructiveColor)
                        )
                    }
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

struct WishlistBookCardView: View {
    let book: Book
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onStartReading: () -> Void
    let onDelete: () -> Void
    let onLongPress: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    @State private var showingStartReadingConfirmation = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                       RoundedRectangle(cornerRadius: 16)
                           .stroke(
                               LinearGradient(
                                colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing
                               ),
                               lineWidth: 2
                           )
                   )
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            
            if isSelectionMode {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? AppColors.primaryBlue : AppColors.lightBlue, lineWidth: 2)
            }
            
            HStack(spacing: 16) {
                if isSelectionMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(FontManager.cardTitle)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        if let author = book.author, !author.isEmpty {
                            Text(author)
                                .font(FontManager.cardSubtitle)
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(1)
                        }
                    }
                    
                    HStack {
                        Text("Added \(book.dateAdded, style: .date)")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        if !isSelectionMode {
                            Button(action: {
                                showingStartReadingConfirmation = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 12))
                                    Text("Start Reading")
                                        .font(FontManager.caption)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.completedColor)
                                )
                            }
                        }
                    }
                }
                
                if !isSelectionMode {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
        }
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .onTapGesture {
            onTap()
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .alert("Start Reading", isPresented: $showingStartReadingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Start Reading") {
                onStartReading()
            }
        } message: {
            Text("Move '\(book.title)' to your currently reading list?")
        }
        .alert("Delete Book", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to remove '\(book.title)' from your wishlist?")
        }
    }
}
