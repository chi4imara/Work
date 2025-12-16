import SwiftUI

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditProduct = false
    @State private var showingDeleteAlert = false
    
    private var product: Product? {
        appViewModel.products.first { $0.id == productId }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if let product = product {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.cardBackground)
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: categoryIcon(for: product.category))
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(.primaryPurple)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.name)
                                        .font(.titleMedium)
                                        .foregroundColor(.textPrimary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(product.category.displayName)
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                Spacer()
                            }
                            
                            if !product.volume.isEmpty {
                                HStack {
                                    Image(systemName: "ruler")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.textSecondary)
                                    
                                    Text("Volume: \(product.volume)")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                )
                            }
                            
                            if !product.comment.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Comment")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                    
                                    Text(product.comment)
                                        .font(.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(4)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.cardBackground)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.cardBorder, lineWidth: 1)
                                                )
                                        )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date Created")
                                    .font(.bodyMedium)
                                    .foregroundColor(.textSecondary)
                                
                                Text(formatDate(product.dateCreated))
                                    .font(.bodySmall)
                                    .foregroundColor(.textSecondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.cardBackground.opacity(0.5))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.cardBorder.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditProduct = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Edit Product")
                                        .font(.buttonMedium)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.buttonPrimary)
                                )
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete Product")
                                        .font(.buttonMedium)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.buttonDestructive)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            } else {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.textSecondary)
                    
                    Text("Product Not Found")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Text("This product may have been deleted.")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Go Back") {
                        dismiss()
                    }
                    .font(.buttonMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.buttonPrimary)
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditProduct) {
            if let product = product {
                AddProductView(appViewModel: appViewModel, editingProduct: product)
            }
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let product = product {
                    appViewModel.deleteProduct(product)
                    dismiss()
                }
            }
        } message: {
            if let product = product {
                Text("Are you sure you want to delete \(product.name)? This will also remove it from all sets.")
            }
        }
    }
    
    private func categoryIcon(for category: ProductCategory) -> String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .hair:
            return "scissors"
        case .other:
            return "star.fill"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let appViewModel = AppViewModel()
    let previewProduct = Product(
        name: "Foundation",
        category: .makeup,
        volume: "30ml",
        comment: "Perfect for everyday use"
    )
    appViewModel.addProduct(previewProduct)
    
    return NavigationView {
        ProductDetailView(
            productId: previewProduct.id,
            appViewModel: appViewModel
        )
    }
}

