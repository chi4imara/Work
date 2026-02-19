import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: StoreViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("Categories")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Text("Browse stores by category")
                        .font(.ubuntu(16))
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.stores.isEmpty {
                    EmptyStateView(
                        title: "No stores in categories yet",
                        subtitle: "Add your first store to see categories",
                        systemImage: "folder"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            let categoryCounts = viewModel.getCategoryCounts()
                            
                            ForEach(StoreCategory.allCases, id: \.self) { category in
                                let count = categoryCounts[category] ?? 0
                                if count > 0 {
                                    CategoryCardView(
                                        category: category,
                                        count: count,
                                        stores: viewModel.getStoresByCategory(category)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct CategoryCardView: View {
    let category: StoreCategory
    let count: Int
    let stores: [Store]
    @State private var isExpanded = false
    
    private var categoryIcon: String {
        switch category {
        case .clothing:
            return "tshirt.fill"
        case .cosmetics:
            return "paintbrush.fill"
        case .shoes:
            return "shoe.fill"
        case .home:
            return "house.fill"
        case .accessories:
            return "bag.fill"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .clothing:
            return .blue
        case .cosmetics:
            return .pink
        case .shoes:
            return .brown
        case .home:
            return .green
        case .accessories:
            return .purple
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [categoryColor.opacity(0.3), categoryColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: categoryIcon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(categoryColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.displayName)
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.appText)
                        
                        Text("\(count) \(count == 1 ? "store" : "stores")")
                            .font(.ubuntu(14))
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appTextSecondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
                .padding(16)
                .background(Color.appCardBackground)
                .cornerRadius(16)
                .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(stores) { store in
                        StoreRowView(store: store)
                    }
                }
                .padding(.top, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct StoreRowView: View {
    let store: Store
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: store.type == .online ? "globe" : "storefront")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appPrimary)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(store.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appText)
                
                HStack {
                    Text(store.type.displayName)
                        .font(.ubuntu(12))
                        .foregroundColor(.appTextSecondary)
                    
                    Text("•")
                        .font(.ubuntu(12))
                        .foregroundColor(.appTextSecondary)
                    
                    Text(store.priceLevel.displayName)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(.appAccent)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.appCardBackground.opacity(0.7))
        .cornerRadius(12)
        .shadow(color: Color.appShadow, radius: 4, x: 0, y: 2)
    }
}

