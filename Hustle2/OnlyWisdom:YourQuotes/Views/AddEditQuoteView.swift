import SwiftUI

struct AddEditQuoteView: View {
    @ObservedObject var quoteStore: QuoteStore
    @Environment(\.presentationMode) var presentationMode
    
    let editingQuote: Quote?
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var type: QuoteType = .thought
    @State private var source: String = ""
    @State private var selectedCategory: String = ""
    @State private var date: Date = Date()
    @State private var shouldArchive: Bool = false
    
    @State private var showingCategoryPicker = false
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var showingDiscardAlert = false
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    private var isEditing: Bool {
        editingQuote != nil
    }
    
    private var hasChanges: Bool {
        if let quote = editingQuote {
            return title != quote.title ||
                   content != quote.content ||
                   type != quote.type ||
                   source != (quote.source ?? "") ||
                   selectedCategory != (quote.category ?? "") ||
                   !Calendar.current.isDate(date, inSameDayAs: quote.dateCreated) ||
                   shouldArchive != quote.isArchived
        } else {
            return !title.isEmpty || !content.isEmpty || !source.isEmpty || !selectedCategory.isEmpty
        }
    }
    
    init(quoteStore: QuoteStore, editingQuote: Quote? = nil) {
        self.quoteStore = quoteStore
        self.editingQuote = editingQuote
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Gradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        formSection(title: "Title *") {
                            TextField("Enter title", text: $title)
                                .font(FontManager.poppinsRegular(size: 16))
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        formSection(title: "Type") {
                            HStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(QuoteType.allCases, id: \.self) { quoteType in
                                    TypeButton(
                                        type: quoteType,
                                        isSelected: type == quoteType
                                    ) {
                                        type = quoteType
                                        if type == .thought {
                                            source = ""
                                        }
                                    }
                                }
                            }
                        }
                        
                        formSection(title: "Content *") {
                            TextEditor(text: $content)
                                .font(FontManager.poppinsRegular(size: 16))
                                .frame(minHeight: 120)
                                .padding(DesignSystem.Spacing.md)
                                .background(Color.white)
                                .cornerRadius(DesignSystem.CornerRadius.md)
                                .shadow(color: DesignSystem.Shadow.light, radius: 2)
                        }
                        
                        if type == .quote {
                            formSection(title: "Source") {
                                TextField("Author, book, etc.", text: $source)
                                    .font(FontManager.poppinsRegular(size: 16))
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                        }
                        
                        formSection(title: "Category") {
                            Button(action: { showingCategoryPicker = true }) {
                                HStack {
                                    Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                        .font(FontManager.poppinsRegular(size: 16))
                                        .foregroundColor(selectedCategory.isEmpty ? DesignSystem.Colors.textSecondary : DesignSystem.Colors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                }
                                .padding(DesignSystem.Spacing.md)
                                .background(Color.white)
                                .cornerRadius(DesignSystem.CornerRadius.md)
                                .shadow(color: DesignSystem.Shadow.light, radius: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        formSection(title: "Date") {
                            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(DesignSystem.Spacing.md)
                                .background(Color.white)
                                .cornerRadius(DesignSystem.CornerRadius.md)
                                .shadow(color: DesignSystem.Shadow.light, radius: 2)
                        }
                        
                        if isEditing {
                            formSection(title: "Archive") {
                                Toggle("Archive this quote", isOn: $shouldArchive)
                                    .font(FontManager.poppinsRegular(size: 16))
                                    .padding(DesignSystem.Spacing.md)
                                    .background(Color.white)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .shadow(color: DesignSystem.Shadow.light, radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.bottom, DesignSystem.Spacing.xxl)
                }
            }
            .navigationTitle(isEditing ? "Edit Quote" : "New Quote")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    if hasChanges {
                        showingDiscardAlert = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button("Save") {
                    saveQuote()
                }
                .disabled(!isValidForm)
            )
        }
        .onAppear {
            loadQuoteData()
        }
        .actionSheet(isPresented: $showingCategoryPicker) {
            categoryActionSheet
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Create") {
                createNewCategory()
            }
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
        }
        .alert("Discard Changes", isPresented: $showingDiscardAlert) {
            Button("Save") {
                saveQuote()
            }
            Button("Don't Save", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You have unsaved changes. What would you like to do?")
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") {}
        } message: {
            Text(validationMessage)
        }
    }
    
    private func formSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(FontManager.poppinsSemiBold(size: 16))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            content()
        }
    }
    
    private var isValidForm: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        content.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3
    }
    
    private var categoryActionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        buttons.append(.default(Text("None")) {
            selectedCategory = ""
        })
        
        for category in quoteStore.categories {
            buttons.append(.default(Text(category.name)) {
                selectedCategory = category.name
            })
        }
        
        buttons.append(.default(Text("New Category...")) {
            showingNewCategoryAlert = true
        })
        
        buttons.append(.cancel())
        
        return ActionSheet(title: Text("Select Category"), buttons: buttons)
    }
    
