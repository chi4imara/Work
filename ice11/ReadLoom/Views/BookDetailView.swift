import SwiftUI

struct BookDetailView: View {
    let bookId: UUID
    let onAddProgress: (Int32) -> Void
    
    @ObservedObject var viewModel: BooksViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddProgress = false
    @State private var showingEditBook = false
    @State private var showingDeleteAlert = false
    
    private var book: BookModel? {
        viewModel.books.first { $0.id == bookId }
    }
    
    var body: some View {
        Group {
            if let currentBook = book {
                NavigationView {
                    ZStack {
                        BackgroundView()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(currentBook.title)
                                            .font(.ubuntu(24, weight: .bold))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        if let author = currentBook.author, !author.isEmpty {
                                            Text(author)
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.secondaryText)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Total pages: \(currentBook.totalPages)")
                                            .font(.ubuntu(16))
                                            .foregroundColor(AppColors.accentText)
                                        
                                        Text(currentBook.progressText)
                                            .font(.ubuntu(16))
                                            .foregroundColor(AppColors.accentText)
                                        
                                        Text("Status: \(currentBook.statusText)")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(currentBook.isCompleted ? AppColors.success : AppColors.primaryYellow)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                Rectangle()
                                                    .fill(AppColors.primaryText.opacity(0.2))
                                                    .frame(height: 8)
                                                    .cornerRadius(4)
                                                
                                                Rectangle()
                                                    .fill(AppColors.primaryYellow)
                                                    .frame(width: geometry.size.width * (currentBook.progressPercentage / 100), height: 8)
                                                    .cornerRadius(4)
                                            }
                                        }
                                        .frame(height: 8)
                                        
                                        Text("\(Int(currentBook.progressPercentage))% completed")
                                            .font(.ubuntu(14, weight: .medium))
                                            .foregroundColor(AppColors.accentText)
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(AppColors.cardBackground)
                                )
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("Daily Progress")
                                            .font(.ubuntu(20, weight: .bold))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        if !currentBook.isCompleted {
                                            Button {
                                                showingAddProgress = true
                                            } label: {
                                                Text("Add Progress")
                                                    .font(.ubuntu(14, weight: .medium))
                                                    .foregroundColor(AppColors.primaryBlue)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(AppColors.primaryYellow)
                                                    )

                                            }
                                        }
                                    }
                                    
                                    if currentBook.readingProgressArray.isEmpty {
                                        Text("You haven't recorded any reading progress for this book yet")
                                            .font(.ubuntu(14))
                                            .foregroundColor(AppColors.secondaryText)
                                            .multilineTextAlignment(.center)
                                            .padding(.vertical, 20)
                                    } else {
                                        VStack(spacing: 8) {
                                            ForEach(currentBook.readingProgressArray.prefix(10)) { progress in
                                                HStack {
                                                    Text(progress.progressText)
                                                        .font(.ubuntu(14))
                                                        .foregroundColor(AppColors.accentText)
                                                    
                                                    Spacer()
                                                }
                                                .padding(.vertical, 4)
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(AppColors.cardBackground)
                                )
                                
                                VStack(spacing: 12) {
                                    Button {
                                        showingEditBook = true
                                    } label: {
                                        Text("Edit Book")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(AppColors.cardBackground)
                                            )

                                    }
                                    
                                    Button {
                                        showingDeleteAlert = true
                                    } label: {
                                        Text("Delete Book")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(AppColors.error)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(AppColors.cardBackground)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        }
                    }
                    .navigationTitle("Book Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading: Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(AppColors.primaryText)
                    )
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingAddProgress) {
                    AddProgressView(bookId: currentBook.id, viewModel: viewModel, onSave: { pages in
                        onAddProgress(pages)
                        viewModel.loadBooks()
                    })
                }
                .onChange(of: showingAddProgress) { isShowing in
                    if !isShowing {
                        viewModel.loadBooks()
                    }
                }
                .sheet(isPresented: $showingEditBook) {
                    AddEditBookView(book: currentBook) { title, author, totalPages in
                        viewModel.updateBook(currentBook, title: title, author: author, totalPages: totalPages)
                        viewModel.loadBooks()
                    }
                }
                .onChange(of: showingEditBook) { isShowing in
                    if !isShowing {
                        viewModel.loadBooks()
                    }
                }
                .alert("Delete Book", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteBook(currentBook)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this book and all reading progress? This action cannot be undone.")
                }
            }
        }
        .onAppear {
            viewModel.loadBooks()
        }
    }
}

struct AddProgressView: View {
    let bookId: UUID
    @ObservedObject var viewModel: BooksViewModel
    let onSave: (Int32) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var pagesReadText: String = ""
    @State private var pagesError: String?
    
    private var book: BookModel? {
        viewModel.books.first { $0.id == bookId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("How many pages did you read today?")
                            .font(.ubuntu(20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                        
                        TextField("Enter number of pages...", text: $pagesReadText)
                            .font(.ubuntu(18))
                            .foregroundColor(AppColors.primaryText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(pagesError != nil ? AppColors.error : Color.clear, lineWidth: 1)
                                    )
                            )
                        
                        if let error = pagesError {
                            Text(error)
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.error)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        saveProgress()
                    } label: {
                        Text("Save Progress")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(AppColors.primaryYellow)
                            )
                    }
                    .disabled(!isValidInput)
                    .opacity(isValidInput ? 1.0 : 0.6)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primaryText)
            )
            .preferredColorScheme(.dark)
        }
    }
    
    private var isValidInput: Bool {
        !pagesReadText.isEmpty && Int32(pagesReadText) != nil && Int32(pagesReadText) ?? 0 > 0
    }
    
    private func saveProgress() {
        guard let book = book else { return }
        guard let pagesRead = Int32(pagesReadText), pagesRead > 0 else {
            pagesError = "Please enter a valid number of pages"
            return
        }
        
        let remainingPages = book.totalPages - book.currentPages
        let actualPagesRead = min(pagesRead, remainingPages)
        
        onSave(actualPagesRead)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = BooksViewModel()
    let book = BookModel(title: "Sample Book", author: "Sample Author", totalPages: 300)
    
    return BookDetailView(bookId: book.id, onAddProgress: { _ in }, viewModel: viewModel)
}
