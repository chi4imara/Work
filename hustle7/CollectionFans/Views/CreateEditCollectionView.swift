import SwiftUI

struct CreateEditCollectionView: View {
    @ObservedObject var store: CollectionStore
    let collection: Collection?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var selectedCategory: CollectionCategory = .other
    @State private var description: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    @State private var hasChanges = false
    
    private var isEditing: Bool {
        collection != nil
    }
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        name.count <= 50 &&
        description.count <= 200
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Collection Name")
                                    .font(.captionLarge)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("Enter collection name", text: $name)
                                    .font(.bodyLarge)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                               .fill(Color.cardBackground)
                                               .overlay(
                                                   RoundedRectangle(cornerRadius: 12)
                                                       .stroke(name.isEmpty ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
                                               )
                                    )
                                    .onChange(of: name) { _ in
                                        hasChanges = true
                                    }
                                
                                if name.isEmpty {
                                    Text("Collection name is required")
                                        .font(.captionSmall)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.captionLarge)
                                    .foregroundColor(.textPrimary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                    ForEach(CollectionCategory.allCases) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                            hasChanges = true
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Description")
                                        .font(.captionLarge)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Optional")
                                        .font(.captionSmall)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .frame(height: 100)
                                    
                                    TextEditor(text: $description)
                                        .font(.bodyMedium)
                                        .padding(12)
                                        .background(Color.clear)
                                        .onChange(of: description) { _ in
                                            hasChanges = true
                                        }
                                    
                                    if description.isEmpty {
                                        Text("Add a description for your collection...")
                                            .font(.bodyMedium)
                                            .foregroundColor(.textSecondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 20)
                                            .allowsHitTesting(false)
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("\(description.count)/200")
                                        .font(.captionSmall)
                                        .foregroundColor(description.count > 200 ? .red : .textSecondary)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            Button(action: saveCollection) {
                                Text(isEditing ? "Update Collection" : "Create Collection")
                                    .font(.buttonLarge)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(isValidForm ? Color.primaryBlue : Color.textSecondary)
                                    )
                            }
                            .disabled(!isValidForm)
                            
                            if isEditing {
                                Button(action: { showingDeleteAlert = true }) {
                                    Text("Delete Collection")
                                        .font(.buttonMedium)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Collection" : "New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            setupForm()
        }
        .alert("Delete Collection", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let collection = collection {
                    store.deleteCollection(collection)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this collection and all its items?")
        }
        .alert("Discard Changes", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }
    
    private func setupForm() {
        if let collection = collection {
            name = collection.name
            selectedCategory = collection.category
            description = collection.description
        }
    }
    
    private func saveCollection() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingCollection = collection {
            var updatedCollection = existingCollection
            updatedCollection.name = trimmedName
            updatedCollection.category = selectedCategory
            updatedCollection.description = description
            store.updateCollection(updatedCollection)
        } else {
            let newCollection = Collection(
                name: trimmedName,
                category: selectedCategory,
                description: description
            )
            store.addCollection(newCollection)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategoryButton: View {
    let category: CollectionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primaryBlue)
                
                Text(category.rawValue)
                    .font(.captionMedium)
                    .foregroundColor(isSelected ? .white : .textPrimary)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                       .fill(isSelected ? Color.primaryBlue : Color.cardBackground)
                       .overlay(
                           RoundedRectangle(cornerRadius: 12)
                               .stroke(isSelected ? Color.clear : Color.lightBlue, lineWidth: 1)
                       )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CreateEditCollectionView(store: CollectionStore(), collection: nil)
}
