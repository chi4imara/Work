import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    @State private var showingAddItem = false
    @State private var selectedSeasonFilter: Season? = nil
    @State private var showingSeasonFilter = false
    
    var filteredShoppingItems: [WardrobeItem] {
        let buyItems = viewModel.shoppingItems
        
        if let season = selectedSeasonFilter {
            return buyItems.filter { $0.season == season }
        }
        
        return buyItems
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    controlsView
                    
                    if filteredShoppingItems.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        shoppingListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemViewForShopping(viewModel: viewModel)
        }
        .actionSheet(isPresented: $showingSeasonFilter) {
            seasonFilterActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Shopping List")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                if let season = selectedSeasonFilter {
                    Text(season.displayName)
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(.primaryPurple)
                } else {
                    Text("All Seasons")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(.primaryPurple)
                }
            }
            
            Spacer()
            
            Button(action: { showingSeasonFilter = true }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryPurple)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.primaryYellow.opacity(0.2))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var controlsView: some View {
        VStack(spacing: 16) {
            Button(action: { showingAddItem = true }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Purchase")
                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(.textOnDark)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.accentOrange)
                        .shadow(color: AppShadows.buttonShadow, radius: 4, x: 0, y: 2)
                )
            }
            .padding(.horizontal, 20)
            
            if !filteredShoppingItems.isEmpty {
                Text("\(filteredShoppingItems.count) item\(filteredShoppingItems.count == 1 ? "" : "s") to buy")
                    .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary.opacity(0.5))
            
            Text("No purchases planned")
                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text("Add items you want to buy for the new season.")
                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddItem = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Purchase")
                }
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(.textOnDark)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.accentOrange)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var shoppingListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredShoppingItems) { item in
                    NavigationLink(destination: ItemDetailView(item: item, viewModel: viewModel)) {
                        ShoppingItemCard(item: item, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var seasonFilterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Filter by Season"),
            buttons: [
                .default(Text("All Seasons")) {
                    selectedSeasonFilter = nil
                }
            ] + Season.allCases.map { season in
                .default(Text(season.displayName)) {
                    selectedSeasonFilter = season
                }
            } + [.cancel()]
        )
    }
}

struct ShoppingItemCard: View {
    let item: WardrobeItem
    @ObservedObject var viewModel: WardrobeViewModel
    @State private var showingStatusChange = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "cart.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.accentOrange)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                HStack {
                    Text(item.category.displayName)
                        .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text(item.season.displayName)
                        .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(.primaryPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.primaryPurple.opacity(0.1))
                        )
                }
                
                if !item.comment.isEmpty {
                    Text(item.comment)
                        .font(FontManager.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
            }
            
            Button(action: { showingStatusChange = true }) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.accentGreen)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: AppShadows.cardShadow, radius: 4, x: 0, y: 2)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Bought") {
                viewModel.updateItemStatus(item, newStatus: .inUse)
            }
            .tint(.accentGreen)
            
            Button("Delete") {
                viewModel.deleteItem(item)
            }
            .tint(.accentOrange)
        }
        .actionSheet(isPresented: $showingStatusChange) {
            ActionSheet(
                title: Text("Mark as Bought?"),
                message: Text("This will move the item to your wardrobe."),
                buttons: [
                    .default(Text("Mark as Bought")) {
                        viewModel.updateItemStatus(item, newStatus: .inUse)
                    },
                    .cancel()
                ]
            )
        }
    }
}
