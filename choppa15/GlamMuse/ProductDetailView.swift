import SwiftUI

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var viewModel: ProductsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var product: Product? {
        viewModel.getProduct(by: productId)
    }
    
    var body: some View {
        Group {
            if let product = product {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView(product: product)
                                
                                VStack(spacing: 20) {
                                    DetailSection(title: "Category") {
                                        HStack(spacing: 8) {
                                            Image(systemName: categoryIcon(for: product.category))
                                                .font(.system(size: 16))
                                            Text(product.category.rawValue)
                                                .font(.ubuntu(16, weight: .medium))
                                        }
                                        .foregroundColor(AppColors.accent)
                                    }
                                    
                                    if !product.shade.isEmpty {
                                        DetailSection(title: "Shade/Number") {
                                            Text(product.shade)
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.darkText)
                                        }
                                    } else {
                                        DetailSection(title: "Shade/Number") {
                                            emptyStateText
                                        }
                                    }
                                    
                                    if !product.comment.isEmpty {
                                        DetailSection(title: "Comment") {
                                            Text(product.comment)
                                                .font(.ubuntu(16))
                                                .foregroundColor(AppColors.darkText)
                                                .lineSpacing(2)
                                        }
                                    } else {
                                        DetailSection(title: "Comment") {
                                            emptyStateText
                                        }
                                    }
                                    
                                    DetailSection(title: "Date Added") {
                                        Text(DateFormatter.longDate.string(from: product.dateAdded))
                                            .font(.ubuntu(16))
                                            .foregroundColor(AppColors.darkText)
                                    }
                                }
                                
                                actionButtonsView(product: product)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        }
                    }
                    .navigationTitle(product.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    CreateEditProductView(viewModel: viewModel, productToEdit: product)
                }
                .alert("Delete Product", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteProduct(product)
                        dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this product? This action cannot be undone.")
                }
            } else {
                Color.clear
                    .onAppear {
                        dismiss()
                    }
            }
        }
    }
    
    private func headerView(product: Product) -> some View {
        VStack(spacing: 12) {
            Text(product.name)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Added on \(DateFormatter.longDate.string(from: product.dateAdded))")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    private func categoryIcon(for category: ProductCategory) -> String {
        switch category {
        case .lips: return "mouth"
        case .eyes: return "eye"
        case .face: return "face.smiling"
        case .brows: return "eyebrow"
        case .other: return "square.grid.2x2"
        }
    }
    
    private var emptyStateText: some View {
        Text("Information not specified. Can be added later through editing.")
            .font(.ubuntu(14))
            .foregroundColor(AppColors.darkText.opacity(0.6))
            .italic()
    }
    
    private func actionButtonsView(product: Product) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Product")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Product")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.error)
                .cornerRadius(12)
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    let viewModel = ProductsViewModel()
    let previewProduct = Product(
        name: "MAC Ruby Woo Lipstick",
        category: .lips,
        shade: "#707 Ruby Woo",
        comment: "Classic matte red lipstick. Long-lasting and highly pigmented."
    )
    viewModel.addProduct(previewProduct)
    return ProductDetailView(productId: previewProduct.id, viewModel: viewModel)
}

