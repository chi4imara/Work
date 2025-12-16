import SwiftUI

struct EditProductView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let product: Product
    
    @State private var productName = ""
    @State private var selectedCategory = ""
    @State private var quantity = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingDeleteAlert = false
    
    var isFormValid: Bool {
        !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        ColorManager.backgroundGradientStart,
                        ColorManager.backgroundGradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                        .frame(width: CGFloat.random(in: 30...60))
                        .position(
                            x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
                            y: CGFloat.random(in: 100...(UIScreen.main.bounds.height - 200))
                        )
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...6))
                                .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 8) {
                            Text("Edit Product")
                                .font(FontManager.ubuntuBold(28))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text("Update the details for your product")
                                .font(FontManager.ubuntu(16))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Product Name *")
                                    .font(FontManager.ubuntuMedium(16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("e.g. Bread, Milk, Coffee", text: $productName)
                                    .font(FontManager.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryBlue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(FontManager.ubuntuMedium(16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Menu {
                                    ForEach(viewModel.categories, id: \.id) { category in
                                        Button(category.name) {
                                            selectedCategory = category.name
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory)
                                            .font(FontManager.ubuntu(16))
                                            .foregroundColor(ColorManager.primaryBlue)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(ColorManager.primaryBlue)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Quantity (Optional)")
                                    .font(FontManager.ubuntuMedium(16))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("e.g. 2 pcs, 1 pack", text: $quantity)
                                    .font(FontManager.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryBlue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        if showingError {
                            Text(errorMessage)
                                .font(FontManager.ubuntu(14))
                                .foregroundColor(ColorManager.buttonDanger)
                                .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 15) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(FontManager.ubuntuMedium(18))
                                    .foregroundColor(isFormValid ? ColorManager.primaryBlue : ColorManager.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .concaveCard(
                                        cornerRadius: 25,
                                        depth: isFormValid ? 4 : 2,
                                        color: isFormValid ? ColorManager.primaryYellow : ColorManager.buttonSecondary
                                    )
                            }
                            .disabled(!isFormValid)
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete Product")
                                    .font(FontManager.ubuntuMedium(16))
                                    .foregroundColor(ColorManager.primaryWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .concaveCard(cornerRadius: 22, depth: 3, color: ColorManager.buttonDanger)
                            }
                        
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .font(FontManager.ubuntuMedium(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .concaveCard(cornerRadius: 22, depth: 2, color: ColorManager.buttonSecondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                setupInitialValues()
            }
            .alert("Delete Product", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteProduct()
                }
            } message: {
                Text("Are you sure you want to delete this product from your list?")
            }
        }
    }
    
    private func setupInitialValues() {
        productName = product.name
        selectedCategory = product.category
        quantity = product.quantity
    }
    
    private func saveChanges() {
        let trimmedName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            showError("Please enter a product name")
            return
        }
        
        var updatedProduct = product
        updatedProduct.name = trimmedName
        updatedProduct.category = selectedCategory
        updatedProduct.quantity = quantity.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateProduct(updatedProduct)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteProduct() {
        viewModel.deleteProduct(product)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showingError = false
        }
    }
}

#Preview {
    EditProductView(
        viewModel: ShoppingListViewModel(),
        product: Product(name: "Test Product", category: "Products", quantity: "1 pc")
    )
}
