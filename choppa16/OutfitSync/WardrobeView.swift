import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    @State private var showingAddItem = false
    @State private var showingSeasonPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    controlsView
                    
                    if viewModel.filteredItems.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        itemsListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(viewModel: viewModel)
        }
        .actionSheet(isPresented: $showingSeasonPicker) {
            seasonPickerActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Wardrobe")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text(viewModel.selectedSeason.displayName)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.primaryPurple)
            }
            
            Spacer()
            
            Button(action: { showingSeasonPicker = true }) {
                Image(systemName: "calendar")
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
                    Text("Add Item")
                        .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                }
                .foregroundColor(.textOnDark)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.primaryPurple)
                        .shadow(color: AppShadows.buttonShadow, radius: 4, x: 0, y: 2)
                )
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ItemFilter.allCases, id: \.rawValue) { filter in
                        FilterButton(
                            title: filter.displayName,
                            isSelected: viewModel.selectedFilter == filter
                        ) {
                            viewModel.selectedFilter = filter
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tshirt")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary.opacity(0.5))
            
            Text("Your wardrobe is empty")
                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text("Add your first item for the current season.")
                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddItem = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Item")
                }
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(.textOnDark)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.primaryPurple)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var itemsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredItems) { item in
                    NavigationLink(destination: ItemDetailView(item: item, viewModel: viewModel)) {
                        ItemCard(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var seasonPickerActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Select Season"),
            buttons: Season.allCases.map { season in
                .default(Text(season.displayName)) {
                    viewModel.selectedSeason = season
                }
            } + [.cancel()]
        )
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .textOnDark : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? Color.primaryBlue : Color.cardBackground)
                        .shadow(color: AppShadows.cardShadow, radius: isSelected ? 4 : 2, x: 0, y: 2)
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct ItemCard: View {
    let item: WardrobeItem
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                HStack {
                    Text(item.category.displayName)
                        .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text(item.status.displayName)
                        .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(statusColor.opacity(0.1))
                        )
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: AppShadows.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
    
    private var statusColor: Color {
        switch item.status {
        case .inUse:
            return .accentGreen
        case .store:
            return .primaryBlue
        case .buy:
            return .accentOrange
        }
    }
}
