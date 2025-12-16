import SwiftUI

struct ProductDetailView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @State var product: Product
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var productToEdit: Product?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 12) {
                        Text(product.name)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                            .multilineTextAlignment(.center)
                        
                        Text(product.category.displayName)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                VStack(spacing: 0) {
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Status")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(Color.theme.darkGray)
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 20) {
                                ForEach(ProductStatus.allCases, id: \.self) { status in
                                    Button(action: {
                                        updateProductStatus(status)
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: status.icon)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(product.status == status ? Color.theme.primaryWhite : (status == .available ? Color.theme.accentGreen : Color.theme.accentRed))
                                            
                                            Text(status.displayName)
                                                .font(.ubuntu(12, weight: .medium))
                                                .foregroundColor(product.status == status ? Color.theme.primaryWhite : Color.theme.darkGray)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(product.status == status ? Color.theme.primaryPurple : Color.theme.lightGray)
                                        )
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Divider()
                            .background(Color.theme.lightGray)
                        
                        VStack(spacing: 16) {
                            DetailRow(title: "Volume/Weight", value: product.volume)
                            DetailRow(title: "Expiration Date", value: DateFormatter.shortDate.string(from: product.expirationDate))
                            
                            if !product.note.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Note")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(Color.theme.darkGray)
                                        
                                        Spacer()
                                    }
                                    
                                    Text(product.note)
                                        .font(.ubuntu(14, weight: .regular))
                                        .foregroundColor(Color.theme.darkGray.opacity(0.8))
                                        .lineSpacing(4)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Note")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(Color.theme.darkGray)
                                        
                                        Spacer()
                                    }
                                    
                                    Text("No note added. You can specify usage instructions or replacement reminders.")
                                        .font(.ubuntu(14, weight: .regular))
                                        .foregroundColor(Color.theme.darkGray.opacity(0.6))
                                        .italic()
                                        .lineSpacing(4)
                                }
                            }
                        }
                    }
                    .padding(24)
                    .background(Color.theme.primaryWhite)
                    .cornerRadius(20)
                    .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        productToEdit = product
                    }) {
                        Text("Edit")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.theme.buttonGradient)
                            .cornerRadius(28)
                            .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Text("Delete")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.accentRed)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.primaryWhite.opacity(0.2))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $productToEdit) { product in
            CreateProductView(viewModel: viewModel, cosmeticBagId: product.cosmeticBagId, productToEdit: product)
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
        .onReceive(viewModel.$cosmeticBags) { bags in
            for bag in bags {
                if let updatedProduct = bag.products.first(where: { $0.id == product.id }) {
                    product = updatedProduct
                    break
                }
            }
        }
        .onAppear {
            appViewModel.enterDetailView()
        }
        .onDisappear {
            appViewModel.exitDetailView()
        }
    }
    
    private func updateProductStatus(_ status: ProductStatus) {
        var updatedProduct = product
        updatedProduct.status = status
        viewModel.updateProduct(updatedProduct)
        product = updatedProduct
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.darkGray)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(Color.theme.darkGray.opacity(0.8))
        }
    }
}

#Preview {
    ProductDetailView(
        viewModel: CosmeticBagViewModel(),
        product: Product(
            name: "Clinique Moisture Surge",
            category: .skincare,
            volume: "50 ml",
            expirationDate: Date(),
            status: .available,
            note: "Daily use moisturizer",
            cosmeticBagId: UUID()
        )
    )
    .environmentObject(AppViewModel())
}
