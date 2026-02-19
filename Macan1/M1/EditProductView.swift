import SwiftUI

struct EditProductView: View {
    let product: CosmeticProduct
    @ObservedObject var viewModel: CosmeticViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var brand: String
    @State private var selectedType: ProductType
    @State private var shade: String
    @State private var purchaseDate: Date
    @State private var expirationDate: Date
    @State private var rating: Int
    @State private var comment: String
    @State private var showingBrandSuggestions = false
    
    init(product: CosmeticProduct, viewModel: CosmeticViewModel) {
        self.product = product
        self.viewModel = viewModel
        
        _name = State(initialValue: product.name)
        _brand = State(initialValue: product.brand)
        _selectedType = State(initialValue: product.type)
        _shade = State(initialValue: product.shade)
        _purchaseDate = State(initialValue: product.purchaseDate)
        _expirationDate = State(initialValue: product.expirationDate)
        _rating = State(initialValue: product.rating)
        _comment = State(initialValue: product.comment)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        name != product.name ||
        brand != product.brand ||
        selectedType != product.type ||
        shade != product.shade ||
        purchaseDate != product.purchaseDate ||
        expirationDate != product.expirationDate ||
        rating != product.rating ||
        comment != product.comment
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(width: 40, height: 40)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            }
            
            Spacer()
            
            Text("Edit Product")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: saveChanges) {
                Text("Save")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor((isFormValid && hasChanges) ? AppColors.backgroundGradientStart : AppColors.textTertiary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background((isFormValid && hasChanges) ? AppColors.primaryYellow : AppColors.cardBackground)
                    .cornerRadius(20)
            }
            .disabled(!isFormValid || !hasChanges)
        }
        .padding(.top, 10)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(title: "Product Name", isRequired: true) {
                TextField("Enter product name", text: $name)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            FormField(title: "Brand", isRequired: true) {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter brand name", text: $brand)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.textPrimary)
                        .textFieldStyle(CustomTextFieldStyle())
                        .onTapGesture {
                            showingBrandSuggestions = true
                        }
                    
                    if showingBrandSuggestions && !brand.isEmpty {
                        brandSuggestions
                    }
                }
            }
            
            FormField(title: "Product Type") {
                Menu {
                    ForEach(ProductType.allCases, id: \.self) { type in
                        Button(action: { selectedType = type }) {
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: selectedType.icon)
                            .foregroundColor(AppColors.primaryYellow)
                        Text(selectedType.rawValue)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                }
            }
            
            FormField(title: "Shade") {
                TextField("Enter shade name", text: $shade)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            FormField(title: "Purchase Date") {
                DatePicker("", selection: $purchaseDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .accentColor(AppColors.primaryYellow)
            }
            
            FormField(title: "Expiration Date") {
                DatePicker("", selection: $expirationDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .accentColor(AppColors.primaryYellow)
            }
            
            FormField(title: "Rating") {
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: { rating = star }) {
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .font(.system(size: 24))
                                .foregroundColor(star <= rating ? AppColors.primaryYellow : AppColors.textSecondary)
                        }
                    }
                    Spacer()
                }
            }
            
            FormField(title: "Comment") {
                TextField("Add your thoughts about this product", text: $comment, axis: .vertical)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(3...6)
                    .textFieldStyle(CustomTextFieldStyle())
            }
        }
    }
    
    private var brandSuggestions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filteredBrands, id: \.self) { suggestion in
                    Button(action: {
                        brand = suggestion
                        showingBrandSuggestions = false
                    }) {
                        Text(suggestion)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var filteredBrands: [String] {
        PopularBrands.list.filter { brandName in
            brandName.localizedCaseInsensitiveContains(brand) && brandName != brand
        }.prefix(5).map { $0 }
    }
    
    private func saveChanges() {
        var updatedProduct = product
        updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.type = selectedType
        updatedProduct.shade = shade.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProduct.purchaseDate = purchaseDate
        updatedProduct.expirationDate = expirationDate
        updatedProduct.rating = rating
        updatedProduct.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateProduct(updatedProduct)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleProduct = CosmeticProduct(
        name: "Matte Velvet Foundation",
        brand: "Make Up For Ever",
        type: .foundation,
        shade: "Y225",
        purchaseDate: Date(),
        expirationDate: Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date(),
        rating: 5,
        comment: "Perfect coverage, long-lasting"
    )
    
    EditProductView(product: sampleProduct, viewModel: CosmeticViewModel())
}
