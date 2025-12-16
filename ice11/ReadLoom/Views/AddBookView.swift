import SwiftUI

struct AddBookView: View {
    let book: BookModel?
    let onSave: (String, String?, Int32) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var totalPagesText: String = ""
    
    @State private var titleError: String?
    @State private var pagesError: String?
    
    @Binding var selectedTab: Int
    
    private var isEditing: Bool {
        book != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Book" : "New Book"
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("New Book")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Book Title")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter book title...", text: $title)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(titleError != nil ? AppColors.error : Color.clear, lineWidth: 1)
                                        )
                                )
                                .onChange(of: title) { _ in
                                    titleError = nil
                                }
                            
                            if let error = titleError {
                                Text(error)
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.error)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Author (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter author name...", text: $author)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Pages")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter total number of pages...", text: $totalPagesText)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(pagesError != nil ? AppColors.error : Color.clear, lineWidth: 1)
                                        )
                                )
                                .onChange(of: totalPagesText) { _ in
                                    pagesError = nil
                                }
                            
                            if let error = pagesError {
                                Text(error)
                                    .font(.ubuntu(12))
                                    .foregroundColor(AppColors.error)
                            }
                        }
                        
                        Button(action: {
                            withAnimation {
                                saveBook()
                                selectedTab = 0
                            }
                        }) {
                            Text("Save")
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
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var isValidInput: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !totalPagesText.isEmpty &&
        Int32(totalPagesText) != nil &&
        Int32(totalPagesText) ?? 0 > 0
    }
    
    private func setupInitialValues() {
        if let book = book {
            title = book.title
            author = book.author ?? ""
            totalPagesText = String(book.totalPages)
        }
    }
    
    private func saveBook() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            titleError = "Please enter book title"
            return
        }
        
        guard let totalPages = Int32(totalPagesText), totalPages > 0 else {
            pagesError = "Please enter correct number of pages"
            return
        }
        
        if let book = book, totalPages < book.currentPages {
            pagesError = "Total pages cannot be less than already read pages"
            return
        }
        
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalAuthor = trimmedAuthor.isEmpty ? nil : trimmedAuthor
        
        onSave(trimmedTitle, finalAuthor, totalPages)
        presentationMode.wrappedValue.dismiss()
    }
}
