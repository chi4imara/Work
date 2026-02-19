import SwiftUI

struct AddProductView: View {
    @EnvironmentObject var productStore: ProductStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var brand = ""
    @State private var selectedCategory = ProductCategory.skincare
    @State private var quantity = 1
    @State private var selectedStatus = ProductStatus.inStock
    @State private var comment = ""
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            FormField(title: "Product Name", isRequired: true) {
                                TextField("Enter product name", text: $name)
                                    .font(FontManager.regular(size: 16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Brand") {
                                TextField("Enter brand name", text: $brand)
                                    .font(FontManager.regular(size: 16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Category") {
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(ProductCategory.allCases, id: \.self) { category in
                                        Text(category.displayName).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Quantity") {
                                HStack {
                                    Button(action: {
                                        if quantity > 1 {
                                            quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(ColorManager.primaryBlue)
                                    }
                                    .disabled(quantity <= 1)
                                    
                                    Spacer()
                                    
                                    Text("\(quantity)")
                                        .font(FontManager.medium(size: 18))
                                        .foregroundColor(ColorManager.primaryBlue)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        quantity += 1
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(ColorManager.primaryBlue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Status") {
                                Picker("Status", selection: $selectedStatus) {
                                    ForEach(ProductStatus.allCases, id: \.self) { status in
                                        HStack {
                                            Circle()
                                                .fill(statusColor(for: status))
                                                .frame(width: 12, height: 12)
                                            Text(status.displayName)
                                        }.tag(status)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Comment (Optional)") {
                                TextField("Add any notes about this product", text: $comment, axis: .vertical)
                                    .font(FontManager.regular(size: 16))
                                    .lineLimit(3...6)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(16)
                        
                        VStack(spacing: 16) {
                            Button(action: saveProduct) {
                                Text("Save Product")
                                    .font(FontManager.medium(size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        isFormValid ?
                                        LinearGradient(
                                            colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: [ColorManager.darkGray.opacity(0.3), ColorManager.darkGray.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                            }
                            .disabled(!isFormValid)
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .font(FontManager.medium(size: 16))
                                    .foregroundColor(ColorManager.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(ColorManager.primaryBlue, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func statusColor(for status: ProductStatus) -> Color {
        switch status {
        case .inUse:
            return ColorManager.statusInUse
        case .inStock:
            return ColorManager.statusInStock
        case .needToBuy:
            return ColorManager.statusNeedToBuy
        }
    }
    
    private func saveProduct() {
        let newProduct = Product(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            quantity: quantity,
            status: selectedStatus,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        productStore.addProduct(newProduct)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProductView: View {
    let product: Product
    @EnvironmentObject var productStore: ProductStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var brand: String
    @State private var selectedCategory: ProductCategory
    @State private var quantity: Int
    @State private var selectedStatus: ProductStatus
    @State private var comment: String
    
    init(product: Product) {
        self.product = product
        self._name = State(initialValue: product.name)
        self._brand = State(initialValue: product.brand)
        self._selectedCategory = State(initialValue: product.category)
        self._quantity = State(initialValue: product.quantity)
        self._selectedStatus = State(initialValue: product.status)
        self._comment = State(initialValue: product.comment)
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            FormField(title: "Product Name", isRequired: true) {
                                TextField("Enter product name", text: $name)
                                    .font(FontManager.regular(size: 16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Brand") {
                                TextField("Enter brand name", text: $brand)
                                    .font(FontManager.regular(size: 16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Category") {
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(ProductCategory.allCases, id: \.self) { category in
                                        Text(category.displayName).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Quantity") {
                                HStack {
                                    Button(action: {
                                        if quantity > 1 {
                                            quantity -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(ColorManager.primaryBlue)
                                    }
                                    .disabled(quantity <= 1)
                                    
                                    Spacer()
                                    
                                    Text("\(quantity)")
                                        .font(FontManager.medium(size: 18))
                                        .foregroundColor(ColorManager.primaryBlue)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        quantity += 1
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(ColorManager.primaryBlue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Status") {
                                Picker("Status", selection: $selectedStatus) {
                                    ForEach(ProductStatus.allCases, id: \.self) { status in
                                        HStack {
                                            Circle()
                                                .fill(statusColor(for: status))
                                                .frame(width: 12, height: 12)
                                            Text(status.displayName)
                                        }.tag(status)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Comment (Optional)") {
                                TextField("Add any notes about this product", text: $comment, axis: .vertical)
                                    .font(FontManager.regular(size: 16))
                                    .lineLimit(3...6)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(16)
                        
                        VStack(spacing: 16) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(FontManager.medium(size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        isFormValid ?
                                        LinearGradient(
                                            colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: [ColorManager.darkGray.opacity(0.3), ColorManager.darkGray.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                            }
                            .disabled(!isFormValid)
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .font(FontManager.medium(size: 16))
                                    .foregroundColor(ColorManager.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(ColorManager.primaryBlue, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Edit Product")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func statusColor(for status: ProductStatus) -> Color {
        switch status {
        case .inUse:
            return ColorManager.statusInUse
        case .inStock:
            return ColorManager.statusInStock
        case .needToBuy:
            return ColorManager.statusNeedToBuy
        }
    }
    
    private func saveChanges() {
        var updatedProduct = product
        updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.category = selectedCategory
        updatedProduct.quantity = quantity
        updatedProduct.status = selectedStatus
        updatedProduct.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.dateModified = Date()
        
        productStore.updateProduct(updatedProduct)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField<Content: View>: View {
    let title: String
    let isRequired: Bool
    let content: Content
    
    init(title: String, isRequired: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isRequired = isRequired
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                
                if isRequired {
                    Text("*")
                        .font(FontManager.medium(size: 16))
                        .foregroundColor(ColorManager.statusNeedToBuy)
                }
                
                Spacer()
            }
            
            content
        }
    }
}

#Preview {
    AddProductView()
        .environmentObject(ProductStore())
}
