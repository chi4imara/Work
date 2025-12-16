import SwiftUI

struct ProductSelectionView: View {
    let availableProducts: [Product]
    @Binding var selectedProducts: [Product]
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    
    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return availableProducts
        } else {
            return availableProducts.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
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
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    if filteredProducts.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "waterbottle")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(.textSecondary)
                            
                            Text("No products found")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                            
                            Text("Add products to your collection first")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredProducts) { product in
                                    ProductSelectionRow(
                                        product: product,
                                        isSelected: selectedProducts.contains { $0.id == product.id }
                                    ) {
                                        toggleProductSelection(product)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationTitle("Select Products")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryPurple)
                }
            }
        }
    }
    
    private func toggleProductSelection(_ product: Product) {
        if selectedProducts.contains(where: { $0.id == product.id }) {
            selectedProducts.removeAll { $0.id == product.id }
        } else {
            selectedProducts.append(product)
        }
    }
}

struct ProductSelectionRow: View {
    let product: Product
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primaryPurple : Color.buttonSecondary)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.primaryPurple : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProductSelectionView(
        availableProducts: [
            Product(name: "Foundation", category: .makeup, volume: "30ml"),
            Product(name: "Moisturizer", category: .skincare, volume: "50ml")
        ],
        selectedProducts: .constant([])
    )
}
