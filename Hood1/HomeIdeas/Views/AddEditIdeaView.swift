import SwiftUI

struct AddEditIdeaView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.dismiss) private var dismiss
    
    let ideaToEdit: Idea?
    
    @State private var title = ""
    @State private var selectedCategory = ""
    @State private var selectedDate = Date()
    @State private var note = ""
    @State private var showingDatePicker = false
    @State private var showingCategoryPicker = false
    @State private var hasUnsavedChanges = false
    @State private var showingDiscardAlert = false
    
    @State private var titleError = ""
    @State private var categoryError = ""
    
    init(viewModel: IdeasViewModel, ideaToEdit: Idea? = nil) {
        self.viewModel = viewModel
        self.ideaToEdit = ideaToEdit
    }
    
    var isEditing: Bool {
        ideaToEdit != nil
    }
    
    var body: some View {
        return
        ZStack {
            BackgroundView()
            
            VStack {
                HStack{
                    Button("Cancel") {
                        if hasUnsavedChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Idea" : "New Idea")
                        .font(.theme.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveIdea()
                    }
                    .font(.theme.buttonMedium)
                    .fontWeight(.bold)
                    .foregroundColor(isFormValid ? AppColors.primaryOrange : .white.opacity(0))
                    .disabled(!isFormValid)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Idea Title")
                                .font(.theme.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter idea title", text: $title)
                                .font(.theme.body)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(titleError.isEmpty ? AppColors.cardBorder : AppColors.error, lineWidth: 1)
                                )
                                .onChange(of: title) { _ in
                                    validateTitle()
                                    checkForChanges()
                                }
                            
                            if !titleError.isEmpty {
                                Text(titleError)
                                    .font(.theme.caption2)
                                    .foregroundColor(AppColors.error)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.theme.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Button(action: { showingCategoryPicker = true }) {
                                HStack {
                                    Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                        .font(.theme.body)
                                        .foregroundColor(selectedCategory.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(categoryError.isEmpty ? AppColors.cardBorder : AppColors.error, lineWidth: 1)
                                )
                            }
                            
                            if !categoryError.isEmpty {
                                Text(categoryError)
                                    .font(.theme.caption2)
                                    .foregroundColor(AppColors.error)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date Added")
                                .font(.theme.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Button(action: { showingDatePicker = true }) {
                                HStack {
                                    Text(DateFormatter.fullDate.string(from: selectedDate))
                                        .font(.theme.body)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .font(.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (Optional)")
                                .font(.theme.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Add a note about this idea", text: $note, axis: .vertical)
                                .font(.theme.body)
                                .foregroundColor(AppColors.textPrimary)
                                .lineLimit(4...8)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                                .onChange(of: note) { _ in
                                    checkForChanges()
                                }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(
                categories: viewModel.categories.map { $0.name },
                selectedCategory: $selectedCategory
            )
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedCategory.isEmpty
    }
    
    private func setupInitialValues() {
        if let idea = ideaToEdit {
            title = idea.title
            selectedCategory = idea.category
            selectedDate = idea.dateAdded
            note = idea.note
        } else {
            selectedDate = Date()
        }
    }
    
    private func validateTitle() {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleError = "Title is required"
        } else {
            titleError = ""
        }
    }
    
    private func validateCategory() {
        if selectedCategory.isEmpty {
            categoryError = "Category is required"
        } else {
            categoryError = ""
        }
    }
    
    private func checkForChanges() {
        if let idea = ideaToEdit {
            hasUnsavedChanges = title != idea.title ||
                               selectedCategory != idea.category ||
                               selectedDate != idea.dateAdded ||
                               note != idea.note
        } else {
            hasUnsavedChanges = !title.isEmpty || !selectedCategory.isEmpty || !note.isEmpty
        }
    }
    
    private func saveIdea() {
        validateTitle()
        validateCategory()
        
        guard isFormValid else { return }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingIdea = ideaToEdit {
            var updatedIdea = existingIdea
            updatedIdea.title = trimmedTitle
            updatedIdea.category = selectedCategory
            updatedIdea.dateAdded = selectedDate
            updatedIdea.note = trimmedNote
            
            viewModel.updateIdea(updatedIdea)
        } else {
            let newIdea = Idea(
                title: trimmedTitle,
                category: selectedCategory,
                dateAdded: selectedDate,
                note: trimmedNote
            )
            
            viewModel.addIdea(newIdea)
        }
        
        dismiss()
    }
}

struct CategoryPickerView: View {
    let categories: [String]
    @Binding var selectedCategory: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        return NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    HStack {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                        .opacity(0)
                        
                        Spacer()
                        
                        Text("Select Category")
                            .font(.theme.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                    }
                    .padding()
                    
                    List {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                dismiss()
                            }) {
                                HStack {
                                    Text(category)
                                        .font(.theme.body)
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    Spacer()
                                    
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(AppColors.primaryOrange)
                                    }
                                }
                            }
                            .listRowBackground(AppColors.cardBackground)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        return NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                }
            }
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}


#Preview {
    AddEditIdeaView(viewModel: IdeasViewModel())
}
