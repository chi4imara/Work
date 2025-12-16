import SwiftUI
import Combine

struct ProductID: Identifiable {
    let id: String
}

struct ProductsView: View {
    @StateObject private var viewModel = CareJournalViewModel()
    @State private var selectedFilter: ProductFilter = .all
    @State private var productID: ProductID?
    
    enum ProductFilter: String, CaseIterable {
        case all = "all"
        case frequent = "frequent"
        case rare = "rare"
        
        var displayName: String {
            switch self {
            case .all:
                return "All Products"
            case .frequent:
                return "Frequently Used"
            case .rare:
                return "Rarely Used"
            }
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                filterView
                
                if filteredProducts.isEmpty {
                    emptyStateView
                } else {
                    productsListView
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $productID) { product in
            ProductEntriesView(productName: product.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Products")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                viewModel.objectWillChange.send()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.yellow)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ProductFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.displayName,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, -20)
    }
    
    private var productsListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(Array(filteredProducts.keys.sorted()), id: \.self) { productName in
                    if let usageCount = filteredProducts[productName] {
                        ProductCard(
                            productName: productName,
                            usageCount: usageCount,
                            isFrequent: viewModel.frequentlyUsedProducts.contains(productName),
                            lastUsed: getLastUsedDate(for: productName)
                        ) {
                            productID = ProductID(id: productName)
                        }
                    }
                }
            }
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "drop.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryText.opacity(0.5))
            
            Text("No products yet")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Products will appear here once you add entries to your journal.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var filteredProducts: [String: Int] {
        let stats = viewModel.productUsageStats
        
        switch selectedFilter {
        case .all:
            return stats
        case .frequent:
            return stats.filter { $0.value >= 3 }
        case .rare:
            return stats.filter { $0.value < 3 }
        }
    }
    
    private func getLastUsedDate(for productName: String) -> Date? {
        return viewModel.entries
            .filter { $0.name == productName && $0.type == .product }
            .sorted { $0.date > $1.date }
            .first?.date
    }
}

struct ProductCard: View {
    let productName: String
    let usageCount: Int
    let isFrequent: Bool
    let lastUsed: Date?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.yellow)
                        .frame(width: 48, height: 48)
                        .background(AppColors.yellow.opacity(0.2))
                        .cornerRadius(24)
                    
                    if isFrequent {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.yellow)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(productName)
                        .font(AppFonts.bodyBold)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text("Used \(usageCount) time\(usageCount == 1 ? "" : "s")")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if let lastUsed = lastUsed {
                        Text("Last used: \(lastUsed, style: .date)")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("\(usageCount)")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.yellow)
                    
                    Text("times")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppColors.yellow.opacity(0.15))
                .cornerRadius(12)
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFrequent ? AppColors.yellow.opacity(0.5) : AppColors.yellow.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProductEntriesView: View {
    let productName: String
    @ObservedObject var viewModel: CareJournalViewModel
    @Environment(\.dismiss) private var dismiss
    
    var productEntries: [CareEntry] {
        viewModel.getEntriesForProduct(productName)
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(productEntries) { entry in
                            CareEntryCard(
                                entry: entry,
                                isFrequentlyUsed: false
                            ) {
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(productName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.yellow)
                }
            }
        }
    }
}

#Preview {
    ProductsView()
}
