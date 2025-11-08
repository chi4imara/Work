import SwiftUI

struct AddEditBookView: View {
    @ObservedObject var bookStore: BookStore
    @Environment(\.presentationMode) var presentationMode
    
    let bookToEdit: Book?
    
    init(bookToEdit: Book? = nil, bookStore: BookStore) {
        self.bookToEdit = bookToEdit
        self.bookStore = bookStore
    }
    
    @State private var title = ""
    @State private var author = ""
    @State private var selectedStatus: BookStatus = .wantToRead
    @State private var rating = 5
    @State private var notes = ""
    @State private var currentPage = ""
    @State private var totalPages = ""
    @State private var showingDeleteConfirmation = false
    @State private var showingCancelConfirmation = false
    @State private var hasUnsavedChanges = false
    
    private var isEditing: Bool {
        bookToEdit != nil
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        Button("Cancel") {
                            if hasUnsavedChanges {
                                showingCancelConfirmation = true
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Book" : "New Book")
                            .font(FontManager.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        Spacer()
                        Spacer()
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            VStack(spacing: 20) {
                                FormField(
                                    title: "Book Title",
                                    text: $title,
                                    placeholder: "Enter book title",
                                    isRequired: true
                                )
                                .onChange(of: title) { _ in hasUnsavedChanges = true }
                                
                                FormField(
                                    title: "Author",
                                    text: $author,
                                    placeholder: "Enter author name"
                                )
                                .onChange(of: author) { _ in hasUnsavedChanges = true }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Status")
                                        .font(FontManager.subheadline)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    StatusPicker(selectedStatus: $selectedStatus)
                                        .onChange(of: selectedStatus) { _ in hasUnsavedChanges = true }
                                }
                                
                                statusDependentFields
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Notes")
                                        .font(FontManager.subheadline)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    TextEditor(text: $notes)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(minHeight: 100)
                                        .padding(12)
                                        .background(
                                            ZStack {
                                                 RoundedRectangle(cornerRadius: 12)
                                                     .fill(AppColors.cardBackground)
                                                 RoundedRectangle(cornerRadius: 12)
                                                     .stroke(AppColors.lightBlue, lineWidth: 1)
                                             }
                                        )
                                        .onChange(of: notes) { _ in hasUnsavedChanges = true }
                                    
                                    Text("\(notes.count)/500")
                                        .font(FontManager.caption)
                                        .foregroundColor(AppColors.secondaryText)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(spacing: 16) {
                                Button(action: saveBook) {
                                    Text(isEditing ? "Save Changes" : "Add Book")
                                        .font(FontManager.buttonText)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(isFormValid ? AppColors.primaryBlue : AppColors.secondaryText)
                                        )
                                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                                }
                                .disabled(!isFormValid)
                                
                                if isEditing {
                                    Button(action: {
                                        showingDeleteConfirmation = true
                                    }) {
                                        Text("Delete Book")
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
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Delete Book", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let book = bookToEdit {
                    bookStore.deleteBook(book)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this book? This action cannot be undone.")
        }
        .alert("Discard Changes", isPresented: $showingCancelConfirmation) {
            Button("Keep Editing", role: .cancel) { }
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }
    
    @ViewBuilder
    private var statusDependentFields: some View {
        switch selectedStatus {
        case .reading:
            VStack(spacing: 16) {
                FormField(
                    title: "Current Page",
                    text: $currentPage,
                    placeholder: "0",
                    keyboardType: .numberPad
                )
                .onChange(of: currentPage) { _ in hasUnsavedChanges = true }
                
                FormField(
                    title: "Total Pages",
                    text: $totalPages,
                    placeholder: "Optional",
                    keyboardType: .numberPad
                )
                .onChange(of: totalPages) { _ in hasUnsavedChanges = true }
            }
            
        case .completed:
            VStack(alignment: .leading, spacing: 12) {
                Text("Rating")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                RatingPicker(rating: $rating)
                    .onChange(of: rating) { _ in hasUnsavedChanges = true }
            }
            
        case .wantToRead:
            EmptyView()
        }
    }
    
    private func setupInitialValues() {
        if let book = bookToEdit {
            title = book.title
            author = book.author ?? ""
            selectedStatus = book.status
            rating = book.rating ?? 5
            notes = book.notes ?? ""
            currentPage = book.currentPage?.description ?? ""
            totalPages = book.totalPages?.description ?? ""
        }
    }
    
    private func saveBook() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isEditing, var book = bookToEdit {
            book.title = trimmedTitle
            book.author = trimmedAuthor.isEmpty ? nil : trimmedAuthor
            book.updateStatus(selectedStatus)
            book.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
            book.lastModified = Date()
            
            switch selectedStatus {
            case .reading:
                book.currentPage = Int(currentPage)
                book.totalPages = Int(totalPages)
                book.rating = nil
            case .completed:
                book.rating = rating
                book.currentPage = nil
                book.totalPages = nil
                book.dateCompleted = Date()
            case .wantToRead:
                book.rating = nil
                book.currentPage = nil
                book.totalPages = nil
            }
            
            bookStore.updateBook(book)
        } else {
            var newBook = Book(title: trimmedTitle, author: trimmedAuthor.isEmpty ? nil : trimmedAuthor, status: selectedStatus)
            newBook.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
            
            switch selectedStatus {
            case .reading:
                newBook.currentPage = Int(currentPage)
                newBook.totalPages = Int(totalPages)
            case .completed:
                newBook.rating = rating
                newBook.dateCompleted = Date()
            case .wantToRead:
                break
            }
            
            bookStore.addBook(newBook)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isRequired: Bool
    let keyboardType: UIKeyboardType
    
    init(title: String, text: Binding<String>, placeholder: String, isRequired: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                
                if isRequired {
                    Text("*")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.destructiveColor)
                }
            }
            
            TextField(placeholder, text: $text)
                .font(FontManager.body)
                .foregroundColor(AppColors.primaryText)
                .padding(12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.lightBlue, lineWidth: 1)
                    }
                )
                .keyboardType(keyboardType)
        }
    }
}

struct StatusPicker: View {
    @Binding var selectedStatus: BookStatus
    
    var body: some View {
            HStack(spacing: 12) {
                ForEach(BookStatus.allCases, id: \.self) { status in
                    Button(action: {
                        selectedStatus = status
                    }) {
                        Text(status.displayName)
                            .font(FontManager.caption)
                            .foregroundColor(selectedStatus == status ? .white : AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedStatus == status ? AppColors.primaryBlue : AppColors.cardBackground)
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(AppColors.lightBlue, lineWidth: 1)
                                }
                            )
                    }
                }
            }
    }
    
}

struct RatingPicker: View {
    @Binding var rating: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(1...10, id: \.self) { value in
                    Button(action: {
                        rating = value
                    }) {
                        Text("\(value)")
                            .font(FontManager.caption)
                            .foregroundColor(rating == value ? .white : AppColors.primaryText)
                            .frame(width: 32, height: 32)
                            .background(
                                ZStack {
                                     Circle()
                                         .fill(rating == value ? AppColors.primaryBlue : AppColors.cardBackground)
                                     Circle()
                                         .stroke(AppColors.lightBlue, lineWidth: 1)
                                 }
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}
