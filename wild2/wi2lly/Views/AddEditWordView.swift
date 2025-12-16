import SwiftUI

struct AddEditWordView: View {
    @ObservedObject var viewModel: WordsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var word = ""
    @State private var definition = ""
    @State private var note = ""
    @State private var selectedCategory: CategoryModel?
    @State private var dateAdded = Date()
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    
    let editingWord: WordModel?
    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?
    var wrapInNavigationView: Bool
    
    init(viewModel: WordsViewModel, editingWord: WordModel? = nil, onSave: (() -> Void)? = nil, onCancel: (() -> Void)? = nil, wrapInNavigationView: Bool = true) {
        self.viewModel = viewModel
        self.editingWord = editingWord
        self.onSave = onSave
        self.onCancel = onCancel
        self.wrapInNavigationView = wrapInNavigationView
    }
    
    var isFormValid: Bool {
        !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !definition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCategory != nil
    }
    
    var body: some View {
        Group {
            if wrapInNavigationView {
                NavigationView {
                    contentView
                        .navigationTitle(editingWord == nil ? "Add Word" : "Edit Word")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    handleCancel()
                                }
                                .foregroundColor(Color.theme.primaryBlue)
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Save") {
                                    saveWord()
                                }
                                .foregroundColor(isFormValid ? Color.theme.primaryBlue : Color.theme.textGray)
                                .disabled(!isFormValid)
                            }
                        }
                        .onAppear {
                            setupForm()
                        }
                        .alert("Add Category", isPresented: $showingNewCategoryAlert) {
                            TextField("Category name", text: $newCategoryName)
                            Button("Add") {
                                addNewCategory()
                            }
                            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Enter a name for the new category")
                        }
                }
            } else {
                contentView
                    .onAppear {
                        setupForm()
                    }
                    .alert("Add Category", isPresented: $showingNewCategoryAlert) {
                        TextField("Category name", text: $newCategoryName)
                        Button("Add") {
                            addNewCategory()
                        }
                        .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Enter a name for the new category")
                    }
            }
        }
    }
    
    private var contentView: some View {
        ZStack {
            AnimatedBackground()
            
            if !wrapInNavigationView {
                VStack {
                    HStack {
                        Text("Add Word")
                            .font(.playfair(28, weight: .bold))
                            .foregroundColor(Color.theme.primaryBlue)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveWord()
                        }
                        .foregroundColor(isFormValid ? Color.theme.primaryBlue : Color.theme.textGray)
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                            VStack(spacing: 20) {
                                CustomTextField(
                                    title: "Word",
                                    text: $word,
                                    placeholder: "Enter the word"
                                )
                                
                                CustomTextEditor(
                                    title: "Definition",
                                    text: $definition,
                                    placeholder: "Enter the definition"
                                )
                                
                                CategoryPickerView(
                                    selectedCategory: $selectedCategory,
                                    categories: viewModel.categories,
                                    onAddNew: {
                                        showingNewCategoryAlert = true
                                    }
                                )
                                
                                CustomTextEditor(
                                    title: "Note (Optional)",
                                    text: $note,
                                    placeholder: "Add a personal note"
                                )
                                
                                DatePickerView(date: $dateAdded)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                    }
                }
            } else {
                ScrollView {
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Word",
                                text: $word,
                                placeholder: "Enter the word"
                            )
                            
                            CustomTextEditor(
                                title: "Definition",
                                text: $definition,
                                placeholder: "Enter the definition"
                            )
                            
                            CategoryPickerView(
                                selectedCategory: $selectedCategory,
                                categories: viewModel.categories,
                                onAddNew: {
                                    showingNewCategoryAlert = true
                                }
                            )
                            
                            CustomTextEditor(
                                title: "Note (Optional)",
                                text: $note,
                                placeholder: "Add a personal note"
                            )
                            
                            DatePickerView(date: $dateAdded)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                }
            }
        }
    }
    
    private func setupForm() {
        if let editingWord = editingWord {
            word = editingWord.word
            definition = editingWord.definition
            note = editingWord.note ?? ""
            dateAdded = editingWord.dateAdded
            selectedCategory = viewModel.categories.first { $0.name == editingWord.categoryName }
        } else {
            selectedCategory = viewModel.categories.first
        }
    }
    
    private func saveWord() {
        guard let category = selectedCategory else { return }
        
        let wordModel = WordModel(
            id: editingWord?.id ?? UUID(),
            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
            definition: definition.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note.trimmingCharacters(in: .whitespacesAndNewlines),
            dateAdded: dateAdded,
            categoryName: category.name
        )
        
        if editingWord != nil {
            viewModel.updateWord(wordModel)
            
            if let onSave = onSave {
                onSave()
            } else {
                dismiss()
            }
        } else {
            viewModel.addWord(wordModel)
            resetForm()
            
            if let onSave = onSave {
                    onSave()
            } else {
                    dismiss()
            }
        }
    }
    
    private func resetForm() {
        word = ""
        definition = ""
        note = ""
        dateAdded = Date()
        selectedCategory = viewModel.categories.first
    }
    
    private func handleCancel() {
        if let onCancel = onCancel {
            onCancel()
        } else {
            dismiss()
        }
    }
    
    private func addNewCategory() {
        let categoryName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !categoryName.isEmpty else { return }
        
        if !viewModel.categories.contains(where: { $0.name.lowercased() == categoryName.lowercased() }) {
            let newCategory = CategoryModel(
                name: categoryName,
                colorIndex: viewModel.categories.count % ColorTheme.categoryColors.count
            )
            viewModel.addCategory(newCategory)
            selectedCategory = newCategory
        }
        
        newCategoryName = ""
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfair(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
            
            TextField(placeholder, text: $text)
                .font(.playfair(16, weight: .regular))
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.lightBlue, lineWidth: 1)
                )
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfair(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfair(16, weight: .regular))
                        .foregroundColor(Color.theme.textGray.opacity(0.6))
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }
                
                TextEditor(text: $text)
                    .font(.playfair(16, weight: .regular))
                    .scrollContentBackground(.hidden)
            }
            .padding(12)
            .frame(minHeight: 100)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.lightBlue, lineWidth: 1)
            )
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: CategoryModel?
    let categories: [CategoryModel]
    let onAddNew: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.playfair(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategory?.id == category.id
                        ) {
                            selectedCategory = category
                        }
                    }
                    
                    Button(action: onAddNew) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .font(.playfair(14, weight: .medium))
                        .foregroundColor(Color.theme.primaryBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.theme.primaryBlue, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 3)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct CategoryChip: View {
    let category: CategoryModel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(category.name)
                .font(.playfair(14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color.theme.primaryBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? 
                    ColorTheme.categoryColors[category.colorIndex % ColorTheme.categoryColors.count] :
                    Color.white
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? Color.clear : ColorTheme.categoryColors[category.colorIndex % ColorTheme.categoryColors.count],
                            lineWidth: 1
                        )
                )
        }
    }
}

struct DatePickerView: View {
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date Added")
                .font(.playfair(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.lightBlue, lineWidth: 1)
                )
        }
    }
}

#Preview {
    AddEditWordView(viewModel: WordsViewModel())
}
