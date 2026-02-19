import SwiftUI

struct CategoryBrandsView: View {
    let category: BrandCategory
    @ObservedObject var brandStore: BrandStore
    @Environment(\.presentationMode) var presentationMode
    
    private var brandsInCategory: [Brand] {
        brandStore.brands(for: category)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if brandsInCategory.isEmpty {
                    EmptyCategoryView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(brandsInCategory) { brand in
                                NavigationLink(destination: BrandDetailView(brandId: brand.id, brandStore: brandStore)) {
                                    CategoryBrandCardView(brand: brand)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationTitle(category.displayName)
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

struct EmptyCategoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No brands in this category yet.")
                .font(.bauhaus(18, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

struct CategoryBrandCardView: View {
    let brand: Brand
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(brand.name)
                        .font(.bauhaus(20, weight: .bold))
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
                
                HStack {
                    StarRatingView(rating: brand.rating, interactive: false, color: AppColors.primaryYellow)
                    
                    Spacer()
                }
                
                if !brand.description.isEmpty {
                    Text(brand.description)
                        .font(.bauhaus(14, weight: .medium))
                        .foregroundColor(AppColors.darkGray.opacity(0.8))
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        CategoryBrandsView(category: .cosmetics, brandStore: BrandStore())
    }
}
