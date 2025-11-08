import SwiftUI

struct AddEditEntryView: View {
    @ObservedObject var viewModel: ScentDiaryViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var selectedCategory: String = ""
    @State private var customCategory: String = ""
    @State private var associations: String = ""
    @State private var showingCustomCategoryField = false
    @State private var showingDeleteAlert = false
    @State private var showingNameError = false
    @State private var showingPreview = false
    
    let entry: ScentEntry?
    let isEditing: Bool
    
    init(viewModel: ScentDiaryViewModel, entry: ScentEntry? = nil) {
        self.viewModel = viewModel
        self.entry = entry
        self.isEditing = entry != nil
        
        if let entry = entry {
            _name = State(initialValue: entry.name)
            _selectedCategory = State(initialValue: entry.category)
            _associations = State(initialValue: entry.associations)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Scent Name")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("e.g., Coffee scent", text: $name)
                                .font(AppFonts.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(showingNameError ? AppColors.destructiveButton : Color.clear, lineWidth: 1)
                                        }
                                )
                            
                            if showingNameError {
                                Text("Enter scent name")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.destructiveButton)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button(category) {
                                        selectedCategory = category
                                        showingCustomCategoryField = false
                                    }
                                }
                                
                                Button("Custom Category") {
                                    showingCustomCategoryField = true
                                    selectedCategory = ""
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.isEmpty ? (showingCustomCategoryField ? "Custom Category" : "Select category") : selectedCategory)
                                        .font(AppFonts.body)
                                        .foregroundColor(selectedCategory.isEmpty && !showingCustomCategoryField ? AppColors.lightText : AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(AppColors.lightText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                )
                            }
                            
                            if showingCustomCategoryField {
                                TextField("Enter custom category", text: $customCategory)
                                    .font(AppFonts.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Associations and Emotions")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .frame(minHeight: 120)
                                
                                if associations.isEmpty {
                                    Text("e.g., The smell of fresh bread reminded me of childhood mornings. Warmth, comfort and peace.")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.lightText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                                
                                TextEditor(text: $associations)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(associations.count)/\(AppConstants.Limits.maxAssociationsLength)")
                                    .font(AppFonts.caption)
                                    .foregroundColor(associations.count > AppConstants.Limits.maxAssociationsLength ? AppColors.destructiveButton : AppColors.lightText)
                            }
                        }
                        
                        if !isEditing && !name.isEmpty {
                            HStack {
                                Text("Preview Card")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                            }
                                
                                ScentEntryCard(entry: ScentEntry(
                                    name: name,
                                    category: showingCustomCategoryField ? customCategory : selectedCategory,
                                    associations: associations
                                ))
                        }
                        
                        if isEditing, let entry = entry {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date Added")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Added \(entry.dateAdded, formatter: dateFormatter)")
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground.opacity(0.5))
                                    )
                            }
                        }
                        
                        if isEditing {
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete Entry")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.destructiveButton)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.destructiveButton, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Entry" : "New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryPurple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                        dismiss()
                    }
                    .foregroundColor(name.isEmpty ? AppColors.lightText : AppColors.primaryPurple)
                    .disabled(name.isEmpty)
                }
            }
            .alert("Delete Entry", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let entry = entry {
                        viewModel.deleteEntry(entry)
                    }
                    presentationMode.wrappedValue.dismiss()
                    dismiss()
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
        .onChange(of: associations) { newValue in
            if newValue.count > AppConstants.Limits.maxAssociationsLength {
                associations = String(newValue.prefix(AppConstants.Limits.maxAssociationsLength))
            }
        }
    }
    
    private func saveEntry() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingNameError = true
            return
        }
        
        showingNameError = false
        
        let finalCategory: String
        if showingCustomCategoryField && !customCategory.isEmpty {
            finalCategory = customCategory
            viewModel.addCategory(customCategory)
        } else {
            finalCategory = selectedCategory
        }
        
        if isEditing, let existingEntry = entry {
            var updatedEntry = existingEntry
            updatedEntry.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedEntry.category = finalCategory
            updatedEntry.associations = associations.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.updateEntry(updatedEntry)
            presentationMode.wrappedValue.dismiss()
        } else {
            let newEntry = ScentEntry(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: finalCategory,
                associations: associations.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            viewModel.addEntry(newEntry)
            
            resetFields()
        }
    }
    
    private func resetFields() {
        name = ""
        selectedCategory = ""
        customCategory = ""
        associations = ""
        showingCustomCategoryField = false
        showingNameError = false
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

#Preview {
    AddEditEntryView(viewModel: ScentDiaryViewModel())
}
