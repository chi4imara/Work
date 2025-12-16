import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var appViewModel: AppViewModel
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var showingMenu = false
    @State private var showingDeleteAlert = false
    @State private var showingClearAlert = false
    @State private var productToDelete: Product?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                    .frame(width: CGFloat.random(in: 20...50))
                    .position(
                        x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
                        y: CGFloat.random(in: 100...(UIScreen.main.bounds.height - 200))
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                    .padding(.bottom, 6)
                
                if viewModel.filteredProducts.isEmpty {
                    emptyStateView
                } else {
                    productListView
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showingAddProduct) {
            AddProductView(viewModel: viewModel)
        }
        .sheet(item: $viewModel.editingProduct) { product in
            EditProductView(viewModel: viewModel, product: product)
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let product = productToDelete {
                    viewModel.deleteProduct(product)
                }
            }
        } message: {
            Text("Are you sure you want to delete this product?")
        }
        .alert("Clear All Products", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                viewModel.clearAllProducts()
            }
        } message: {
            Text("This will remove all products from your list. This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Shopping List")
                .font(FontManager.ubuntuBold(28))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    showingMenu = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .frame(width: 40, height: 40)
                        .concaveCard(cornerRadius: 20, depth: 3, color: ColorManager.buttonSecondary)
                }
                
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .confirmationDialog("Menu", isPresented: $showingMenu) {
            Button("Delete Completed") {
                viewModel.deleteCompletedProducts()
            }
            
            Button("Clear All", role: .destructive) {
                showingClearAlert = true
            }
            
            Button("Categories") {
                withAnimation {
                    appViewModel.selectedTab = 2
                }
            }
            
            Button("Shopping Tips") {
                withAnimation {
                    appViewModel.selectedTab = 3
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorManager.secondaryText)
            
            TextField("Search by name...", text: $viewModel.searchText)
                .font(FontManager.ubuntu(16))
                .foregroundColor(ColorManager.primaryText)
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ColorManager.buttonSecondary)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryYellow)
            
            VStack(spacing: 12) {
                Text("Your list is empty")
                    .font(FontManager.ubuntuBold(24))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Add your first product to get started")
                    .font(FontManager.ubuntu(16))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Button(action: {
                viewModel.showingAddProduct = true
            }) {
                Text("Add Product")
                    .font(FontManager.ubuntuMedium(18))
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(width: 200, height: 50)
                    .concaveCard(cornerRadius: 25, depth: 4, color: ColorManager.primaryYellow)
            }
            
            Spacer()
        }
    }
    
    private var productListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductRowView(
                        product: product,
                        onToggle: {
                            viewModel.toggleProductCompletion(product)
                        },
                        onEdit: {
                            viewModel.editingProduct = product
                        },
                        onDelete: {
                            productToDelete = product
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct ProductRowView: View {
    let product: Product
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
                if dragOffset.width > 50 {
                    HStack {
                        VStack(spacing: 8) {
                            Image(systemName: "pencil")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Edit")
                                .font(FontManager.ubuntuMedium(14))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .concaveCard(
                            cornerRadius: 12,
                            depth: 3,
                            color: Color.green
                        )
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                }
                
                if dragOffset.width < -50 {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 8) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Delete")
                                .font(FontManager.ubuntuMedium(14))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .concaveCard(
                            cornerRadius: 12,
                            depth: 3,
                            color: Color.red
                        )
                        .padding(.horizontal, 16)
                    }
                }
            
            HStack(spacing: 15) {
                Button(action: {
                    HapticManager.shared.impact(.light)
                    onToggle()
                }) {
                    Image(systemName: product.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(product.isCompleted ? ColorManager.success : ColorManager.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(FontManager.ubuntuMedium(16))
                        .foregroundColor(product.isCompleted ? ColorManager.secondaryText : ColorManager.primaryBlue)
                        .strikethrough(product.isCompleted)
                    
                    HStack {
                        Text("Category: \(product.category)")
                            .font(FontManager.ubuntu(14))
                            .foregroundColor(!product.isCompleted ? .gray.opacity(0.7)  : ColorManager.secondaryText)
                        
                        if !product.quantity.isEmpty {
                            Text("• \(product.quantity)")
                                .font(FontManager.ubuntu(14))
                                .foregroundColor(!product.isCompleted ? .gray.opacity(0.7) : ColorManager.secondaryText)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .foregroundColor(ColorManager.primaryBlue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .concaveCard(
                cornerRadius: 12, 
                depth: 3, 
                color: product.isCompleted ? 
                    ColorManager.cardBackgroundCompleted : 
                    ColorManager.cardBackground
            )
            .offset(x: dragOffset.width, y: 0)
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.width < -100 {
                        HapticManager.shared.impact(.medium)
                        onDelete()
                    } else if value.translation.width > 100 {
                        HapticManager.shared.impact(.medium)
                        onEdit()
                    }
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        dragOffset = .zero
                    }
                }
        )
    }
}
