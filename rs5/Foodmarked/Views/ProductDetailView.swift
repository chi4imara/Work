import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var productStore: ProductStore
    @Environment(\.presentationMode) var presentationMode
    
    let productId: UUID
    @State private var showingDeleteAlert = false
    @State private var showingStatusChangeAlert = false
    @State private var showingEditView = false
    
    private var product: Product? {
        productStore.products.first { $0.id == productId }
    }
    
    var body: some View {
        Group {
            if let product = product {
                productDetailContent(product: product)
            } else {
                productNotFoundView
            }
        }
    }
    
    private func productDetailContent(product: Product) -> some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(product.category.color.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .shadow(color: product.category.color.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Text(product.category.icon)
                                .font(.system(size: 50))
                        }
                        
                        HStack(spacing: 8) {
                            Text(product.name)
                                .font(.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Button(action: {
                                productStore.toggleFavorite(product)
                            }) {
                                Image(systemName: product.isFavorite ? "star.fill" : "star")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(product.isFavorite ? ColorManager.primaryYellow : ColorManager.secondaryText)
                            }
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 8) {
                            Text(product.category.icon)
                            Text(product.category.rawValue)
                                .font(.playfairDisplay(size: 14, weight: .medium))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                    }
                    .padding(.top, 30)
                    
                    VStack(spacing: 20) {
                        Text("Current Status")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        HStack(spacing: 12) {
                            Circle()
                                .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                                .frame(width: 16, height: 16)
                            
                            Text(product.status.displayName)
                                .font(.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed,
                                            lineWidth: 2
                                        )
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Product")
                            }
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorManager.primaryBlue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingStatusChangeAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("Change Status")
                            }
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorManager.buttonGradient)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Product")
                            }
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorManager.unsuitableRed)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Product Information")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        VStack(spacing: 8) {
                            InfoRow(title: "Category", value: "\(product.category.icon) \(product.category.rawValue)")
                            InfoRow(title: "Added", value: formatDate(product.dateAdded))
                            InfoRow(title: "Status", value: product.status.displayName)
                            if product.isFavorite {
                                InfoRow(title: "Favorite", value: "Yes")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorManager.cardGradient)
                            .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                    
                    if product.statusHistory.count > 1 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status History")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(Array(product.statusHistory.enumerated()), id: \.offset) { index, change in
                                    HStack {
                                        Circle()
                                            .fill(change.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                                            .frame(width: 8, height: 8)
                                        
                                        Text(change.status.displayName)
                                            .font(.playfairDisplay(size: 14, weight: .medium))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Text(formatDate(change.date))
                                            .font(.playfairDisplay(size: 12, weight: .regular))
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.cardGradient)
                                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            NavigationView {
                EditProductView(productId: productId)
                    .environmentObject(productStore)
            }
        }
        .alert("Change Status", isPresented: $showingStatusChangeAlert) {
            Button("Change to \(product.status == .suitable ? "Not Suitable" : "Suitable")") {
                changeProductStatus(product: product)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to change the status of '\(product.name)'?")
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteProduct(product: product)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete '\(product.name)'? This action cannot be undone.")
        }
    }
    
    private var productNotFoundView: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(ColorManager.secondaryText)
                
                Text("Product Not Found")
                    .font(.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("The product you're looking for doesn't exist or has been deleted.")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func changeProductStatus(product: Product) {
        productStore.toggleProductStatus(product)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteProduct(product: Product) {
        productStore.deleteProduct(product)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(size: 14, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
        }
    }
}
