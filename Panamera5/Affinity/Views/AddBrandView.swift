import SwiftUI

struct AddBrandView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var brandStore: BrandStore
    
    @State private var brandName = ""
    @State private var selectedCategory = BrandCategory.cosmetics
    @State private var rating = 0
    @State private var description = ""
    @State private var showingCustomCategory = false
    
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
                        
                        Button(action: addBrand) {
                            Text("Add Brand")
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
            .navigationTitle("New Brand")
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
    
    private func addBrand() {
        let newBrand = Brand(
            name: brandName.trimmingCharacters(in: .whitespaces),
            category: selectedCategory,
            rating: rating,
            description: description.trimmingCharacters(in: .whitespaces)
        )
        
        brandStore.addBrand(newBrand)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddBrandView(brandStore: BrandStore())
}
