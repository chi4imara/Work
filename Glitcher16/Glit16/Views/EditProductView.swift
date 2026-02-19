import SwiftUI

struct EditProductView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    let product: Product
    
    @State private var name: String
    @State private var selectedCategory: String
    @State private var newCategoryName: String = ""
    @State private var showingNewCategoryField: Bool = false
    @State private var rating: Int
    @State private var expirationDate: Date
    @State private var comment: String
    
    init(product: Product) {
        self.product = product
        self._name = State(initialValue: product.name)
        self._selectedCategory = State(initialValue: product.category)
        self._rating = State(initialValue: product.rating)
        self._expirationDate = State(initialValue: product.expirationDate)
        self._comment = State(initialValue: product.comment)
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (!showingNewCategoryField || !newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty) &&
        (!selectedCategory.isEmpty || showingNewCategoryField)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColorScheme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter product name", text: $name)
                                .font(.playfairDisplay(16))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            if showingNewCategoryField {
                                HStack {
                                    TextField("Enter new category", text: $newCategoryName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 12)
                                        .background(Color.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                    
                                    Button("Cancel") {
                                        showingNewCategoryField = false
                                        newCategoryName = ""
                                    }
                                    .font(.playfairDisplay(14, weight: .medium))
                                    .foregroundColor(.textSecondary)
                                }
                            } else {
                                Menu {
                                    ForEach(productViewModel.categories, id: \.name) { category in
                                        Button(category.name) {
                                            selectedCategory = category.name
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Button("Create New Category") {
                                        showingNewCategoryField = true
                                        selectedCategory = ""
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(selectedCategory.isEmpty ? .textSecondary : .textPrimary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 12)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            HStack {
                                StarRatingView(rating: $rating, size: 24, interactive: true)
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Expiration Date")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            DatePicker("", selection: $expirationDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Add your notes...", text: $comment, axis: .vertical)
                                .font(.playfairDisplay(16))
                                .foregroundColor(.textPrimary)
                                .lineLimit(3...6)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        CustomButton(title: "Save Changes", style: .primary, isEnabled: canSave, action: saveChanges)
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Edit Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveChanges() {
        let finalCategory = showingNewCategoryField ? newCategoryName : selectedCategory
        
        var updatedProduct = product
        updatedProduct.name = name.trimmingCharacters(in: .whitespaces)
        updatedProduct.category = finalCategory.trimmingCharacters(in: .whitespaces)
        updatedProduct.rating = rating
        updatedProduct.expirationDate = expirationDate
        updatedProduct.comment = comment.trimmingCharacters(in: .whitespaces)
        
        productViewModel.updateProduct(updatedProduct)
        dismiss()
    }
}

#Preview {
    EditProductView(product: Product(
        name: "Sample Product",
        category: "Sample Category",
        rating: 4,
        expirationDate: Date(),
        comment: "Sample comment"
    ))
    .environmentObject(ProductViewModel())
}
