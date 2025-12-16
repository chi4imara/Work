import SwiftUI

struct WishlistMainView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @EnvironmentObject var appState: AppStateViewModel
    @State private var showingAddItem = false
    @State private var selectedItem: Item?
    @State private var showingItemDetails = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    filterButtonsView
                    
                    if itemsViewModel.isEmpty {
                        emptyStateView
                    } else {
                        itemsListView
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            NewItemView()
                .environmentObject(itemsViewModel)
                .environmentObject(appState)
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailsView(itemId: item.id)
                .environmentObject(itemsViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("I Want to Buy")
                    .font(AppTypography.title1)
                    .foregroundColor(AppColors.primaryPurple)
                
                Text("\(itemsViewModel.filteredItems.count) items")
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppColors.neutralGray)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(AppColors.purpleGradient)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var filterButtonsView: some View {
        HStack(spacing: 12) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                FilterButton(
                    title: filter.displayName,
                    isSelected: itemsViewModel.currentFilter == filter
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        itemsViewModel.setFilter(filter)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightPurple.opacity(0.3))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.circle")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            VStack(spacing: 12) {
                Text("Your list is empty")
                    .font(AppTypography.title3)
                    .foregroundColor(AppColors.primaryPurple)
                
                Text("Add your first item to start planning your purchases!")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Text("Add Item")
                    .font(AppTypography.buttonText)
                    .primaryButtonStyle()
            }
            .padding(.horizontal, 60)
            
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    private var itemsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(itemsViewModel.filteredItems) { item in
                    ItemCardView(item: item) {
                        selectedItem = item
                    } onToggleStatus: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            itemsViewModel.toggleItemStatus(item)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
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
                .font(AppTypography.callout)
                .foregroundColor(isSelected ? .white : AppColors.primaryPurple)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.purpleGradient)
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.clear)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.primaryPurple.opacity(0.3), lineWidth: 1)
                    )
                )
        }
    }
}

struct ItemCardView: View {
    let item: Item
    let onTap: () -> Void
    let onToggleStatus: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Button(action: onToggleStatus) {
                    Image(systemName: item.status == .purchased ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(item.status == .purchased ? AppColors.successGreen : AppColors.neutralGray)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.name)
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.darkGray)
                            .strikethrough(item.status == .purchased)
                        
                        Spacer()
                        
                        Text("$\(Int(item.estimatedPrice))")
                            .font(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.blueText)
                    }
                    
                    HStack {
                        Text(item.priority.displayName)
                            .font(AppTypography.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.priorityColor(for: item.priority))
                            )
                        
                        Spacer()
                        
                        Text(item.status.displayName)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.statusColor(for: item.status))
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.neutralGray)
            }
            .padding(16)
        }
        .cardStyle()
    }
}
