import SwiftUI

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    let itemId: UUID
    let viewModel: WardrobeViewModel
    
    @State private var itemName: String = ""
    @State private var selectedCategory: String = ""
    @State private var customCategory = ""
    @State private var showingCustomCategory = false
    @State private var itemDescription: String = ""
    @State private var isPurchased: Bool = false
    
    private var item: WardrobeItem? {
        viewModel.getItem(by: itemId)
    }
    
    init(itemId: UUID, viewModel: WardrobeViewModel) {
        self.itemId = itemId
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if let item = item {
                editItemContent(item: item)
            } else {
                Text("Item not found")
                    .font(FontManager.playfairDisplay(size: 18))
                    .foregroundColor(Color.textSecondary)
            }
        }
        .onAppear {
            if let item = item {
                itemName = item.name
                selectedCategory = item.category
                itemDescription = item.description
                isPurchased = item.isPurchased
            }
        }
    }
    
    private var isValidForm: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func editItemContent(item: WardrobeItem) -> some View {
        NavigationView {
            ZStack {
                AppColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item Name")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(Color.textPrimary)
                            
                            TextField("Enter item name", text: $itemName)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(Color.textPrimary)
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(Color.textPrimary)
                            
                            Menu {
                                ForEach(WardrobeItem.defaultCategories, id: \.self) { category in
                                    Button(category) {
                                        selectedCategory = category
                                        showingCustomCategory = false
                                    }
                                }
                                
                                Button("Create Custom Category") {
                                    showingCustomCategory = true
                                }
                            } label: {
                                HStack {
                                    Text(showingCustomCategory ? "Custom Category" : selectedCategory)
                                        .font(FontManager.playfairDisplay(size: 16))
                                        .foregroundColor(Color.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.textSecondary)
                                }
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                            }
                            
                            if showingCustomCategory {
                                TextField("Enter custom category", text: $customCategory)
                                    .font(FontManager.playfairDisplay(size: 16))
                                    .foregroundColor(Color.textPrimary)
                                    .padding()
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(Color.textPrimary)
                            
                            TextField("Enter description", text: $itemDescription, axis: .vertical)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(Color.textPrimary)
                                .padding()
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .lineLimit(3...6)
                        }
                        
                        HStack {
                            Text("Mark as purchased")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(Color.textPrimary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isPurchased)
                                .toggleStyle(SwitchToggleStyle(tint: Color.primaryYellow))
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(isValidForm ? Color.primaryPurple : Color.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(isValidForm ? Color.primaryYellow : Color.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    .disabled(!isValidForm)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.textPrimary)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveChanges() {
        guard let item = item else { return }
        let finalCategory = showingCustomCategory ? customCategory : selectedCategory
        
        var updatedItem = item
        updatedItem.name = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.category = finalCategory
        updatedItem.description = itemDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.isPurchased = isPurchased
        
        viewModel.updateItem(updatedItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = WardrobeViewModel()
    let item = WardrobeItem(name: "White Shirt", category: "Tops", description: "A classic white shirt")
    viewModel.addItem(item)
    return EditItemView(
        itemId: item.id,
        viewModel: viewModel
    )
}
