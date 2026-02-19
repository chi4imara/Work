import SwiftUI

struct AddAccessoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name = ""
    @State private var selectedCategory = "Earrings"
    @State private var customCategory = ""
    @State private var description = ""
    @State private var selectedOutfitIds: Set<UUID> = []
    @State private var showingNewOutfit = false
    @State private var showingCustomCategory = false
    
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
                                .frame(maxWidth: .infinity)
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
            .navigationTitle("New Accessory")
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
                    Button("Save") {
                        saveAccessory()
                    }
                    .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingNewOutfit) {
            AddOutfitView()
        }
    }
    
    private func saveAccessory() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let category = showingCustomCategory ? customCategory : selectedCategory
        
        let newAccessory = Accessory(
            name: trimmedName,
            category: category,
            description: trimmedDescription,
            outfitIds: selectedOutfitIds
        )
        
        if showingCustomCategory && !customCategory.isEmpty {
            dataManager.addCategory(customCategory)
        }
        
        dataManager.addAccessory(newAccessory)
        presentationMode.wrappedValue.dismiss()
    }
}

struct OutfitCheckboxRow: View {
    let outfit: Outfit
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.secondaryText)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(outfit.name)
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !outfit.description.isEmpty {
                        Text(outfit.description)
                            .font(.playfairDisplay(size: 12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddAccessoryView()
        .environmentObject(DataManager.shared)
}
