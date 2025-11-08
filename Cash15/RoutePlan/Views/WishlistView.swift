import SwiftUI

struct WishlistView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddWish = false
    @State private var selectedItems: Set<UUID> = []
    @State private var isMultiSelectMode = false
    @State private var expandedItems: Set<UUID> = []
    
    var sortedWishlist: [WishlistItem] {
        dataManager.getSortedWishlist()
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if sortedWishlist.isEmpty {
                    emptyStateView
                } else {
                    wishlistContent
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddWish) {
            WishlistFormView(item: nil)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Wishlist")
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: { showingAddWish = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryText.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No dream destinations yet")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add your first country or city dream")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddWish = true }) {
                Text("Add Destination")
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.background)
                    .frame(width: 200, height: 50)
                    .background(ColorTheme.primaryText)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var wishlistContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sortedWishlist) { item in
                    WishlistCardView(
                        item: item,
                        isSelected: selectedItems.contains(item.id),
                        isMultiSelectMode: isMultiSelectMode,
                        isExpanded: expandedItems.contains(item.id)
                    ) {
                        if isMultiSelectMode {
                            toggleSelection(for: item)
                        } else {
                            toggleExpansion(for: item)
                        }
                    } onSwipeLeft: {
                        deleteItem(item)
                    } onSwipeRight: {
                        dataManager.toggleWishlistPriority(item)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .overlay(
            multiSelectToolbar,
            alignment: .bottom
        )
    }
    
    private var multiSelectToolbar: some View {
        Group {
            if isMultiSelectMode {
                HStack {
                    Button("Cancel") {
                        isMultiSelectMode = false
                        selectedItems.removeAll()
                    }
                    .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Button("Delete Selected (\(selectedItems.count))") {
                        deleteSelectedItems()
                    }
                    .foregroundColor(ColorTheme.error)
                    .disabled(selectedItems.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(ColorTheme.tabBarBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private func toggleSelection(for item: WishlistItem) {
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
        } else {
            selectedItems.insert(item.id)
        }
        
        if selectedItems.isEmpty {
            isMultiSelectMode = false
        }
    }
    
    private func toggleExpansion(for item: WishlistItem) {
        if expandedItems.contains(item.id) {
            expandedItems.remove(item.id)
        } else {
            expandedItems.insert(item.id)
        }
    }
    
    private func deleteItem(_ item: WishlistItem) {
        dataManager.deleteWishlistItem(item)
    }
    
    private func deleteSelectedItems() {
        for itemId in selectedItems {
            if let item = sortedWishlist.first(where: { $0.id == itemId }) {
                dataManager.deleteWishlistItem(item)
            }
        }
        selectedItems.removeAll()
        isMultiSelectMode = false
    }
}

struct WishlistCardView: View {
    let item: WishlistItem
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let isExpanded: Bool
    let action: () -> Void
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    
    @StateObject private var dataManager = DataManager.shared
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            if isMultiSelectMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.borderColor)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(FontManager.headline)
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !item.locationString.isEmpty {
                        Text(item.locationString)
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
                
                if !item.notes.isEmpty {
                    Text(isExpanded ? item.notes : item.shortNotes)
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(isExpanded ? nil : 2)
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    dataManager.toggleWishlistPriority(item)
                }) {
                    Image(systemName: item.isPriority ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(item.isPriority ? ColorTheme.accent : ColorTheme.secondaryText)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorTheme.error)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? ColorTheme.primaryText : ColorTheme.borderColor, lineWidth: 1)
        )
        .onTapGesture {
            if !isMultiSelectMode {
                action()
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteWishlistItem(item)
            }
        } message: {
            Text("This item will be permanently deleted from your wishlist.")
        }
    }
}

#Preview {
    WishlistView()
}

