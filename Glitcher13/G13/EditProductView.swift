import SwiftUI

struct EditProductView: View {
    let productId: UUID
    @ObservedObject var viewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var productName: String = ""
    @State private var selectedCategory: ProductCategory = .skincare
    @State private var firstUseDate: Date = Date()
    @State private var selectedResult: ProductResult = .neutral
    @State private var notes: String = ""
    
    private var product: Product? {
        viewModel.product(withId: productId)
    }
    
    var body: some View {
        Group {
            if product != nil {
                editProductContent
            } else {
                Text("Product not found")
                    .foregroundColor(AppColors.blueText)
            }
        }
        .onAppear {
            loadProductData()
        }
    }
    
    private func loadProductData() {
        guard let product = product else { return }
        productName = product.name
        selectedCategory = product.category
        firstUseDate = product.firstUseDate
        selectedResult = product.result
        notes = product.notes
    }
    
    private var canSave: Bool {
        !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @ViewBuilder
    private var editProductContent: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name *")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            TextField("Enter product name", text: $productName)
                                .font(.playfair(16))
                                .foregroundColor(AppColors.blueText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            Menu {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(.playfair(16))
                                        .foregroundColor(AppColors.blueText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.mediumGray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Use Date")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            DatePicker("", selection: $firstUseDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.light)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Result")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            HStack(spacing: 12) {
                                ForEach(ProductResult.allCases, id: \.self) { result in
                                    ResultSelectionButton(
                                        result: result,
                                        isSelected: selectedResult == result
                                    ) {
                                        selectedResult = result
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            TextField("Add your notes here...", text: $notes, axis: .vertical)
                                .font(.playfair(16))
                                .foregroundColor(AppColors.blueText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Experiment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.lightBlue),
                
                trailing: Button("Save Changes") {
                    saveChanges()
                }
                .foregroundColor(canSave ? AppColors.yellow : AppColors.mediumGray)
                .disabled(!canSave)
            )
        }
    }
    
    private func saveChanges() {
        guard var updatedProduct = product else { return }
        updatedProduct.name = productName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.category = selectedCategory
        updatedProduct.firstUseDate = firstUseDate
        updatedProduct.result = selectedResult
        updatedProduct.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateProduct(updatedProduct)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = ProductViewModel()
    let sampleProduct = Product(
        name: "Sample Foundation",
        category: .makeup,
        firstUseDate: Date(),
        result: .liked,
        notes: "Sample notes"
    )
    viewModel.addProduct(sampleProduct)
    
    return EditProductView(
        productId: sampleProduct.id,
        viewModel: viewModel
    )
}
