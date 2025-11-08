import SwiftUI

struct AddEditVictoryView: View {
    @ObservedObject var store: VictoryStore
    @Environment(\.dismiss) private var dismiss
    
    let editingVictory: Victory?
    
    @State private var title = ""
    @State private var selectedCategory: String? = nil
    @State private var date = Date()
    @State private var note = ""
    @State private var showingAddCategory = false
    @State private var showingDatePicker = false
    
    @State private var titleError = ""
    @State private var dateError = ""
    
    init(store: VictoryStore, editingVictory: Victory? = nil) {
        self.store = store
        self.editingVictory = editingVictory
        
        if let victory = editingVictory {
            self._title = State(initialValue: victory.title)
            self._selectedCategory = State(initialValue: victory.category)
            self._date = State(initialValue: victory.date)
            self._note = State(initialValue: victory.note ?? "")
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title *")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter victory title", text: $title)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(titleError.isEmpty ? AppColors.cardBorder : AppColors.error, lineWidth: 1)
                                )
                                .onChange(of: title) { _ in
                                    titleError = ""
                                }
                            
                            if !titleError.isEmpty {
                                Text(titleError)
                                    .font(AppFonts.caption1)
                                    .foregroundColor(AppColors.error)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Menu {
                                Button("None") {
                                    selectedCategory = nil
                                }
                                
                                ForEach(store.categories, id: \.id) { category in
                                    Button(category.name) {
                                        selectedCategory = category.name
                                    }
                                }
                                
                                Divider()
                                
                                Button {
                                    showingAddCategory = true
                                } label: {
                                    Label("Add Category", systemImage: "plus")
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory ?? "Select category")
                                        .font(AppFonts.body)
                                        .foregroundColor(selectedCategory == nil ? AppColors.textTertiary : AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date *")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Button {
                                showingDatePicker = true
                            } label: {
                                HStack {
                                    Text(date.formatted(date: .abbreviated, time: .omitted))
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(dateError.isEmpty ? AppColors.cardBorder : AppColors.error, lineWidth: 1)
                                )
                            }
                            
                            if !dateError.isEmpty {
                                Text(dateError)
                                    .font(AppFonts.caption1)
                                    .foregroundColor(AppColors.error)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Add a note (optional)", text: $note, axis: .vertical)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .lineLimit(3...6)
                            
                            Text("\(note.count)/120")
                                .font(AppFonts.caption2)
                                .foregroundColor(AppColors.textTertiary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(editingVictory == nil ? "New Victory" : "Edit Victory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveVictory()
                    }
                    .foregroundColor(isFormValid ? AppColors.primaryYellow : AppColors.textTertiary)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(store: store) { categoryName in
                selectedCategory = categoryName
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(title: "Select Date", selectedDate: $date)
        }
        .onChange(of: note) { newValue in
            if newValue.count > 120 {
                note = String(newValue.prefix(120))
            }
        }
    }
    
    private func saveVictory() {
        titleError = ""
        dateError = ""
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            titleError = "Please enter a title"
            return
        }
        
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalNote = trimmedNote.isEmpty ? nil : trimmedNote
        
        if let editingVictory = editingVictory {
            let updatedVictory = Victory(
                id: editingVictory.id,
                title: trimmedTitle,
                category: selectedCategory,
                date: date,
                note: finalNote
            )
            store.updateVictory(updatedVictory)
        } else {
            let newVictory = Victory(
                title: trimmedTitle,
                category: selectedCategory,
                date: date,
                note: finalNote
            )
            store.addVictory(newVictory)
        }
        
        dismiss()
    }
}

struct AddCategoryView: View {
    @ObservedObject var store: VictoryStore
    @Environment(\.dismiss) private var dismiss
    
    let onCategoryAdded: (String) -> Void
    
    @State private var categoryName = ""
    @State private var nameError = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category Name")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        TextField("Enter category name", text: $categoryName)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textPrimary)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(nameError.isEmpty ? AppColors.cardBorder : AppColors.error, lineWidth: 1)
                            )
                            .onChange(of: categoryName) { _ in
                                nameError = ""
                            }
                        
                        if !nameError.isEmpty {
                            Text(nameError)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.error)
                        }
                        
                        Text("\(categoryName.count)/30")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCategory()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .onChange(of: categoryName) { newValue in
            if newValue.count > 30 {
                categoryName = String(newValue.prefix(30))
            }
        }
    }
    
    private func saveCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            nameError = "Please enter a category name"
            return
        }
        
        if store.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            nameError = "Category already exists"
            return
        }
        
        let newCategory = Category(name: trimmedName)
        store.addCategory(newCategory)
        onCategoryAdded(trimmedName)
        dismiss()
    }
}

#Preview {
    AddEditVictoryView(store: VictoryStore())
}
