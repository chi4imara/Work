import SwiftUI

struct EditProductView: View {
    @EnvironmentObject var productStore: ProductStore
    @Environment(\.presentationMode) var presentationMode
    
    let productId: UUID
    @State private var productName: String
    @State private var selectedStatus: ProductStatus
    @State private var showingSaveAlert = false
    
    init(productId: UUID) {
        self.productId = productId
        _productName = State(initialValue: "")
        _selectedStatus = State(initialValue: .suitable)
    }
    
    private var product: Product? {
        productStore.products.first { $0.id == productId }
    }
    
    var isFormValid: Bool {
        !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("Edit Product")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("Update product information")
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Enter product name", text: $productName)
                                .font(.playfairDisplay(size: 16, weight: .regular))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(ColorManager.lightBlue, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            HStack(spacing: 12) {
                                StatusButton(
                                    title: "Suitable",
                                    status: .suitable,
                                    isSelected: selectedStatus == .suitable,
                                    action: { selectedStatus = .suitable }
                                )
                                
                                StatusButton(
                                    title: "Not Suitable",
                                    status: .unsuitable,
                                    isSelected: selectedStatus == .unsuitable,
                                    action: { selectedStatus = .unsuitable }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveProduct) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Save Changes")
                        }
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(ColorManager.whiteText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isFormValid ? AnyShapeStyle(ColorManager.buttonGradient) : AnyShapeStyle(ColorManager.secondaryText.opacity(0.3)))
                        )
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorManager.primaryBlue)
            }
        }
        .onAppear {
            if let product = product {
                productName = product.name
                selectedStatus = product.status
            }
        }
        .alert("Product Updated", isPresented: $showingSaveAlert) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("'\(productName)' has been updated successfully.")
        }
    }
    
    private func saveProduct() {
        guard let product = product else { return }
        let trimmedName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        var updatedProduct = product
        updatedProduct.name = trimmedName
        updatedProduct.status = selectedStatus
        
        productStore.updateProduct(updatedProduct)
        showingSaveAlert = true
    }
}

struct StatusButton: View {
    let title: String
    let status: ProductStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                    .frame(width: 12, height: 12)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.whiteText : ColorManager.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? 
                          (status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed) : 
                          Color.white
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed,
                                lineWidth: isSelected ? 0 : 1
                            )
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
