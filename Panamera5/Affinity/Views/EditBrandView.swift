import SwiftUI

struct EditBrandView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var brandStore: BrandStore
    
    @State private var brandName: String
    @State private var selectedCategory: BrandCategory
    @State private var rating: Int
    @State private var description: String
    
    private let originalBrand: Brand
    
    init(brand: Brand, brandStore: BrandStore) {
        self.originalBrand = brand
        self.brandStore = brandStore
        self._brandName = State(initialValue: brand.name)
        self._selectedCategory = State(initialValue: brand.category)
        self._rating = State(initialValue: brand.rating)
        self._description = State(initialValue: brand.description)
    }
    
    private var isFormValid: Bool {
        !brandName.trimmingCharacters(in: .whitespaces).isEmpty && rating > 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Brand Name")
                                .font(.bauhaus(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter brand name", text: $brandName)
                                .font(.bauhaus(16, weight: .medium))
                                .foregroundColor(AppColors.darkGray)
                                .padding()
                                .background(AppColors.primaryWhite)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.bauhaus(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(BrandCategory.allCases, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(.bauhaus(16, weight: .medium))
                                        .foregroundColor(AppColors.darkGray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                                }
                                .padding()
                                .background(AppColors.primaryWhite)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.bauhaus(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack {
                                StarRatingView(rating: $rating, interactive: true, color: AppColors.primaryYellow, size: 30)
                                Spacer()
                            }
                            .padding()
                            .background(AppColors.primaryWhite.opacity(0.2))
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.bauhaus(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add your notes about this brand", text: $description, axis: .vertical)
                                .font(.bauhaus(16, weight: .medium))
                                .foregroundColor(AppColors.darkGray)
                                .padding()
                                .background(AppColors.primaryWhite)
                                .cornerRadius(12)
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 30)
                        
                        Button(action: saveBrand) {
                            Text("Save Changes")
                                .font(.bauhaus(18, weight: .bold))
                                .foregroundColor(isFormValid ? AppColors.buttonText : AppColors.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? AppColors.buttonBackground : AppColors.softGray)
                                .cornerRadius(25)
                        }
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Brand")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bauhaus(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveBrand() {
        var updatedBrand = originalBrand
        updatedBrand.name = brandName.trimmingCharacters(in: .whitespaces)
        updatedBrand.category = selectedCategory
        updatedBrand.rating = rating
        updatedBrand.description = description.trimmingCharacters(in: .whitespaces)
        
        brandStore.updateBrand(updatedBrand)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditBrandView(brand: Brand.sampleBrands[0], brandStore: BrandStore())
}
