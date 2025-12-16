import SwiftUI

struct ProductsView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var searchText = ""
    @State private var showingAddProduct = false
    
    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return appViewModel.products.sorted { $0.dateCreated > $1.dateCreated }
        } else {
            return appViewModel.products.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.displayName.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Text("All Products")
                            .font(.titleLarge)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddProduct = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.buttonSecondary)
                                )
                        }
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                        
                        TextField("Search products...", text: $searchText)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if filteredProducts.isEmpty {
                    EmptyStateView(
                        title: "No products added",
                        subtitle: "Create a list of cosmetics you use most often.",
                        buttonTitle: "Add Product",
                        buttonAction: {
                            showingAddProduct = true
                        }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredProducts) { product in
                                NavigationLink(destination: ProductDetailView(productId: product.id, appViewModel: appViewModel)) {
                                    ProductCardView(product: product) {
                                        appViewModel.deleteProduct(product)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(appViewModel: appViewModel)
        }
    }
}

struct ProductCardView: View {
    let product: Product
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.cardBackground)
                    .frame(width: 50, height: 50)
                
                Image(systemName: categoryIcon(for: product.category))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryPurple)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(product.category.displayName)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    if !product.volume.isEmpty {
                        Text("• \(product.volume)")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                if !product.comment.isEmpty {
                    Text(product.comment)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation(.spring(response: 0.3)) {
                    onDelete()
                }
            }
        } message: {
            Text("Are you sure you want to delete \(product.name)? This will also remove it from all sets.")
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
}

#Preview {
    ProductsView(appViewModel: AppViewModel())
}
