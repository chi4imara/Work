import SwiftUI

struct CreateEditProductView: View {
    @ObservedObject var viewModel: ProductsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let productToEdit: Product?
    
    @State private var name = ""
    @State private var selectedCategory: ProductCategory = .face
    @State private var shade = ""
    @State private var comment = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: ProductsViewModel, productToEdit: Product? = nil) {
        self.viewModel = viewModel
        self.productToEdit = productToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormSection(title: "Product Name *") {
                            CustomTextField(
                                placeholder: "e.g., MAC Ruby Woo Lipstick",
                                text: $name
                            )
                        }
                        
                        FormSection(title: "Category") {
                            ProductCategorySelector(selectedCategory: $selectedCategory)
                        }
                        
                        FormSection(title: "Shade/Number") {
                            CustomTextField(
                                placeholder: "e.g., #707 Ruby Woo",
                                text: $shade
                            )
                        }
                        
                        FormSection(title: "Comment") {
                            CustomTextEditor(
                                placeholder: "Classic matte lipstick",
                                text: $comment
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle(productToEdit == nil ? "Add Product" : "Edit Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProduct()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.medium)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            loadProductData()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadProductData() {
        if let product = productToEdit {
            name = product.name
            selectedCategory = product.category
            shade = product.shade
            comment = product.comment
        }
    }
    
    private func saveProduct() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Product name is required"
            showingAlert = true
            return
        }
        
        if let existingProduct = productToEdit {
            var updatedProduct = existingProduct
            updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.category = selectedCategory
            updatedProduct.shade = shade.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.updateProduct(updatedProduct)
        } else {
            let newProduct = Product(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                shade: shade.trimmingCharacters(in: .whitespacesAndNewlines),
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            viewModel.addProduct(newProduct)
        }
        
        dismiss()
    }
}

struct ProductCategorySelector: View {
    @Binding var selectedCategory: ProductCategory
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(ProductCategory.allCases, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category.rawValue)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(selectedCategory == category ? AppColors.primaryText : AppColors.darkText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedCategory == category ? AppColors.buttonPrimary : AppColors.cardBackground)
                        )
                }
                .animation(.easeInOut(duration: 0.2), value: selectedCategory)
            }
        }
    }
}

#Preview {
    CreateEditProductView(viewModel: ProductsViewModel())
}
