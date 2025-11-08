import SwiftUI

struct AddEditCollectionView: View {
    @ObservedObject var collectionsViewModel: CollectionsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let collectionToEdit: MovieCollection?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedColor: MovieCollection.CollectionColor = .blue
    @State private var nameError: String = ""
    
    private var isEditing: Bool {
        collectionToEdit != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Collection" : "New Collection"
    }
    
    init(collectionsViewModel: CollectionsViewModel, collectionToEdit: MovieCollection? = nil) {
        self.collectionsViewModel = collectionsViewModel
        self.collectionToEdit = collectionToEdit
        
        if let collection = collectionToEdit {
            _name = State(initialValue: collection.name)
            _description = State(initialValue: collection.description)
            _selectedColor = State(initialValue: collection.color)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormField(
                            title: "Collection Name",
                            text: $name,
                            placeholder: "Enter collection name",
                            errorMessage: nameError,
                            isRequired: true
                        )
                        
                        FormSection(title: "Description") {
                            TextEditor(text: $description)
                                .font(AppFonts.body)
                                .frame(minHeight: 80)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.secondaryText.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        FormSection(title: "Color") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(MovieCollection.CollectionColor.allCases, id: \.self) { color in
                                    ColorOptionView(
                                        color: color,
                                        isSelected: selectedColor == color
                                    ) {
                                        selectedColor = color
                                    }
                                }
                            }
                        }
                        
                        if !name.isEmpty {
                            FormSection(title: "Preview") {
                                CollectionPreviewCard(
                                    name: name,
                                    description: description,
                                    color: selectedColor
                                )
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCollection()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        name.count <= 50
    }
    
    private func saveCollection() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            nameError = "Collection name is required"
            return
        }
        
        if trimmedName.count > 50 {
            nameError = "Collection name must be 50 characters or less"
            return
        }
        
        if let collectionToEdit = collectionToEdit {
            var updatedCollection = collectionToEdit
            updatedCollection.name = trimmedName
            updatedCollection.description = trimmedDescription
            updatedCollection.color = selectedColor
            
            collectionsViewModel.updateCollection(updatedCollection)
        } else {
            let newCollection = MovieCollection(
                name: trimmedName,
                description: trimmedDescription,
                color: selectedColor
            )
            
            collectionsViewModel.addCollection(newCollection)
        }
        
        dismiss()
    }
}

struct ColorOptionView: View {
    let color: MovieCollection.CollectionColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color.colorValue)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct CollectionPreviewCard: View {
    let name: String
    let description: String
    let color: MovieCollection.CollectionColor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(color.colorValue)
                    .frame(width: 12, height: 12)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
                Text(description.isEmpty ? "No description" : description)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(3)
            }
            
            HStack {
                Image(systemName: "film")
                    .font(.system(size: 12))
                    .foregroundColor(color.colorValue)
                
                Text("0 movies")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    AddEditCollectionView(
        collectionsViewModel: CollectionsViewModel()
    )
}
