import SwiftUI

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var viewModel: CosmeticsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var product: CosmeticProduct? {
        viewModel.products.first { $0.id == productId }
    }
    
    var body: some View {
        Group {
            if let product = product {
                productDetailContent(product: product)
            } else {
                Text("Product not found")
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
    
    private func productDetailContent(product: CosmeticProduct) -> some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if product.hasImage {
                        imageSection(product: product)
                    }
                    
                    productInfoSection(product: product)
                    
                    actionButtonsSection(product: product)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditView = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditProductView(viewModel: viewModel, editingProduct: product)
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProduct(product)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \(product.name)? This action cannot be undone.")
        }
    }
    
    private func imageSection(product: CosmeticProduct) -> some View {
        Group {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 2)
                    )
            }
        }
    }
    
    private func productInfoSection(product: CosmeticProduct) -> some View {
        VStack(spacing: 20) {
            InfoCard {
                VStack(alignment: .leading, spacing: 16) {
                    InfoRow(title: "Product Type", value: product.productType.displayName)
                    
                    if !product.shade.isEmpty {
                        InfoRow(title: "Shade", value: product.shade)
                    }
                    
                    InfoRow(title: "Texture", value: product.texture.displayName)
                    
                    if !product.suitableFor.isEmpty {
                        InfoRow(title: "When & Where It Fits", value: product.suitableFor)
                    }
                }
            }
            
            if product.hasNotes {
                InfoCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.bellGothic(18, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(product.notes)
                            .font(.bellGothic(16))
                            .foregroundColor(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private func actionButtonsSection(product: CosmeticProduct) -> some View {
        VStack(spacing: 16) {
            Button(action: { viewModel.toggleFavorite(for: product) }) {
                HStack(spacing: 12) {
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(product.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.bellGothic(16, weight: .bold))
                }
                .foregroundColor(product.isFavorite ? AppColors.primaryText : AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(product.isFavorite ? AppColors.errorRed : AppColors.accentYellow)
                )
            }
            
            Button(action: { showingEditView = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("Edit Product")
                        .font(.bellGothic(16, weight: .bold))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.accentYellow, lineWidth: 2)
                        )
                )
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("Delete Product")
                        .font(.bellGothic(16, weight: .bold))
                }
                .foregroundColor(AppColors.errorRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.errorRed.opacity(0.5), lineWidth: 2)
                        )
                )
            }
        }
    }
}

struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.bellGothic(14, weight: .bold))
                .foregroundColor(AppColors.accentYellow)
            
            Text(value)
                .font(.bellGothic(16))
                .foregroundColor(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let sampleProduct = CosmeticProduct(
        name: "Fenty Beauty Foundation",
        shade: "240 Medium",
        texture: .liquid,
        productType: .foundation,
        suitableFor: "Daily wear, office",
        notes: "Great coverage, long-lasting formula. Perfect for everyday use."
    )
    let viewModel = CosmeticsViewModel()
    viewModel.addProduct(sampleProduct)
    
    return NavigationView {
        ProductDetailView(
            productId: sampleProduct.id,
            viewModel: viewModel
        )
    }
}
