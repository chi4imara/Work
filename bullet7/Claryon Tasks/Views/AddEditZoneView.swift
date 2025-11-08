import SwiftUI

struct AddEditZoneView: View {
    @ObservedObject var viewModel: CleaningZoneViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let zoneToEdit: CleaningZone?
    
    @State private var name = ""
    @State private var selectedCategory = ""
    @State private var customCategory = ""
    @State private var description = ""
    @State private var showingCustomCategoryField = false
    @State private var showingDeleteAlert = false
    @State private var showingNameError = false
    
    init(viewModel: CleaningZoneViewModel, zoneToEdit: CleaningZone? = nil) {
        self.viewModel = viewModel
        self.zoneToEdit = zoneToEdit
    }
    
    var isEditing: Bool {
        zoneToEdit != nil
    }
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var finalCategory: String {
        showingCustomCategoryField ? customCategory : selectedCategory
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Zone Name")
                                .font(.bodyMedium)
                                .foregroundColor(.primaryWhite)
                            
                            TextField("e.g., Kitchen", text: $name)
                                .font(.bodyMedium)
                                .foregroundColor(.primaryWhite)
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(showingNameError ? Color.warningRed : Color.clear, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.bodyMedium)
                                .foregroundColor(.primaryWhite)
                            
                            VStack(spacing: 0) {
                                ForEach(viewModel.categories, id: \.id) { category in
                                    CategorySelectionRow(
                                        category: category.name,
                                        isSelected: selectedCategory == category.name && !showingCustomCategoryField,
                                        onSelect: {
                                            selectedCategory = category.name
                                            showingCustomCategoryField = false
                                        }
                                    )
                                    
                                    Divider()
                                        .frame(maxWidth: .infinity)
                                        .overlay {
                                            Color.white
                                        }
                                }
                                
                                CategorySelectionRow(
                                    category: "Custom Category",
                                    isSelected: showingCustomCategoryField,
                                    onSelect: {
                                        showingCustomCategoryField = true
                                        selectedCategory = ""
                                    }
                                )
                            }
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                            
                            if showingCustomCategoryField {
                                TextField("Enter custom category", text: $customCategory)
                                    .font(.bodyMedium)
                                    .foregroundColor(.primaryWhite)
                                    .padding()
                                    .background(Color.cardBackground)
                                    .cornerRadius(10)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.bodyMedium)
                                .foregroundColor(.primaryWhite)
                            
                            TextEditor(text: $description)
                                .font(.bodyMedium)
                                .foregroundColor(.primaryWhite)
                                .frame(minHeight: 100)
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.clear, lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                        
                        if isEditing, let zone = zoneToEdit, let lastCleaned = zone.lastCleanedDate {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Cleaned")
                                    .font(.bodyMedium)
                                    .foregroundColor(.primaryWhite)
                                
                                Text(DateFormatter.mediumDate.string(from: lastCleaned))
                                    .font(.bodyMedium)
                                    .foregroundColor(.secondaryText)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.cardBackground)
                                    .cornerRadius(10)
                            }
                        }
                        
                        if isEditing {
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete Zone")
                                    .font(.bodyLarge)
                                    .foregroundColor(.warningRed)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.cardBackground)
                                    .cornerRadius(25)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Zone" : "New Zone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.accentYellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveZone()
                    }
                    .foregroundColor(canSave ? .accentYellow : .secondaryText)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Delete Zone", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let zone = zoneToEdit {
                    viewModel.deleteZone(zone)
                }
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this zone?")
        }
    }
    
    private func setupInitialValues() {
        if let zone = zoneToEdit {
            name = zone.name
            selectedCategory = zone.category
            description = zone.description
            
            if !viewModel.categories.contains(where: { $0.name == zone.category }) {
                showingCustomCategoryField = true
                customCategory = zone.category
                selectedCategory = ""
            }
        } else {
            selectedCategory = viewModel.categories.first?.name ?? ""
        }
    }
    
    private func saveZone() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showingNameError = true
            return
        }
        
        showingNameError = false
        
        if let existingZone = zoneToEdit {
            var updatedZone = existingZone
            updatedZone.name = trimmedName
            updatedZone.category = finalCategory
            updatedZone.description = description
            viewModel.updateZone(updatedZone)
        } else {
            let newZone = CleaningZone(
                name: trimmedName,
                category: finalCategory,
                description: description
            )
            viewModel.addZone(newZone)
        }
        
        if showingCustomCategoryField && !customCategory.isEmpty {
            let newCategory = Category(name: customCategory)
            if !viewModel.categories.contains(where: { $0.name == newCategory.name }) {
                viewModel.addCategory(newCategory)
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategorySelectionRow: View {
    let category: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text(category)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryWhite)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentYellow)
                }
            }
            .padding()
        }
        .background(isSelected ? Color.accentYellow.opacity(0.1) : Color.clear)
    }
}

extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    AddEditZoneView(viewModel: CleaningZoneViewModel())
}
