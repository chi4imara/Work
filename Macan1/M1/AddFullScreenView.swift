import SwiftUI

struct AddFullScreenView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @Binding var selectedTab: TabItem
    
    @State private var name = ""
    @State private var brand = ""
    @State private var selectedType = ProductType.lipstick
    @State private var shade = ""
    @State private var purchaseDate = Date()
    @State private var expirationDate = Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()
    @State private var rating = 5
    @State private var comment = ""
    @State private var showingBrandSuggestions = false
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    formView
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerView: some View {
        HStack {    
            Text("New Product")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: saveProduct) {
                Text("Save")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isFormValid ? AppColors.backgroundGradientStart : AppColors.textTertiary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isFormValid ? AppColors.primaryYellow : AppColors.cardBackground)
                    .cornerRadius(20)
            }
            .disabled(!isFormValid)
        }
        .padding(.vertical, 10)
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
    
    private func saveProduct() {
        let product = CosmeticProduct(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            shade: shade.trimmingCharacters(in: .whitespacesAndNewlines),
            purchaseDate: purchaseDate,
            expirationDate: expirationDate,
            rating: rating,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addProduct(product)
        clearAllFields()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTab = .catalog
        }
    }
    
    private func clearAllFields() {
        name = ""
        brand = ""
        selectedType = .lipstick
        shade = ""
        purchaseDate = Date()
        expirationDate = Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()
        rating = 5
        comment = ""
        showingBrandSuggestions = false
    }
}
