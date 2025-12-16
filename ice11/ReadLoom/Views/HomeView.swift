import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = BooksViewModel()
    @State private var showingDeleteAllAlert = false
    @State private var navigateToSearch = false
    @State private var navigateToStats = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("My Books")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                withAnimation {
                                    selectedTab = 2
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(AppColors.cardBackground)
                                    )
                            }
                            
                            Button(action: {
                                viewModel.showingMenu = true
                            }) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(AppColors.cardBackground)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if viewModel.books.isEmpty {
                        EmptyBooksView(selectedTab: $selectedTab)
                    } else {
                        BookListView(books: viewModel.books) { book in
                            viewModel.selectedBook = book
                        } onDelete: { book in
                            viewModel.deleteBook(book)
                        } onEdit: { book in
                            viewModel.selectedBook = book
                            viewModel.showingAddBook = true
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.showingAddBook) {
            AddEditBookView(
                book: viewModel.selectedBook,
                onSave: { title, author, totalPages in
                    if let book = viewModel.selectedBook {
                        viewModel.updateBook(book, title: title, author: author, totalPages: totalPages)
                    } else {
                        viewModel.addBook(title: title, author: author, totalPages: totalPages)
                    }
                    viewModel.selectedBook = nil
                }
            )
        }
        .sheet(item: $viewModel.selectedBook) { book in
            BookDetailView(bookId: book.id, onAddProgress: { pages in
                viewModel.addReadingProgress(to: book, pages: pages)
            }, viewModel: viewModel)
        }
        .onChange(of: viewModel.selectedBook) { book in
            if book == nil {
                viewModel.loadBooks()
            }
        }
        .actionSheet(isPresented: $viewModel.showingMenu) {
            ActionSheet(
                title: Text("Menu"),
                buttons: [
                    .default(Text("Search Books")) {
                        withAnimation {
                            selectedTab = 1
                        }
                    },
                    .default(Text("Statistics")) {
                        withAnimation {
                            selectedTab = 3
                        }
                    },
                    .destructive(Text("Clear All Books")) {
                        showingDeleteAllAlert = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $navigateToSearch) {
            SearchView()
        }
        .sheet(isPresented: $navigateToStats) {
            StatisticsView(selectedTab: $selectedTab)
        }
        .alert("Clear All Books", isPresented: $showingDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                viewModel.deleteAllBooks()
            }
        } message: {
            Text("Are you sure you want to delete all books? This action cannot be undone.")
        }
        .onAppear {
            viewModel.loadBooks()
        }
    }
}

struct EmptyBooksView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 12) {
                Text("You haven't added any books yet")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start your reading journey by adding your first book")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 2
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add First Book")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.primaryYellow)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct BookListView: View {
    let books: [BookModel]
    let onSelect: (BookModel) -> Void
    let onDelete: (BookModel) -> Void
    let onEdit: (BookModel) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(books) { book in
                    BookCardView(
                        book: book,
                        onTap: { onSelect(book) },
                        onDelete: { onDelete(book) },
                        onEdit: { onEdit(book) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct BookCardView: View {
    let book: BookModel
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if offset.width > 0 {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.success)
                }
                
                if offset.width < 0 {
                    HStack {
                        Spacer()
                        Image(systemName: "trash")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.error)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        if let author = book.author, !author.isEmpty {
                            Text(author)
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(book.progressText)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.accentText)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(AppColors.primaryText.opacity(0.2))
                                    .frame(height: 6)
                                    .cornerRadius(3)
                                
                                Rectangle()
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: geometry.size.width * (book.progressPercentage / 100), height: 6)
                                    .cornerRadius(3)
                            }
                        }
                        .frame(height: 6)
                        
                        HStack {
                            Text(book.statusText)
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(book.isCompleted ? AppColors.success : AppColors.primaryYellow)
                            
                            Spacer()
                            
                            Text("\(Int(book.progressPercentage))%")
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(AppColors.accentText)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.cardBackground)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: offset.width, y: 0)
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    offset = value.translation
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if value.translation.width < -100 {
                            showingDeleteAlert = true
                        } else if value.translation.width > 100 {
                            onEdit()
                        }
                        offset = .zero
                    }
                }
        )
        .alert("Delete Book", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this book and all reading progress?")
        }
    }
}
