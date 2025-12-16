import SwiftUI

struct MainTabView: View {
    @StateObject private var cosmeticBagViewModel = CosmeticBagViewModel()
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appViewModel.selectedTab {
                case 0:
                    CosmeticBagsListView(viewModel: cosmeticBagViewModel)
                case 1:
                    ProductCatalogView(viewModel: cosmeticBagViewModel)
                case 2:
                    QuickAddView(viewModel: cosmeticBagViewModel)
                case 3:
                    SearchView(viewModel: cosmeticBagViewModel)
                case 4:
                    SettingsView()
                default:
                    CosmeticBagsListView(viewModel: cosmeticBagViewModel)
                }
            }
            
            
            VStack {
                Spacer()
                
                if !appViewModel.isTabBarHidden {
                    CustomTabBar(selectedTab: $appViewModel.selectedTab)
                }
            }
        }
        .environmentObject(appViewModel)
    }
}

enum QuickAddSheetItem: Identifiable {
    case createBag
    case addProduct(bagId: UUID)
    case selectBag
    
    var id: String {
        switch self {
        case .createBag:
            return "createBag"
        case .addProduct(let bagId):
            return "addProduct-\(bagId.uuidString)"
        case .selectBag:
            return "selectBag"
        }
    }
}

struct QuickAddView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @State private var sheetItem: QuickAddSheetItem?
    
    var totalProducts: Int {
        viewModel.getAllProducts().count
    }
    
    var availableProducts: Int {
        viewModel.getAllProducts().filter { $0.status == .available }.count
    }
    
    var recentBags: [CosmeticBag] {
        Array(viewModel.cosmeticBags.prefix(3))
    }
    
    var recentProducts: [Product] {
        Array(viewModel.getAllProducts().suffix(5))
    }
    
    var activeBag: CosmeticBag? {
        viewModel.cosmeticBags.first { $0.isActive } ?? viewModel.cosmeticBags.first
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 12) {
                            Text("Quick Add")
                                .font(.ubuntu(32, weight: .bold))
                                .foregroundColor(Color.theme.primaryWhite)
                            
                            Text("Fast access to your beauty collection")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                        
                        StatisticsCards(
                            totalBags: viewModel.cosmeticBags.count,
                            totalProducts: totalProducts,
                            availableProducts: availableProducts
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                        QuickActionsSection(
                            onCreateBag: { sheetItem = .createBag },
                            onAddProduct: {
                                if let bag = activeBag {
                                    sheetItem = .addProduct(bagId: bag.id)
                                } else if viewModel.cosmeticBags.count == 1, let bag = viewModel.cosmeticBags.first {
                                    sheetItem = .addProduct(bagId: bag.id)
                                } else {
                                    sheetItem = .selectBag
                                }
                            },
                            hasBags: !viewModel.cosmeticBags.isEmpty
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                        if !viewModel.cosmeticBags.isEmpty {
                            RecentBagsSection(
                                bags: recentBags,
                                viewModel: viewModel
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                        
                        if !recentProducts.isEmpty {
                            RecentProductsSection(
                                products: recentProducts,
                                viewModel: viewModel
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                        
                        TipsSection()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .createBag:
                CreateCosmeticBagView(viewModel: viewModel)
            case .addProduct(let bagId):
                CreateProductView(viewModel: viewModel, cosmeticBagId: bagId)
            case .selectBag:
                BagSelectionView(
                    bags: viewModel.cosmeticBags,
                    onSelect: { bag in
                        sheetItem = .addProduct(bagId: bag.id)
                    }
                )
            }
        }
    }
}

struct StatisticsCards: View {
    let totalBags: Int
    let totalProducts: Int
    let availableProducts: Int
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Bags",
                value: "\(totalBags)",
                icon: "bag.fill",
                color: Color.theme.primaryPurple
            )
            
            StatCard(
                title: "Products",
                value: "\(totalProducts)",
                icon: "list.clipboard.fill",
                color: Color.theme.accentGreen
            )
            
            StatCard(
                title: "Available",
                value: "\(availableProducts)",
                icon: "checkmark.circle.fill",
                color: Color.theme.primaryYellow,
                textColor: Color.theme.darkGray
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var textColor: Color = Color.theme.primaryWhite
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(textColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(textColor)
            }
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(textColor)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(textColor.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

struct QuickActionsSection: View {
    let onCreateBag: () -> Void
    let onAddProduct: () -> Void
    let hasBags: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryWhite)
                .padding(.horizontal, 4)
            
            VStack(spacing: 16) {
                QuickActionButton(
                    title: "Create Cosmetic Bag",
                    subtitle: "Start organizing your beauty products",
                    icon: "bag.fill",
                    gradient: Color.theme.buttonGradient,
                    action: onCreateBag
                )
                
                if hasBags {
                    QuickActionButton(
                        title: "Add Product",
                        subtitle: "Add to your cosmetic bag",
                        icon: "plus.circle.fill",
                        gradient: LinearGradient(
                            gradient: Gradient(colors: [Color.theme.primaryWhite, Color.theme.primaryWhite.opacity(0.9)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        textColor: Color.theme.primaryPurple,
                        action: onAddProduct
                    )
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    var textColor: Color = Color.theme.primaryWhite
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(textColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(textColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(textColor)
                    
                    Text(subtitle)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(textColor.opacity(0.85))
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor.opacity(0.7))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(gradient)
                    .shadow(color: Color.black.opacity(0.15), radius: isPressed ? 8 : 12, x: 0, y: isPressed ? 4 : 6)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

struct RecentBagsSection: View {
    let bags: [CosmeticBag]
    let viewModel: CosmeticBagViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Bags")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Spacer()
            }
            .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(bags) { bag in
                        NavigationLink(destination: CosmeticBagDetailView(viewModel: viewModel, bag: bag)) {
                            RecentBagCard(bag: bag)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct RecentBagCard: View {
    let bag: CosmeticBag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(bag.colorTag.color)
                    .frame(width: 4, height: 30)
                
                Spacer()
                
                if bag.isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.theme.accentGreen)
                }
            }
            
            Text(bag.name)
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(Color.theme.darkGray)
                .lineLimit(1)
            
            Text(bag.purpose.displayName)
                .font(.ubuntu(12, weight: .regular))
                .foregroundColor(Color.theme.darkGray.opacity(0.7))
            
            Text("\(bag.productCount) products")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(bag.colorTag.color)
        }
        .padding(16)
        .frame(width: 160)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct RecentProductsSection: View {
    let products: [Product]
    let viewModel: CosmeticBagViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Products")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Spacer()
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                ForEach(products.prefix(3)) { product in
                    NavigationLink(destination: ProductDetailView(viewModel: viewModel, product: product)) {
                        RecentProductRow(product: product, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct RecentProductRow: View {
    let product: Product
    let viewModel: CosmeticBagViewModel
    
    var cosmeticBag: CosmeticBag? {
        viewModel.getCosmeticBag(by: product.cosmeticBagId)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: product.status.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(product.status == .available ? Color.theme.accentGreen : Color.theme.accentRed)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(Color.theme.darkGray)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    if let bag = cosmeticBag {
                        Text(bag.name)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(bag.colorTag.color)
                    }
                    
                    Text("•")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(Color.theme.darkGray.opacity(0.5))
                    
                    Text(product.category.displayName)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(Color.theme.darkGray.opacity(0.7))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.theme.darkGray.opacity(0.5))
        }
        .padding(16)
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct TipsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tips & Tricks")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Spacer()
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                TipCard(
                    icon: "lightbulb.fill",
                    title: "Organize by Purpose",
                    description: "Create separate bags for daily use, travel, and special occasions"
                )
                
                TipCard(
                    icon: "clock.fill",
                    title: "Track Expiration",
                    description: "Keep an eye on product expiration dates to stay fresh"
                )
                
                TipCard(
                    icon: "tag.fill",
                    title: "Use Color Tags",
                    description: "Color-code your bags for quick visual identification"
                )
            }
        }
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.theme.primaryYellow.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Text(description)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.theme.primaryWhite.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.primaryWhite.opacity(0.2), lineWidth: 1)
        )
    }
}

struct BagSelectionView: View {
    let bags: [CosmeticBag]
    let onSelect: (CosmeticBag) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(bags) { bag in
                            Button(action: {
                                onSelect(bag)
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(bag.colorTag.color)
                                        .frame(width: 6, height: 50)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(bag.name)
                                            .font(.ubuntu(18, weight: .bold))
                                            .foregroundColor(Color.theme.darkGray)
                                        
                                        Text(bag.purpose.displayName)
                                            .font(.ubuntu(14, weight: .regular))
                                            .foregroundColor(Color.theme.darkGray.opacity(0.7))
                                        
                                        Text("\(bag.productCount) products")
                                            .font(.ubuntu(14, weight: .medium))
                                            .foregroundColor(bag.colorTag.color)
                                    }
                                    
                                    Spacer()
                                    
                                    if bag.isActive {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(Color.theme.accentGreen)
                                    }
                                }
                                .padding(20)
                                .background(Color.theme.cardGradient)
                                .cornerRadius(16)
                                .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Select Bag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryWhite)
                }
            }
        }
    }
}

struct SearchView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @State private var searchText = ""
    @State private var selectedCategory: ProductCategory?
    @State private var selectedStatus: ProductStatus?
    @State private var selectedPurpose: BagPurpose?
    @State private var productToEdit: Product?
    @State private var bagToEdit: CosmeticBag?
    
    var filteredProducts: [Product] {
        var products = viewModel.getAllProducts()
        
        if !searchText.isEmpty {
            products = products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            products = products.filter { $0.category == category }
        }
        
        if let status = selectedStatus {
            products = products.filter { $0.status == status }
        }
        
        return products
    }
    
    var filteredBags: [CosmeticBag] {
        var bags = viewModel.cosmeticBags
        
        if !searchText.isEmpty {
            bags = bags.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.purpose.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let purpose = selectedPurpose {
            bags = bags.filter { $0.purpose == purpose }
        }
        
        return bags
    }
    
    var hasResults: Bool {
        !filteredProducts.isEmpty || !filteredBags.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Search")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.theme.darkGray.opacity(0.6))
                            
                            TextField("Search bags, products...", text: $searchText)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(Color.theme.darkGray)
                        }
                        .padding(16)
                        .background(Color.theme.primaryWhite)
                        .cornerRadius(12)
                        .shadow(color: Color.theme.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterButton(
                                title: "All",
                                isSelected: selectedCategory == nil && selectedStatus == nil && selectedPurpose == nil,
                                action: {
                                    selectedCategory = nil
                                    selectedStatus = nil
                                    selectedPurpose = nil
                                }
                            )
                            
                            FilterButton(
                                title: "All Categories",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(ProductCategory.allCases, id: \.self) { category in
                                FilterButton(
                                    title: category.displayName,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                            
                            ForEach(ProductStatus.allCases, id: \.self) { status in
                                FilterButton(
                                    title: status.displayName,
                                    isSelected: selectedStatus == status,
                                    action: { selectedStatus = status }
                                )
                            }
                            
                            ForEach(BagPurpose.allCases, id: \.self) { purpose in
                                FilterButton(
                                    title: purpose.displayName,
                                    isSelected: selectedPurpose == purpose,
                                    action: { selectedPurpose = purpose }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    if searchText.isEmpty && selectedCategory == nil && selectedStatus == nil && selectedPurpose == nil {
                        SearchEmptyState()
                    } else if !hasResults {
                        SearchNoResults(searchText: searchText)
                    } else {
                        SearchResults(
                            products: filteredProducts,
                            bags: filteredBags,
                            viewModel: viewModel,
                            onEditProduct: { product in
                                productToEdit = product
                            },
                            onEditBag: { bag in
                                bagToEdit = bag
                            }
                        )
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $productToEdit) { product in
            CreateProductView(viewModel: viewModel, cosmeticBagId: product.cosmeticBagId, productToEdit: product)
        }
        .sheet(item: $bagToEdit) { bag in
            CreateCosmeticBagView(viewModel: viewModel, bagToEdit: bag)
        }
    }
}

struct SearchEmptyState: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("Start searching")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text("Search for bags and products by name")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct SearchNoResults: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.magnifyingglass")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("No results found")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    if !searchText.isEmpty {
                        Text("No bags or products match \"\(searchText)\"")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct SearchResults: View {
    let products: [Product]
    let bags: [CosmeticBag]
    let viewModel: CosmeticBagViewModel
    let onEditProduct: (Product) -> Void
    let onEditBag: (CosmeticBag) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if !bags.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cosmetic Bags")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                            .padding(.horizontal, 20)
                        
                        ForEach(bags) { bag in
                            NavigationLink(destination: CosmeticBagDetailView(viewModel: viewModel, bag: bag)) {
                                CosmeticBagCard(
                                    bag: bag,
                                    onEdit: { onEditBag(bag) },
                                    onDelete: {
                                        viewModel.deleteCosmeticBag(bag)
                                    }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                if !products.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Products")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(Color.theme.primaryWhite)
                            .padding(.horizontal, 20)
                        
                        ForEach(products) { product in
                            NavigationLink(destination: ProductDetailView(viewModel: viewModel, product: product)) {
                                AllProductsCard(
                                    product: product,
                                    viewModel: viewModel,
                                    onDelete: {
                                        viewModel.deleteProduct(product)
                                    },
                                    onEdit: { onEditProduct(product) }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

#Preview {
    MainTabView(appViewModel: AppViewModel())
}
