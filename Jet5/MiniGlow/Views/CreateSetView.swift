import SwiftUI

struct CreateSetView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingSet: CosmeticSet?
    
    @State private var name = ""
    @State private var selectedCategory: SetCategory = .office
    @State private var selectedProducts: [Product] = []
    @State private var comment = ""
    @State private var isReady = false
    @State private var showingProductSelection = false
    
    init(appViewModel: AppViewModel, editingSet: CosmeticSet? = nil) {
        self.appViewModel = appViewModel
        self.editingSet = editingSet
        
        if let set = editingSet {
            _name = State(initialValue: set.name)
            _selectedCategory = State(initialValue: set.category)
            _selectedProducts = State(initialValue: set.products)
            _comment = State(initialValue: set.comment)
            _isReady = State(initialValue: set.isReady)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !selectedProducts.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Set Name")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Travel Set", text: $name)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(SetCategory.allCases, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Products")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Button("Select Products") {
                                    showingProductSelection = true
                                }
                                .font(.buttonSmall)
                                .foregroundColor(.primaryPurple)
                            }
                            
                            if selectedProducts.isEmpty {
                                Text("Product list is empty. Add at least one item to save the set.")
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.cardBackground.opacity(0.5))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.cardBorder.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(selectedProducts) { product in
                                        ProductRowView(product: product) {
                                            selectedProducts.removeAll { $0.id == product.id }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Add travel-size versions of cream and shampoo", text: $comment, axis: .vertical)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(minHeight: 80, alignment: .topLeading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        HStack {
                            Text("Ready Status")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isReady)
                                .toggleStyle(CustomToggleStyle())
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingSet == nil ? "Create Set" : "Edit Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSet()
                    }
                    .foregroundColor(isFormValid ? .primaryPurple : .textSecondary)
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingProductSelection) {
            ProductSelectionView(
                availableProducts: appViewModel.products,
                selectedProducts: $selectedProducts
            )
        }
    }
    
    private func saveSet() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingSet = editingSet {
            var updatedSet = editingSet
            updatedSet.name = trimmedName
            updatedSet.category = selectedCategory
            updatedSet.products = selectedProducts
            updatedSet.comment = comment
            updatedSet.isReady = isReady
            
            appViewModel.updateCosmeticSet(updatedSet)
        } else {
            let newSet = CosmeticSet(
                name: trimmedName,
                category: selectedCategory,
                products: selectedProducts,
                comment: comment,
                isReady: isReady
            )
            
            appViewModel.addCosmeticSet(newSet)
        }
        
        dismiss()
    }
}

struct CategoryButton: View {
    let category: SetCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.buttonMedium)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.buttonPrimary : Color.buttonSecondary)
                )
        }
    }
}

struct ProductRowView: View {
    let product: Product
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                HStack {
                    Text(product.category.displayName)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if !product.volume.isEmpty {
                        Text("• \(product.volume)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.buttonDestructive)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBackground.opacity(0.5))
        )
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text(configuration.isOn ? "Ready" : "Not Ready")
                .font(.buttonSmall)
                .foregroundColor(configuration.isOn ? .statusReady : .statusNotReady)
            
            Button(action: {
                configuration.isOn.toggle()
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? Color.statusReady : Color.buttonSecondary)
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 26, height: 26)
                            .offset(x: configuration.isOn ? 10 : -10)
                    )
            }
        }
    }
}

#Preview {
    CreateSetView(appViewModel: AppViewModel())
}
