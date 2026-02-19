import SwiftUI

struct BrandDetailView: View {
    let brandId: UUID
    @ObservedObject var brandStore: BrandStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    
    private var brand: Brand? {
        brandStore.getBrand(by: brandId)
    }
    
    var body: some View {
        Group {
            if let brand = brand {
                detailContent(for: brand)
            } else {
                errorView
            }
        }
    }
    
    private func detailContent(for brand: Brand) -> some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        Text(brand.name)
                            .font(.bauhaus(32, weight: .bold))
                            .foregroundColor(AppColors.darkGray)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Text("Category:")
                                .font(.bauhaus(16, weight: .medium))
                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                            
                            Text(brand.category.displayName)
                                .font(.bauhaus(16, weight: .bold))
                                .foregroundColor(AppColors.darkGray)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("Rating:")
                                .font(.bauhaus(16, weight: .medium))
                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                            
                            StarRatingView(rating: brand.rating, interactive: false, color: AppColors.primaryYellow, size: 24)
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Description:")
                                    .font(.bauhaus(16, weight: .medium))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                                
                                Spacer()
                            }
                            
                            Text(brand.description.isEmpty ? "No description available" : brand.description)
                                .font(.bauhaus(16, weight: .medium))
                                .foregroundColor(brand.description.isEmpty ? AppColors.darkGray.opacity(0.5) : AppColors.darkGray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(25)
                    .background(AppColors.cardGradient)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("Edit")
                                    .font(.bauhaus(18, weight: .bold))
                            }
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.buttonBackground)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            deleteBrand()
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("Delete")
                                    .font(.bauhaus(18, weight: .bold))
                            }
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.destructiveButton)
                            .cornerRadius(25)
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle(brand.name)
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
        .sheet(isPresented: $showingEditView) {
            if let currentBrand = brandStore.getBrand(by: brandId) {
                EditBrandView(brand: currentBrand, brandStore: brandStore)
            }
        }
    }
    
    private var errorView: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Brand not found")
                    .font(.bauhaus(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
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
    }
    
    private func deleteBrand() {
        brandStore.deleteBrand(by: brandId)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        BrandDetailView(brandId: Brand.sampleBrands[0].id, brandStore: BrandStore())
    }
}
