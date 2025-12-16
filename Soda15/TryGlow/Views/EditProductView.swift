import SwiftUI

struct EditProductView: View {
    let product: BeautyProduct
    @ObservedObject var viewModel: BeautyProductViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedCategory: ProductCategory
    @State private var description: String
    @State private var rating: Int
    @State private var comment: String
    @State private var showingValidationAlert = false
    
    private let colorManager = ColorManager.shared
    
    init(product: BeautyProduct, viewModel: BeautyProductViewModel) {
        self.product = product
        self.viewModel = viewModel
        
        _name = State(initialValue: product.name)
        _selectedCategory = State(initialValue: product.category)
        _description = State(initialValue: product.description)
        _rating = State(initialValue: product.rating)
        _comment = State(initialValue: product.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                colorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            TextField("Enter product name", text: $name)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.secondaryText)
                                .padding(15)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            HStack(spacing: 12) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
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
                            Text("Description / Impressions")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            TextEditor(text: $description)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.secondaryText)
                                .scrollContentBackground(.hidden)
                                .padding(15)
                                .frame(minHeight: 100)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        rating = star
                                    }) {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .font(.system(size: 24))
                                            .foregroundColor(star <= rating ? colorManager.primaryYellow : colorManager.primaryWhite.opacity(0.5))
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            TextEditor(text: $comment)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.secondaryText)
                                .scrollContentBackground(.hidden)
                                .padding(15)
                                .frame(minHeight: 80)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Discovery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(colorManager.primaryWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(colorManager.primaryWhite)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text("To save the discovery, specify at least the name and category.")
        }
    }
    
    private func saveChanges() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingValidationAlert = true
            return
        }
        
        var updatedProduct = product
        updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.category = selectedCategory
        updatedProduct.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.rating = rating
        updatedProduct.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateProduct(updatedProduct)
        dismiss()
    }
}

#Preview {
    EditProductView(
        product: BeautyProduct(
            name: "Vitamin C Serum",
            category: .skincare,
            description: "Light texture, absorbs quickly",
            rating: 5,
            comment: "Great for morning routine"
        ),
        viewModel: BeautyProductViewModel()
    )
}
