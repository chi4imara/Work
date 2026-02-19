import SwiftUI

struct ProductID: Identifiable {
    let id: UUID
}

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var viewModel: CosmeticViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var product: CosmeticProduct? {
        viewModel.products.first { $0.id == productId }
    }
    
    var body: some View {
        Group {
            if let product = product {
                NavigationView {
                    ZStack {
                        BackgroundView()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView(product: product)
                                
                                productHeaderView(product: product)
                                
                                detailsView(product: product)
                                
                                actionButtonsView(product: product)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                    .navigationBarHidden(true)
                }
                .sheet(isPresented: $showingEditView) {
                    EditProductView(product: product, viewModel: viewModel)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete Product"),
                        message: Text("Are you sure you want to delete this product? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteProduct(product)
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            } else {
                ZStack {
                    BackgroundView()
                    VStack {
                        Text("Product not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
        }
    }
    
    private func headerView(product: CosmeticProduct) -> some View {
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
            
            Text("Product Details")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: { viewModel.toggleFavorite(product) }) {
                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(product.isFavorite ? AppColors.accentOrange : AppColors.textSecondary)
                    .frame(width: 40, height: 40)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            }
        }
        .padding(.top, 10)
    }
    
    private func productHeaderView(product: CosmeticProduct) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(product.statusColor.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: product.type.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(product.statusColor)
            }
            
            VStack(spacing: 8) {
                Text(product.name)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("\(product.brand) — \(product.type.rawValue)")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= product.rating ? "star.fill" : "star")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private func detailsView(product: CosmeticProduct) -> some View {
        VStack(spacing: 16) {
            if !product.shade.isEmpty {
                DetailRow(title: "Shade", value: product.shade, icon: "paintpalette")
            }
            
            DetailRow(
                title: "Purchase Date",
                value: DateFormatter.displayFormatter.string(from: product.purchaseDate),
                icon: "cart"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(product.statusColor)
                    
                    Text("Expiration")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(DateFormatter.displayFormatter.string(from: product.expirationDate))
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(expirationStatusText(product: product))
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(product.statusColor)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(product.statusColor.opacity(0.3), lineWidth: 1)
            )
            
            if !product.comment.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "text.quote")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Text("Comment")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                    }
                    
                    Text(product.comment)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.textPrimary)
                        .lineSpacing(4)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
            }
        }
    }
    
    private func actionButtonsView(product: CosmeticProduct) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    Text("Edit Product")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.backgroundGradientStart)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.primaryYellow)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    Text("Delete Product")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.statusRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.statusRed.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.top, 20)
    }
    
    private func expirationStatusText(product: CosmeticProduct) -> String {
        let days = product.daysUntilExpiration
        if days < 0 {
            return "Expired \(abs(days)) days ago"
        } else if days == 0 {
            return "Expires today"
        } else if days == 1 {
            return "Expires tomorrow"
        } else if days < 30 {
            return "\(days) days remaining"
        } else {
            let months = days / 30
            return "\(months) months remaining"
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryYellow)
                .frame(width: 20)
            
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    let viewModel = CosmeticViewModel()
    let sampleProduct = CosmeticProduct(
        name: "Matte Velvet Foundation",
        brand: "Make Up For Ever",
        type: .foundation,
        shade: "Y225",
        purchaseDate: Date(),
        expirationDate: Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date(),
        rating: 5,
        comment: "Perfect coverage, long-lasting and doesn't oxidize throughout the day."
    )
    viewModel.addProduct(sampleProduct)
    
    return ProductDetailView(productId: sampleProduct.id, viewModel: viewModel)
}
