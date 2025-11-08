import SwiftUI

struct BookDetailView: View {
    @ObservedObject var bookStore: BookStore
    @Environment(\.presentationMode) var presentationMode
    
    let bookId: UUID
    
    init(book: Book, bookStore: BookStore) {
        self.bookId = book.id
        self.bookStore = bookStore
    }
    
    private var book: Book? {
        bookStore.books.first { $0.id == bookId }
    }
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                if let book = book {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection(book)
                            
                            statusSection(book)
                            
                            if let notes = book.notes, !notes.isEmpty {
                                notesSection(notes)
                            } else {
                                emptyNotesSection
                            }
                        
                            metadataSection(book)
                            
                            actionButtons(book)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.warningColor)
                        
                        Text("Book Not Found")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("This book may have been deleted")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button("Go Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(FontManager.buttonText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppColors.primaryBlue)
                        )
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Book Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                        }
                        .foregroundColor(AppColors.primaryBlue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let book = book {
                AddEditBookView(bookToEdit: book, bookStore: bookStore)
            }
        }
        .alert("Delete Book", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let book = book {
                    bookStore.deleteBook(book)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            if let book = book {
                Text("Are you sure you want to delete '\(book.title)'? This action cannot be undone.")
            }
        }
    }
    
    private func headerSection(_ book: Book) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.bubbleGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            VStack(spacing: 8) {
                Text(book.title)
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                if let author = book.author, !author.isEmpty {
                    Text("by \(author)")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    private func statusSection(_ book: Book) -> some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                Text(book.status.displayName)
                    .font(FontManager.buttonText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(statusColor(for: book.status))
                    )
                
                Spacer()
            }
            
            statusSpecificInfo(for: book)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    @ViewBuilder
    private func statusSpecificInfo(for book: Book) -> some View {
        switch book.status {
        case .reading:
            if let progress = book.progressText {
                VStack(spacing: 8) {
                    Text("Reading Progress")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(progress)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    if let current = book.currentPage, let total = book.totalPages, total > 0 {
                        ProgressView(value: Double(current), total: Double(total))
                            .progressViewStyle(LinearProgressViewStyle(tint: AppColors.primaryBlue))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                }
            }
            
        case .completed:
            VStack(spacing: 8) {
                Text("Your Rating")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                
                if let rating = book.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.warningColor)
                        
                        Text("\(rating)/10")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                    }
                } else {
                    Text("No rating")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                if let completedDate = book.dateCompleted {
                    Text("Completed on \(completedDate, style: .date)")
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.top, 4)
                }
            }
            
        case .wantToRead:
            VStack(spacing: 8) {
                Text("Added to Wishlist")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(book.dateAdded, style: .date)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func notesSection(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text(notes)
                .font(FontManager.body)
                .foregroundColor(AppColors.primaryText)
                .lineSpacing(4)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.lightBlue, lineWidth: 1)
                    }
                )
        }
    }
    
    private var emptyNotesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text("No notes added")
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .italic()
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    ZStack {
                          RoundedRectangle(cornerRadius: 12)
                              .fill(AppColors.cardBackground.opacity(0.5))
                          RoundedRectangle(cornerRadius: 12)
                              .stroke(AppColors.lightBlue.opacity(0.5), lineWidth: 1)
                      }
                )
        }
    }
    
    private func metadataSection(_ book: Book) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Last Modified")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                Text(book.lastModified, style: .date)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryText)
            }
            
            HStack {
                Text("Date Added")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                Text(book.dateAdded, style: .date)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.lightBlue.opacity(0.5), lineWidth: 1)
            }
        )
    }
    
    private func actionButtons(_ book: Book) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    Text("Edit Book")
                }
                .font(FontManager.buttonText)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.primaryBlue)
                )
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    Text("Delete Book")
                }
                .font(FontManager.buttonText)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.destructiveColor)
                )
            }
        }
    }
    
    private func statusColor(for status: BookStatus) -> Color {
        switch status {
        case .reading:
            return AppColors.readingColor
        case .completed:
            return AppColors.completedColor
        case .wantToRead:
            return AppColors.wantToReadColor
        }
    }
}
