import SwiftUI

struct ProductDetailView: View {
    let product: CosmeticProduct
    @ObservedObject var viewModel: CosmeticViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        HStack {
                            Text(product.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.white)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            if product.label != .none {
                                Text(product.label.emoji)
                                    .font(.system(size: 24))
                            }
                        }
                        
                        HStack {
                            Text(product.type.displayName)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(ColorTheme.accent)
                                .cornerRadius(12)
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(ColorTheme.cardGradient)
                    .cornerRadius(20)
                    
                    VStack(spacing: 20) {
                        if !product.brand.isEmpty {
                            DetailRow(title: "Brand", value: product.brand)
                        }
                        
                        if !product.color.isEmpty {
                            DetailRow(title: "Color", value: product.color)
                        }
                        
                        if product.label != .none {
                            DetailRow(title: "Label", value: "\(product.label.emoji) \(product.label.displayName)")
                        }
                        
                        if !product.comment.isEmpty {
                            DetailRow(title: "Comment", value: product.comment)
                        }
                        
                        DetailRow(title: "Added", value: DateFormatter.shortDate.string(from: product.dateAdded))
                    }
                    .padding(20)
                    .background(ColorTheme.cardGradient)
                    .cornerRadius(20)
                    
                    VStack(spacing: 16) {
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Product")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorTheme.buttonGradient)
                            .cornerRadius(16)
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Product")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(Color.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditProductView(product: product, viewModel: viewModel)
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

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(ColorTheme.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    NavigationView {
        ProductDetailView(
            product: CosmeticProduct(
                name: "Rouge Allure",
                type: .lipstick,
                brand: "Chanel",
                color: "Warm coral",
                label: .favorite,
                comment: "Perfect for everyday wear"
            ),
            viewModel: CosmeticViewModel()
        )
    }
}
