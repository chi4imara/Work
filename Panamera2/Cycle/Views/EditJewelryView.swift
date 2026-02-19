import SwiftUI

struct EditJewelryView: View {
    @Environment(\.presentationMode) var presentationMode
    let item: JewelryItem
    let store: JewelryStore
    
    @State private var name: String
    @State private var selectedCategory: JewelryCategory
    @State private var customCategoryName = ""
    @State private var description: String
    @State private var showingCustomCategory = false
    
    init(item: JewelryItem, store: JewelryStore) {
        self.item = item
        self.store = store
        self._name = State(initialValue: item.name)
        self._selectedCategory = State(initialValue: item.category)
        self._description = State(initialValue: item.description)
        self._showingCustomCategory = State(initialValue: item.category == .custom)
        self._customCategoryName = State(initialValue: item.customCategoryName ?? "")
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.bauhausRegular(size: 16))
                            .foregroundColor(AppColors.primaryWhite)
                            
                            Spacer()
                            
                            Text("Edit Jewelry")
                                .font(.bauhausBold(size: 20))
                                .foregroundColor(AppColors.primaryWhite)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveChanges()
                            }
                            .font(.bauhausBold(size: 16))
                            .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.primaryWhite.opacity(0.5))
                            .disabled(!isFormValid)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        VStack(spacing: 20) {
                            FormField(title: "Name*", text: $name, placeholder: "Enter jewelry name")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.bauhausBold(size: 16))
                                    .foregroundColor(AppColors.primaryWhite)
                                
                                Menu {
                                    ForEach(JewelryCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                                        Button(category.displayName) {
                                            selectedCategory = category
                                            showingCustomCategory = false
                                        }
                                    }
                                    
                                    Button("Create Category") {
                                        showingCustomCategory = true
                                    }
                                } label: {
                                    HStack {
                                        Text(showingCustomCategory ? "Custom Category" : selectedCategory.displayName)
                                            .font(.bauhausRegular(size: 16))
                                            .foregroundColor(AppColors.darkGray)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.darkGray)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                                }
                                
                                if showingCustomCategory {
                                    FormField(title: "", text: $customCategoryName, placeholder: "Enter category name")
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.bauhausBold(size: 16))
                                    .foregroundColor(AppColors.primaryWhite)
                                
                                TextEditor(text: $description)
                                    .font(.bauhausRegular(size: 16))
                                    .padding(12)
                                    .frame(minHeight: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.darkGray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Worn")
                                    .font(.bauhausBold(size: 16))
                                    .foregroundColor(AppColors.primaryWhite)
                                
                                Text(item.lastWornText)
                                    .font(.bauhausRegular(size: 16))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground.opacity(0.7))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveChanges() {
        let finalCategory: JewelryCategory
        let finalCustomName: String?
        
        if showingCustomCategory && !customCategoryName.isEmpty {
            store.addCustomCategory(customCategoryName)
            finalCategory = .custom
            finalCustomName = customCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            finalCategory = selectedCategory
            finalCustomName = nil
        }
        
        var updatedItem = item
        updatedItem.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.category = finalCategory
        updatedItem.customCategoryName = finalCustomName
        updatedItem.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        store.updateItem(updatedItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleItem = JewelryItem(
        name: "Diamond Earrings",
        category: .earrings,
        description: "Beautiful diamond earrings",
        lastWornDate: Date()
    )
    
    EditJewelryView(item: sampleItem, store: JewelryStore())
}
