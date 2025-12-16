import SwiftUI

struct AddProductView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingProduct: Product?
    
    @State private var name = ""
    @State private var selectedCategory: ProductCategory = .skincare
    @State private var volume = ""
    @State private var comment = ""
    
    init(appViewModel: AppViewModel, editingProduct: Product? = nil) {
        self.appViewModel = appViewModel
        self.editingProduct = editingProduct
        
        if let product = editingProduct {
            _name = State(initialValue: product.name)
            _selectedCategory = State(initialValue: product.category)
            _volume = State(initialValue: product.volume)
            _comment = State(initialValue: product.comment)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Lip Balm", text: $name)
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
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    ProductCategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Volume/Size")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            TextField("10 ml", text: $volume)
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
                            Text("Comment")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Better to keep a duplicate in the office", text: $comment, axis: .vertical)
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
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingProduct == nil ? "Add Product" : "Edit Product")
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
                        saveProduct()
                    }
                    .foregroundColor(isFormValid ? .primaryPurple : .textSecondary)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveProduct() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingProduct = editingProduct {
            var updatedProduct = editingProduct
            updatedProduct.name = trimmedName
            updatedProduct.category = selectedCategory
            updatedProduct.volume = volume.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            appViewModel.updateProduct(updatedProduct)
        } else {
            let newProduct = Product(
                name: trimmedName,
                category: selectedCategory,
                volume: volume.trimmingCharacters(in: .whitespacesAndNewlines),
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            appViewModel.addProduct(newProduct)
        }
        
        dismiss()
    }
}

struct ProductCategoryButton: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: categoryIcon(for: category))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .textSecondary)
                
                Text(category.displayName)
                    .font(.buttonSmall)
                    .foregroundColor(isSelected ? .white : .textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.buttonPrimary : Color.buttonSecondary)
            )
        }
    }
    
    private func categoryIcon(for category: ProductCategory) -> String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .hair:
            return "scissors"
        case .other:
            return "star.fill"
        }
    }
}

#Preview {
    AddProductView(appViewModel: AppViewModel())
}
