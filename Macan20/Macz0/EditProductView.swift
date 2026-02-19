import SwiftUI

struct EditProductView: View {
    let product: CosmeticProduct
    @ObservedObject var viewModel: CosmeticViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedType: ProductType
    @State private var brand: String
    @State private var color: String
    @State private var selectedLabel: ProductLabel
    @State private var comment: String
    
    init(product: CosmeticProduct, viewModel: CosmeticViewModel) {
        self.product = product
        self.viewModel = viewModel
        
        _name = State(initialValue: product.name)
        _selectedType = State(initialValue: product.type)
        _brand = State(initialValue: product.brand)
        _color = State(initialValue: product.color)
        _selectedLabel = State(initialValue: product.label)
        _comment = State(initialValue: product.comment)
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Product name", text: $name)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            Picker("Type", selection: $selectedType) {
                                ForEach(ProductType.allCases, id: \.self) { type in
                                    Text(type.displayName)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorMultiply(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Brand")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Brand name", text: $brand)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Color Description")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("e.g., Warm coral with pink undertones", text: $color)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Label")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            HStack(spacing: 16) {
                                ForEach([ProductLabel.none, ProductLabel.favorite, ProductLabel.duplicate], id: \.self) { label in
                                    Button(action: { selectedLabel = label }) {
                                        HStack(spacing: 8) {
                                            if !label.emoji.isEmpty {
                                                Text(label.emoji)
                                                    .font(.system(size: 16))
                                            }
                                            Text(label.displayName)
                                                .font(.ubuntu(12, weight: .medium))
                                        }
                                        .foregroundColor(selectedLabel == label ? ColorTheme.white : ColorTheme.textSecondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedLabel == label ? ColorTheme.lightBlue : ColorTheme.cardBackground)
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                            
                            TextField("Additional notes", text: $comment, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(ColorTheme.white)
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .accentColor(ColorTheme.lightBlue)
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Product")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorTheme.lightBlue),
                
                trailing: Button("Save Changes") {
                    saveChanges()
                }
                .foregroundColor(canSave ? ColorTheme.lightBlue : ColorTheme.textSecondary)
                .disabled(!canSave)
            )
        }
    }
    
    private func saveChanges() {
        var updatedProduct = product
        updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.type = selectedType
        updatedProduct.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.color = color.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.label = selectedLabel
        updatedProduct.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateProduct(updatedProduct)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditProductView(
        product: CosmeticProduct(
            name: "Rouge Allure",
            type: .lipstick,
            brand: "Chanel",
            color: "Warm coral",
            label: .favorite,
            comment: "Perfect for everyday wear"
        ),
        viewModel: CosmeticViewModel()
    )
}
