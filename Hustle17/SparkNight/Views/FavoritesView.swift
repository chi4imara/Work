import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var expandedItems: Set<UUID> = []
    @State private var showDeleteAlert = false
    @State private var itemToDelete: FavoriteItem?
    
    var body: some View {
            ZStack {
                StaticBackground()
                
                if viewModel.favorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesListView
                }
            }
        .alert("Remove from Favorites", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let item = itemToDelete {
                    viewModel.removeFavorite(item)
                    itemToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to remove this item from favorites?")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Favorites")
                    .font(.theme.title1)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top)
            
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Favorites Yet")
                    .font(.theme.title2)
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Save your favorite tasks and themes to see them here")
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.selectedTab = 1
                }) {
                    HStack {
                        Image(systemName: "circle.grid.cross.fill")
                        Text("Try Wheel of Fortune")
                    }
                    .font(.theme.callout)
                    .foregroundColor(ColorTheme.textLight)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(ColorTheme.buttonGradient)
                    .cornerRadius(22)
                }
                
                Button(action: {
                    viewModel.selectedTab = 2
                }) {
                    HStack {
                        Image(systemName: "theatermasks.fill")
                        Text("Generate Themes")
                    }
                    .font(.theme.callout)
                    .foregroundColor(ColorTheme.accentPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        ColorTheme.backgroundWhite
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(ColorTheme.accentPurple, lineWidth: 2)
                    )
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var favoritesListView: some View {
        VStack {
            HStack {
                Text("Favorites")
                    .font(.theme.title1)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top)
            .padding(.bottom, -1)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.favorites) { favorite in
                        FavoriteItemCard(
                            item: favorite,
                            isExpanded: expandedItems.contains(favorite.id),
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if expandedItems.contains(favorite.id) {
                                        expandedItems.remove(favorite.id)
                                    } else {
                                        expandedItems.insert(favorite.id)
                                    }
                                }
                            },
                            onDelete: {
                                itemToDelete = favorite
                                showDeleteAlert = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
}

struct FavoriteItemCard: View {
    let item: FavoriteItem
    let isExpanded: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var showDeleteButton = false
    
    private var typeColor: Color {
        switch item.type {
        case .task:
            return ColorTheme.primaryBlue
        case .theme:
            return ColorTheme.accentPurple
        }
    }
    
    private var typeIcon: String {
        switch item.type {
        case .task:
            return "star.circle.fill"
        case .theme:
            return "theatermasks.fill"
        }
    }
    
    private var displayText: String {
        if isExpanded || item.text.count <= 100 {
            return item.text
        } else {
            return String(item.text.prefix(100)) + "..."
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: onDelete) {
                    VStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20, weight: .medium))
                        Text("Delete")
                            .font(.theme.caption1)
                    }
                    .foregroundColor(.white)
                    .frame(width: 80)
                }
                .frame(maxHeight: .infinity)
                .background(ColorTheme.accentPink)
                .cornerRadius(16)
            }
            
            HStack(spacing: 16) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(typeColor.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: typeIcon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(typeColor)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.type == .task ? "Task" : "Theme")
                            .font(.theme.caption1)
                            .foregroundColor(typeColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(typeColor.opacity(0.1))
                            )
                        
                        Spacer()
                        
                        Text(formatDate(item.dateAdded))
                            .font(.theme.caption2)
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    Text(displayText)
                        .font(.theme.body)
                        .foregroundColor(ColorTheme.textPrimary)
                        .lineLimit(isExpanded ? nil : 3)
                        .multilineTextAlignment(.leading)
                    
                    if item.text.count > 100 {
                        Button(action: onTap) {
                            Text(isExpanded ? "Show less" : "Show more")
                                .font(.theme.caption1)
                                .foregroundColor(typeColor)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .offset(dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            dragOffset = CGSize(width: max(value.translation.width, -80), height: 0)
                            showDeleteButton = dragOffset.width < -40
                        }
                        else if value.translation.width > 0 && dragOffset.width < 0 {
                            dragOffset = CGSize(width: min(value.translation.width, 0), height: 0)
                            showDeleteButton = dragOffset.width < -40
                        }
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if dragOffset.width < -40 {
                                dragOffset = CGSize(width: -80, height: 0)
                                showDeleteButton = true
                            } else if dragOffset.width > -40 && dragOffset.width < 0 {
                                dragOffset = .zero
                                showDeleteButton = false
                            } else {
                                dragOffset = .zero
                                showDeleteButton = false
                            }
                        }
                    }
            )
            .onTapGesture {
                if dragOffset != .zero {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dragOffset = .zero
                        showDeleteButton = false
                    }
                } else if item.text.count <= 100 {
                } else {
                    onTap()
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    FavoritesView(viewModel: AppViewModel())
}
