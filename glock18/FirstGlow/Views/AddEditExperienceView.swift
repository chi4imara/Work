import SwiftUI

struct AddEditExperienceView: View {
    @ObservedObject var store: FirstExperienceStore
    @Environment(\.dismiss) private var dismiss
    
    let experienceToEdit: FirstExperience?
    
    @State private var title: String = ""
    @State private var selectedCategory: String = ""
    @State private var date: Date = Date()
    @State private var place: String = ""
    @State private var note: String = ""
    
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var titleError = ""
    @State private var dateError = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, place, note, newCategory
    }
    
    init(store: FirstExperienceStore, experienceToEdit: FirstExperience? = nil) {
        self.store = store
        self.experienceToEdit = experienceToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            titleSection
                            categorySection
                            dateSection
                            placeSection
                            noteSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupInitialValues()
        }
        .alert("Add Category", isPresented: $showingAddCategory) {
            TextField("Category name", text: $newCategoryName)
                .focused($focusedField, equals: .newCategory)
                .onChange(of: newCategoryName) { newValue in
                    if newValue.count > 30 {
                        newCategoryName = String(newValue.prefix(30))
                    }
                }
            
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            
            Button("Save") {
                addNewCategory()
            }
            .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        } message: {
            Text("Enter a name for the new category (max 30 characters)")
        }
    }
    
    private var isEditing: Bool {
        experienceToEdit != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(FontManager.callout)
                .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Text(isEditing ? "Edit Experience" : "New Experience")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Button("Save") {
                    saveExperience()
                }
                .font(FontManager.callout)
                .foregroundColor(canSave ? AppColors.accentYellow : AppColors.pureWhite.opacity(0.5))
                .disabled(!canSave)
            }
            
            Divider()
                .background(AppColors.pureWhite.opacity(0.3))
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Title")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.pureWhite)
                
                Text("*")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.accentYellow)
            }
            
            TextField("e.g., First flight on airplane", text: $title)
                .font(FontManager.body)
                .foregroundColor(AppColors.pureWhite)
                .focused($focusedField, equals: .title)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(titleError.isEmpty ? AppColors.pureWhite.opacity(0.3) : Color.red, lineWidth: 1)
                        }
                )
                .onChange(of: title) { _ in
                    titleError = ""
                }
            
            if !titleError.isEmpty {
                Text(titleError)
                    .font(FontManager.caption1)
                    .foregroundColor(.red)
            }
        }
        .padding(.top, 8)
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                Menu {
                    Button("None") {
                        selectedCategory = ""
                    }
                    
                    ForEach(store.categories.sorted(by: { $0.name < $1.name }), id: \.id) { category in
                        Button(category.name) {
                            selectedCategory = category.name
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                            .font(FontManager.body)
                            .foregroundColor(selectedCategory.isEmpty ? AppColors.pureWhite.opacity(0.6) : AppColors.pureWhite)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.pureWhite.opacity(0.6))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.pureWhite.opacity(0.1))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                            }
                    )
                }
                
                Button(action: {
                    showingAddCategory = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .medium))
                        Text("Add Category")
                            .font(FontManager.callout)
                    }
                    .foregroundColor(AppColors.accentYellow)
                }
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Date")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.pureWhite)
                
                Text("*")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.accentYellow)
            }
            
            DatePicker("Select date", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .colorScheme(.dark)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(dateError.isEmpty ? AppColors.pureWhite.opacity(0.3) : Color.red, lineWidth: 1)
                        }
                )
            
            if !dateError.isEmpty {
                Text(dateError)
                    .font(FontManager.caption1)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var placeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Place")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            TextField("e.g., Moscow, Sheremetyevo", text: $place)
                .font(FontManager.body)
                .foregroundColor(AppColors.pureWhite)
                .focused($focusedField, equals: .place)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                        }
                )
                .onChange(of: place) { newValue in
                    if newValue.count > 40 {
                        place = String(newValue.prefix(40))
                    }
                }
            
            Text("Optional • Max 40 characters")
                .font(FontManager.caption2)
                .foregroundColor(AppColors.pureWhite.opacity(0.6))
        }
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Note")
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite)
            
            TextField("Add your thoughts about this experience...", text: $note, axis: .vertical)
                .font(FontManager.body)
                .foregroundColor(AppColors.pureWhite)
                .focused($focusedField, equals: .note)
                .lineLimit(4, reservesSpace: true)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.pureWhite.opacity(0.1))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                        }
                )
                .onChange(of: note) { newValue in
                    if newValue.count > 120 {
                        note = String(newValue.prefix(120))
                    }
                }
            
            Text("Optional • Max 120 characters")
                .font(FontManager.caption2)
                .foregroundColor(AppColors.pureWhite.opacity(0.6))
        }
    }
    
    private func setupInitialValues() {
        if let experience = experienceToEdit {
            title = experience.title
            selectedCategory = experience.category ?? ""
            date = experience.date
            place = experience.place ?? ""
            note = experience.note ?? ""
        }
    }
    
    private func addNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty && trimmedName.count <= 30 else {
            return
        }
        
        guard !store.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            return
        }
        
        let newCategory = Category(name: trimmedName)
        store.addCategory(newCategory)
        selectedCategory = trimmedName
        newCategoryName = ""
    }
    
    private func saveExperience() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            titleError = "Please enter a title"
            return
        }
        
        guard trimmedTitle.count <= 60 else {
            titleError = "Title must be 60 characters or less"
            return
        }
        
        guard place.count <= 40 else {
            return
        }
        
        guard note.count <= 120 else {
            return
        }
        
        if let existingExperience = experienceToEdit {
            var updatedExperience = existingExperience
            updatedExperience.title = trimmedTitle
            updatedExperience.category = selectedCategory.isEmpty ? nil : selectedCategory
            updatedExperience.date = date
            updatedExperience.place = place.isEmpty ? nil : place
            updatedExperience.note = note.isEmpty ? nil : note
            
            store.updateExperience(updatedExperience)
        } else {
            let newExperience = FirstExperience(
                title: trimmedTitle,
                category: selectedCategory.isEmpty ? nil : selectedCategory,
                date: date,
                place: place.isEmpty ? nil : place,
                note: note.isEmpty ? nil : note
            )
            store.addExperience(newExperience)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditExperienceView(store: FirstExperienceStore())
}
