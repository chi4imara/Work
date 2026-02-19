import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var productStore: ProductStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingStatusPicker = false
    @State private var selectedStatus: ProductStatus
    
    init(product: Product) {
        self.product = product
        self._selectedStatus = State(initialValue: product.status)
    }
    
    var statusColor: Color {
        switch selectedStatus {
        case .inUse:
            return ColorManager.statusInUse
        case .inStock:
            return ColorManager.statusInStock
        case .needToBuy:
            return ColorManager.statusNeedToBuy
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text(product.name)
                                .font(FontManager.bold(size: 24))
                                .foregroundColor(ColorManager.primaryBlue)
                                .multilineTextAlignment(.center)
                            
                            Text(product.brand)
                                .font(FontManager.medium(size: 18))
                                .foregroundColor(ColorManager.darkGray)
                        }
                        
                        Divider()
                            .background(ColorManager.lightGray)
                        
                        VStack(spacing: 16) {
                            DetailRow(title: "Category", value: product.category.displayName, icon: "tag.fill")
                            DetailRow(title: "Quantity", value: "\(product.quantity) pcs", icon: "number.circle.fill")
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(statusColor)
                                
                                Text("Status")
                                    .font(FontManager.medium(size: 16))
                                    .foregroundColor(ColorManager.darkGray)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingStatusPicker = true
                                }) {
                                    Text(selectedStatus.displayName)
                                        .font(FontManager.medium(size: 16))
                                        .foregroundColor(statusColor)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(statusColor.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                            
                            if !product.comment.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "text.bubble.fill")
                                            .foregroundColor(ColorManager.primaryBlue)
                                        
                                        Text("Comment")
                                            .font(FontManager.medium(size: 16))
                                            .foregroundColor(ColorManager.darkGray)
                                        
                                        Spacer()
                                    }
                                    
                                    Text(product.comment)
                                        .font(FontManager.regular(size: 14))
                                        .foregroundColor(ColorManager.darkGray)
                                        .padding(.leading, 28)
                                }
                            }
                        }
                    }
                    .padding(24)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            Text("Edit Product")
                                .font(FontManager.medium(size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            Text("Delete Product")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.statusNeedToBuy)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(22)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(ColorManager.statusNeedToBuy, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 10)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditProductView(product: product)
                .environmentObject(productStore)
        }
        .confirmationDialog("Change Status", isPresented: $showingStatusPicker, titleVisibility: .visible) {
            ForEach(ProductStatus.allCases, id: \.self) { status in
                Button(status.displayName) {
                    selectedStatus = status
                    productStore.updateProductStatus(product, newStatus: status)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                productStore.deleteProduct(product)
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
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(ColorManager.primaryBlue)
            
            Text(title)
                .font(FontManager.medium(size: 16))
                .foregroundColor(ColorManager.darkGray)
            
            Spacer()
            
            Text(value)
                .font(FontManager.medium(size: 16))
                .foregroundColor(ColorManager.primaryBlue)
        }
    }
}

#Preview {
    NavigationView {
        ProductDetailView(product: Product(
            name: "Vitamin C Serum",
            brand: "The Ordinary",
            category: .skincare,
            quantity: 1,
            status: .inUse,
            comment: "Using in the morning, half remaining"
        ))
        .environmentObject(ProductStore())
    }
}
