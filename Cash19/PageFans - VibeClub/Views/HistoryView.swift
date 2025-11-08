import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var bookStore: BookStore
    @State private var showingFilterMenu = false
    @State private var selectedBooks: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var ratingFilter: RatingFilter = .all
    @State private var dateFilter: DateFilter = .all
    
    let onBookSelected: ((Book) -> Void)?
    
    init(onBookSelected: ((Book) -> Void)? = nil) {
        self.onBookSelected = onBookSelected
    }
    
    enum RatingFilter: String, CaseIterable {
        case all = "All Ratings"
        case high = "8+ Stars"
        case medium = "5-7 Stars"
        case low = "Below 5 Stars"
        
        func matches(_ rating: Int?) -> Bool {
            guard let rating = rating else { return self == .all }
            
            switch self {
            case .all:
                return true
            case .high:
                return rating >= 8
            case .medium:
                return rating >= 5 && rating < 8
            case .low:
                return rating < 5
            }
        }
    }
    
    enum DateFilter: String, CaseIterable {
        case all = "All Time"
        case thisMonth = "This Month"
        case thisYear = "This Year"
        case lastYear = "Last Year"
        
        func matches(_ date: Date?) -> Bool {
            guard let date = date else { return self == .all }
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .all:
                return true
            case .thisMonth:
                return calendar.isDate(date, equalTo: now, toGranularity: .month)
            case .thisYear:
                return calendar.isDate(date, equalTo: now, toGranularity: .year)
            case .lastYear:
                let lastYear = calendar.date(byAdding: .year, value: -1, to: now) ?? now
                return calendar.isDate(date, equalTo: lastYear, toGranularity: .year)
            }
        }
    }
    
    private var filteredBooks: [Book] {
        bookStore.completedBooks.filter { book in
            ratingFilter.matches(book.rating) && dateFilter.matches(book.dateCompleted)
        }
    }
    
    var body: some View {
            ZStack(alignment: .top) {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if filteredBooks.isEmpty {
                        emptyStateView
                    } else {
                        bookListView
                    }
                }
            }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Reading History")
                .font(FontManager.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingFilterMenu = true
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
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
                if ratingFilter != .all || dateFilter != .all {
                    activeFiltersView
                }
                
                ForEach(filteredBooks) { book in
                    HistoryBookCardView(
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
    
    private var activeFiltersView: some View {
        HStack {
            if ratingFilter != .all {
                FilterChip(text: ratingFilter.rawValue) {
                    ratingFilter = .all
                }
            }
            
            if dateFilter != .all {
                FilterChip(text: dateFilter.rawValue) {
                    dateFilter = .all
                }
            }
            
            Spacer()
            
            Button("Clear All") {
                ratingFilter = .all
                dateFilter = .all
            }
            .font(FontManager.caption)
            .foregroundColor(AppColors.primaryBlue)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text(bookStore.completedBooks.isEmpty ? "No completed books yet" : "No books match your filters")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text(bookStore.completedBooks.isEmpty ? 
                     "Books you finish will appear here with your ratings and notes" :
                     "Try adjusting your filter settings")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if !bookStore.completedBooks.isEmpty {
                Button("Clear Filters") {
                    ratingFilter = .all
                    dateFilter = .all
                }
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
            title: Text("Filter History"),
            buttons: [
                .default(Text("All Ratings")) { ratingFilter = .all },
                .default(Text("8+ Stars")) { ratingFilter = .high },
                .default(Text("5-7 Stars")) { ratingFilter = .medium },
                .default(Text("Below 5 Stars")) { ratingFilter = .low },
                .default(Text("All Time")) { dateFilter = .all },
                .default(Text("This Month")) { dateFilter = .thisMonth },
                .default(Text("This Year")) { dateFilter = .thisYear },
                .default(Text("Last Year")) { dateFilter = .lastYear },
                .default(Text("Clear Filters")) {
                    ratingFilter = .all
                    dateFilter = .all
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

struct HistoryBookCardView: View {
    let book: Book
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    let onLongPress: () -> Void
    
    @State private var showingDeleteConfirmation = false
    
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
                    HStack {
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
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            if let rating = book.rating {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.warningColor)
                                    Text("\(rating)/10")
                                        .font(FontManager.caption)
                                        .foregroundColor(AppColors.primaryText)
                                }
                            }
                            
                            if let completedDate = book.dateCompleted {
                                Text(completedDate, style: .date)
                                    .font(FontManager.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    
                    if let notes = book.notes, !notes.isEmpty {
                        Text(notes)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                            .padding(.top, 4)
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
        .onLongPressGesture {
            onLongPress()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete", role: .destructive) {
                showingDeleteConfirmation = true
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .alert("Delete Book", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete '\(book.title)'? This action cannot be undone.")
        }
    }
}

struct FilterChip: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(FontManager.caption)
                .foregroundColor(AppColors.primaryBlue)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.lightBlue.opacity(0.2))
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue, lineWidth: 1)
            }
        )
    }
}