    private func loadQuoteData() {
        if let quote = editingQuote {
            title = quote.title
            content = quote.content
            type = quote.type
            source = quote.source ?? ""
            selectedCategory = quote.category ?? ""
            date = quote.dateCreated
            shouldArchive = quote.isArchived
        }
    }
    
    private func createNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            validationMessage = "Category name cannot be empty"
            showingValidationError = true
            return
        }
        
        guard !quoteStore.categoryExists(trimmedName) else {
            validationMessage = "A category with this name already exists"
            showingValidationError = true
            return
        }
        
        let newCategory = Category(name: trimmedName)
        quoteStore.addCategory(newCategory)
        selectedCategory = trimmedName
        newCategoryName = ""
    }
    
    private func saveQuote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            validationMessage = "Please enter a title"
            showingValidationError = true
            return
        }
        
        guard trimmedContent.count >= 3 else {
            validationMessage = "Content must be at least 3 characters long"
            showingValidationError = true
            return
        }
        
        if let existingQuote = editingQuote {
            var updatedQuote = existingQuote
            updatedQuote.title = trimmedTitle
            updatedQuote.content = trimmedContent
            updatedQuote.type = type
            updatedQuote.source = type == .quote && !source.isEmpty ? source : nil
            updatedQuote.category = !selectedCategory.isEmpty ? selectedCategory : nil
            updatedQuote.dateCreated = date
            updatedQuote.isArchived = shouldArchive
            if shouldArchive && !existingQuote.isArchived {
                updatedQuote.dateArchived = Date()
            } else if !shouldArchive && existingQuote.isArchived {
                updatedQuote.dateArchived = nil
            }
            
            quoteStore.updateQuote(updatedQuote)
        } else {
            let newQuote = Quote(
                title: trimmedTitle,
                content: trimmedContent,
                type: type,
                source: type == .quote && !source.isEmpty ? source : nil,
                category: !selectedCategory.isEmpty ? selectedCategory : nil,
                dateCreated: date,
                isArchived: shouldArchive
            )
            
            quoteStore.addQuote(newQuote)
        }
        
        DispatchQueue.main.async {
            quoteStore.objectWillChange.send()
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct TypeButton: View {
    let type: QuoteType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: type.icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(type.displayName)
                    .font(FontManager.poppinsRegular(size: 16))
            }
            .foregroundColor(isSelected ? .white : DesignSystem.Colors.primaryBlue)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                isSelected ? DesignSystem.Colors.primaryBlue : Color.white
            )
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(color: DesignSystem.Shadow.light, radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(DesignSystem.Spacing.md)
            .background(Color.white)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(color: DesignSystem.Shadow.light, radius: 2)
    }
}

#Preview {
    AddEditQuoteView(quoteStore: QuoteStore())
}
