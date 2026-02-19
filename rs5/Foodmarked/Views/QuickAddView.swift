import SwiftUI

struct QuickAddView: View {
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var achievementManager: AchievementManager
    @Binding var selectedTab: Int
    @State private var productName = ""
    @State private var showingSuccessAlert = false
    @State private var lastAddedProduct = ""
    
    var isFormValid: Bool {
        !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    VStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Text("Quick Add")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("Add products quickly to your list")
                            .font(.playfairDisplay(size: 16, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Enter product name", text: $productName)
                                .font(.playfairDisplay(size: 18, weight: .regular))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorManager.lightBlue, lineWidth: 1)
                                )
                        }
                        
                        VStack(spacing: 16) {
                            Text("Choose Status")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    addProduct(status: .suitable)
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(ColorManager.suitableGreen)
                                            .frame(width: 16, height: 16)
                                        
                                        Text("Suitable")
                                            .font(.playfairDisplay(size: 18, weight: .semibold))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark")
                                    }
                                    .foregroundColor(ColorManager.whiteText)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isFormValid ? ColorManager.suitableGreen : ColorManager.secondaryText.opacity(0.3))
                                    )
                                }
                                .disabled(!isFormValid)
                                
                                Button(action: {
                                    addProduct(status: .unsuitable)
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(ColorManager.unsuitableRed)
                                            .frame(width: 16, height: 16)
                                        
                                        Text("Not Suitable")
                                            .font(.playfairDisplay(size: 18, weight: .semibold))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "xmark")
                                    }
                                    .foregroundColor(ColorManager.whiteText)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isFormValid ? ColorManager.unsuitableRed : ColorManager.secondaryText.opacity(0.3))
                                    )
                                }
                                .disabled(!isFormValid)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if !productStore.products.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recently Added")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(Array(productStore.products.prefix(5).reversed()), id: \.id) { product in
                                        RecentProductCard(product: product)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .alert("Product Added!", isPresented: $showingSuccessAlert) {
            Button("Add Another") {
                productName = ""
            }
            Button("View Catalog") {
                productName = ""
                selectedTab = 0
            }
        } message: {
            Text("'\(lastAddedProduct)' has been added to your list.")
        }
    }
    
    private func addProduct(status: ProductStatus) {
        let trimmedName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newProduct = Product(name: trimmedName, status: status)
        productStore.addProduct(newProduct)
        
        achievementManager.recordActivity()
        achievementManager.checkAchievements(productStore: productStore)
        
        lastAddedProduct = trimmedName
        showingSuccessAlert = true
    }
}

struct RecentProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                .frame(width: 8, height: 8)
            
            Text(product.name)
                .font(.playfairDisplay(size: 12, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}
