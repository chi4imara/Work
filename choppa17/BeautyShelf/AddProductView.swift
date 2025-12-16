import SwiftUI

struct AddProductView: View {
    let storageLocationId: UUID
    var editingProduct: Product?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = ProductViewModel()
    
    private var isEditing: Bool {
        editingProduct != nil
    }
    
    private var title: String {
        isEditing ? "Edit Product" : "New Product"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(title)
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text(isEditing ? "Update product information" : "Add a new cosmetic product")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormFieldView(
                                title: "Product Name",
                                text: $viewModel.name,
                                placeholder: "e.g., Rouge Dior Lipstick"
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Menu {
                                    ForEach(ProductCategory.allCases, id: \.self) { category in
                                        Button(category.displayName) {
                                            viewModel.selectedCategory = category
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.selectedCategory.displayName)
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(AppColors.darkText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.darkText.opacity(0.5))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                            
                            FormFieldView(
                                title: "Brand",
                                text: $viewModel.brand,
                                placeholder: "e.g., Dior"
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Storage Location")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                if let location = appViewModel.storageLocations.first(where: { $0.id == storageLocationId }) {
                                    HStack {
                                        Image(systemName: location.icon)
                                            .foregroundColor(AppColors.accentPurple)
                                        
                                        Text(location.name)
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(AppColors.darkText)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(AppColors.cardBackground.opacity(0.5))
                                    .cornerRadius(12)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Expiration Date")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text("(Optional)")
                                        .font(.ubuntu(14, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $viewModel.hasExpirationDate)
                                        .toggleStyle(SwitchToggleStyle(tint: AppColors.primaryYellow))
                                }
                                
                                if viewModel.hasExpirationDate {
                                    DatePicker(
                                        "Select Date",
                                        selection: Binding(
                                            get: { viewModel.expirationDate ?? Date() },
                                            set: { viewModel.expirationDate = $0 }
                                        ),
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Notes")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text("(Optional)")
                                        .font(.ubuntu(14, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Spacer()
                                }
                                
                                TextField("e.g., For evening makeup only", text: $viewModel.notes, axis: .vertical)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.darkText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: saveProduct) {
                        Text(isEditing ? "Update" : "Save")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.isValid ? AppColors.buttonBackground : AppColors.buttonBackground.opacity(0.5))
                            .cornerRadius(16)
                    }
                    .disabled(!viewModel.isValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .onAppear {
            setupViewModel()
        }
    }
    
    private func setupViewModel() {
        viewModel.storageLocationId = storageLocationId
        
        if let product = editingProduct {
            viewModel.populate(from: product)
        }
    }
    
    private func saveProduct() {
        guard let product = viewModel.createProduct() else { return }
        
        if isEditing {
            var updatedProduct = product
            updatedProduct.id = editingProduct!.id
            updatedProduct.createdAt = editingProduct!.createdAt
            appViewModel.updateProduct(updatedProduct)
        } else {
            appViewModel.addProduct(product, to: storageLocationId)
        }
        
        dismiss()
    }
}

#Preview {
    AddProductView(storageLocationId: UUID())
        .environmentObject(AppViewModel())
}
