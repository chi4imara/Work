import SwiftUI

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var viewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var product: Product? {
        viewModel.product(withId: productId)
    }
    
    var body: some View {
        Group {
            if product != nil {
                productDetailContent
            } else {
                Text("Product not found")
                    .foregroundColor(AppColors.blueText)
            }
        }
    }
    
    @ViewBuilder
    private var productDetailContent: some View {
        if let product = product {
            ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.name)
                                .font(.playfair(24, weight: .bold))
                                .foregroundColor(AppColors.blueText)
                            
                            Text(product.category.displayName)
                                .font(.playfair(16, weight: .medium))
                                .foregroundColor(AppColors.mediumBlue)
                        }
                        
                        Divider()
                            .background(AppColors.mediumGray.opacity(0.3))
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("First Use Date")
                                    .font(.playfair(14, weight: .medium))
                                    .foregroundColor(AppColors.mediumGray)
                                
                                Text(DateFormatter.longDate.string(from: product.firstUseDate))
                                    .font(.playfair(16, weight: .semibold))
                                    .foregroundColor(AppColors.blueText)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Result")
                                    .font(.playfair(14, weight: .medium))
                                    .foregroundColor(AppColors.mediumGray)
                                
                                ResultBadge(result: product.result)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            Text(product.notes.isEmpty ? "No notes available" : product.notes)
                                .font(.playfair(14, weight: .regular))
                                .foregroundColor(product.notes.isEmpty ? AppColors.mediumGray : AppColors.darkGray)
                                .lineSpacing(2)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardGradient)
                    )
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            viewModel.toggleFavorite(product)
                        }) {
                            HStack {
                                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text(product.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                    .font(.playfair(16, weight: .semibold))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(product.isFavorite ? AppColors.yellow : AppColors.lightBlue)
                            )
                        }
                        
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Edit")
                                    .font(.playfair(16, weight: .semibold))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.purple)
                            )
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Delete")
                                    .font(.playfair(16, weight: .semibold))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.red)
                            )
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle(String(product.name.prefix(20)))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditProductView(productId: product.id, viewModel: viewModel)
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProduct(product)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this product? This action cannot be undone.")
        }
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    let viewModel = ProductViewModel()
    let sampleProduct = Product(
        name: "Sample Foundation",
        category: .makeup,
        firstUseDate: Date(),
        result: .liked,
        notes: "This is a sample note about the product."
    )
    viewModel.addProduct(sampleProduct)
    
    return NavigationView {
        ProductDetailView(
            productId: sampleProduct.id,
            viewModel: viewModel
        )
    }
}
