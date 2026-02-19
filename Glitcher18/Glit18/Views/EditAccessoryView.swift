import SwiftUI

struct EditAccessoryView: View {
    let accessory: Accessory
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name: String
    @State private var selectedCategory: String
    @State private var customCategory = ""
    @State private var description: String
    @State private var selectedOutfitIds: Set<UUID>
    @State private var showingNewOutfit = false
    @State private var showingCustomCategory = false
    
    init(accessory: Accessory) {
        self.accessory = accessory
        self._name = State(initialValue: accessory.name)
        self._selectedCategory = State(initialValue: accessory.category)
        self._description = State(initialValue: accessory.description)
        self._selectedOutfitIds = State(initialValue: accessory.outfitIds)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var finalCategory: String {
        showingCustomCategory ? customCategory : selectedCategory
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Accessory Name *")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter name", text: $name)
                                .customTextField()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            if showingCustomCategory {
                                VStack(spacing: 12) {
                                    TextField("Enter custom category", text: $customCategory)
                                        .customTextField()
                                    
                                    Button(action: {
                                        showingCustomCategory = false
                                        customCategory = ""
                                    }) {
                                        Text("Use predefined categories")
                                            .font(.playfairDisplay(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.accentYellow)
                                    }
                                }
                            } else {
                                VStack(spacing: 12) {
                                    Menu {
                                        ForEach(Category.defaultCategories, id: \.self) { category in
                                            Button(action: {
                                                selectedCategory = category
                                            }) {
                                                HStack {
                                                    Text(category)
                                                    if selectedCategory == category {
                                                        Image(systemName: "checkmark")
                                                    }
                                                }
                                            }
                                        }
                                        
                                        let customCategories = dataManager.categories.map { $0.name }.filter { !Category.defaultCategories.contains($0) }
                                        if !customCategories.isEmpty {
                                            Divider()
                                            ForEach(customCategories, id: \.self) { category in
                                                Button(action: {
                                                    selectedCategory = category
                                                }) {
                                                    HStack {
                                                        Text(category)
                                                        if selectedCategory == category {
                                                            Image(systemName: "checkmark")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        Button(action: {
                                            showingCustomCategory = true
                                        }) {
                                            HStack {
                                                Text("Create custom category")
                                                Image(systemName: "plus")
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedCategory)
                                                .font(.playfairDisplay(size: 16))
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(AppColors.accentYellow)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(AppColors.cardGradient)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.cardBorder, lineWidth: 1)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter description", text: $description, axis: .vertical)
                                .lineLimit(3...6)
                                .customTextField()
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Outfit List")
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingNewOutfit = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus")
                                        Text("Create Outfit")
                                    }
                                    .font(.playfairDisplay(size: 14, weight: .medium))
                                    .foregroundColor(AppColors.accentYellow)
                                }
                            }
                            
                            if dataManager.outfits.isEmpty {
                                VStack(spacing: 12) {
                                    Text("No outfits added yet. Create your first outfit.")
                                        .font(.playfairDisplay(size: 14, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                        .multilineTextAlignment(.center)
                                    
                                    Button(action: {
                                        showingNewOutfit = true
                                    }) {
                                        Text("Create Outfit")
                                            .secondaryButton()
                                    }
                                }
                                .padding()
                                .glassCard()
                            } else {
                                LazyVStack(spacing: 8) {
                                    ForEach(dataManager.outfits) { outfit in
                                        OutfitCheckboxRow(
                                            outfit: outfit,
                                            isSelected: selectedOutfitIds.contains(outfit.id)
                                        ) {
                                            if selectedOutfitIds.contains(outfit.id) {
                                                selectedOutfitIds.remove(outfit.id)
                                            } else {
                                                selectedOutfitIds.insert(outfit.id)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Accessory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingNewOutfit) {
            AddOutfitView()
        }
        .onAppear {
            if !Category.defaultCategories.contains(selectedCategory) {
                showingCustomCategory = true
                customCategory = selectedCategory
            }
        }
    }
    
    private func saveChanges() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let category = showingCustomCategory ? customCategory : selectedCategory
        
        var updatedAccessory = accessory
        updatedAccessory.name = trimmedName
        updatedAccessory.category = category
        updatedAccessory.description = trimmedDescription
        updatedAccessory.outfitIds = selectedOutfitIds
        
        if showingCustomCategory && !customCategory.isEmpty {
            dataManager.addCategory(customCategory)
        }
        
        dataManager.updateAccessory(updatedAccessory)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditAccessoryView(
        accessory: Accessory(
            name: "Diamond Earrings",
            category: "Earrings",
            description: "Beautiful diamond earrings"
        )
    )
    .environmentObject(DataManager.shared)
}
