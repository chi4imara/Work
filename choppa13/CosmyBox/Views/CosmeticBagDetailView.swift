import SwiftUI

enum CosmeticBagDetailSheetItem: Identifiable {
    case addProduct
    case editBag
    
    var id: String {
        switch self {
        case .addProduct:
            return "addProduct"
        case .editBag:
            return "editBag"
        }
    }
}

struct CosmeticBagDetailView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @State var bag: CosmeticBag
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var sheetItem: CosmeticBagDetailSheetItem?
    @State private var showingDeleteAlert = false
    @State private var selectedFilter: ProductStatus? = nil
    @State private var productToEdit: Product?
    @State private var productToDelete: Product?
    @State private var showingDeleteProductAlert = false
    
    var filteredProducts: [Product] {
        let products = bag.products
        if let filter = selectedFilter {
            return products.filter { $0.status == filter }
        }
        return products
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
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
                    
                    VStack(spacing: 8) {
                        Text(bag.name)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Text(bag.purpose.displayName)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        
                        Text("\(bag.productCount) products")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Button(action: {
                    sheetItem = .addProduct
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                        Text("Add Product")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(Color.theme.primaryWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(25)
                    .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                FilterBar(selectedFilter: $selectedFilter)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                if bag.products.isEmpty {
                    EmptyProductsView {
                        sheetItem = .addProduct
                    }
                } else {
                    ProductsList(
                        products: filteredProducts,
                        viewModel: viewModel,
                        onEdit: { product in
                            productToEdit = product
                        },
                        onDelete: { product in
                            productToDelete = product
                            showingDeleteProductAlert = true
                        }
                    )
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        sheetItem = .editBag
                    }) {
                        Text("Edit Cosmetic Bag")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.primaryPurple)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.primaryWhite)
                            .cornerRadius(25)
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Text("Delete Cosmetic Bag")
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
                .padding(.top, 8)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $sheetItem) { item in
            switch item {
            case .addProduct:
                CreateProductView(viewModel: viewModel, cosmeticBagId: bag.id)
            case .editBag:
                CreateCosmeticBagView(viewModel: viewModel, bagToEdit: bag)
            }
        }
        .sheet(item: $productToEdit) { product in
            CreateProductView(viewModel: viewModel, cosmeticBagId: bag.id, productToEdit: product)
        }
        .alert("Delete Cosmetic Bag", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteCosmeticBag(bag)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this cosmetic bag? All products inside will be removed. This action cannot be undone.")
        }
        .alert("Delete Product", isPresented: $showingDeleteProductAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let product = productToDelete {
                    viewModel.deleteProduct(product)
                }
            }
        } message: {
            Text("Are you sure you want to delete this product?")
        }
        .onReceive(viewModel.$cosmeticBags) { bags in
            if let updatedBag = bags.first(where: { $0.id == bag.id }) {
                bag = updatedBag
            }
        }
        .onAppear {
            appViewModel.enterDetailView()
        }
        .onDisappear {
            appViewModel.exitDetailView()
        }
    }
}

struct FilterBar: View {
    @Binding var selectedFilter: ProductStatus?
    
    var body: some View {
        HStack(spacing: 12) {
            FilterButton(
                title: "All",
                isSelected: selectedFilter == nil,
                action: { selectedFilter = nil }
            )
            
            FilterButton(
                title: "Available",
                isSelected: selectedFilter == .available,
                action: { selectedFilter = .available }
            )
            
            FilterButton(
                title: "Out of Stock",
                isSelected: selectedFilter == .outOfStock,
                action: { selectedFilter = .outOfStock }
            )
            
            Spacer()
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? Color.theme.primaryWhite : Color.theme.primaryWhite.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.theme.primaryPurple : Color.theme.primaryWhite.opacity(0.2))
                )
        }
    }
}

struct EmptyProductsView: View {
    let onAddTap: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No products yet")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text("Add your first product — for example, face cream or lipstick.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
                
                Button(action: onAddTap) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                        Text("Add Product")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(Color.theme.primaryWhite)
                    .frame(width: 160, height: 50)
                    .background(Color.theme.buttonGradient)
                    .cornerRadius(25)
                    .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ProductsList: View {
    let products: [Product]
    let viewModel: CosmeticBagViewModel
    let onEdit: (Product) -> Void
    let onDelete: (Product) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(products) { product in
                    NavigationLink(destination: ProductDetailView(viewModel: viewModel, product: product)) {
                        ProductCard(
                            product: product,
                            onEdit: { onEdit(product) },
                            onDelete: { onDelete(product) }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}

struct ProductCard: View {
    let product: Product
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                    Text("Edit")
                        .font(.ubuntu(11, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color.theme.accentOrange)
                .cornerRadius(12)
                .padding(.leading, 20)
                
                Spacer()
            }
            .opacity(offset > 10 ? min(offset / 80, 1.0) : 0.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
            
            HStack {
                Spacer()
                
                VStack {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                    Text("Delete")
                        .font(.ubuntu(11, weight: .medium))
                        .foregroundColor(Color.theme.primaryWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color.theme.accentRed)
                .cornerRadius(12)
                .padding(.trailing, 20)
            }
            .opacity(offset < -10 ? min(abs(offset) / 80, 1.0) : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
            
            HStack(spacing: 12) {
                Image(systemName: product.status.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(product.status == .available ? Color.theme.accentGreen : Color.theme.accentRed)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(Color.theme.darkGray)
                        .lineLimit(1)
                    
                    Text(product.category.displayName)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(Color.theme.darkGray.opacity(0.7))
                    
                    Text("Expires: \(product.expirationDate, formatter: DateFormatter.shortDate)")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.primaryPurple)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(product.volume)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.darkGray)
                    
                    Text(product.status.displayName)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(product.status == .available ? Color.theme.accentGreen : Color.theme.accentRed)
                }
            }
            .padding(16)
            .frame(height: 80)
            .background(Color.theme.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 6, x: 0, y: 3)
            .offset(x: offset, y: 0)
            .highPriorityGesture(
            DragGesture(minimumDistance: 30)
                .onChanged { value in
                    let translation: CGFloat = value.translation.width
                    if translation > 0 {
                        let ratio: CGFloat = translation / 200.0
                        let clampedRatio = ratio.clamped(to: 0.0...0.5)
                        let resistance: CGFloat = 1.0 - clampedRatio
                        offset = min(translation * resistance, 80)
                    } else {
                        let ratio: CGFloat = abs(translation) / 200.0
                        let clampedRatio = ratio.clamped(to: 0.0...0.5)
                        let resistance: CGFloat = 1.0 - clampedRatio
                        offset = max(translation * resistance, -80)
                    }
                }
                .onEnded { value in
                    let translation = value.translation.width
                    let velocity = value.predictedEndTranslation.width - value.translation.width
                    
                    let threshold: CGFloat = 50
                    let velocityThreshold: CGFloat = 300
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if abs(velocity) > velocityThreshold {
                            if velocity > 0 {
                                offset = 0
                                onEdit()
                            } else {
                                offset = 0
                                onDelete()
                            }
                        } else if translation > threshold {
                            offset = 0
                            onEdit()
                        } else if translation < -threshold {
                            offset = 0
                            onDelete()
                        } else {
                            offset = 0
                        }
                    }
                }
            )
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    CosmeticBagDetailView(
        viewModel: CosmeticBagViewModel(),
        bag: CosmeticBag(name: "Daily", purpose: .mixed, colorTag: .blue)
    )
}
