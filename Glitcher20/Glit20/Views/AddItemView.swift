import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: WardrobeViewModel
    
    @State private var itemName = ""
    @State private var selectedCategory = "Tops"
    @State private var customCategory = ""
    @State private var showingCustomCategory = false
    @State private var itemDescription = ""
    @State private var isPurchased = false
    
    private var isValidForm: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
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
                    
                    Button(action: saveItem) {
                        Text("Save")
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
            .navigationTitle("New Item")
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
    
    private func saveItem() {
        let finalCategory = showingCustomCategory ? customCategory : selectedCategory
        
        let newItem = WardrobeItem(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: finalCategory,
            description: itemDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            isPurchased: isPurchased
        )
        
        viewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddItemView(viewModel: WardrobeViewModel())
}
