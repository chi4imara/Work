import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "tshirt", title: "Outfits", tag: 0),
        TabItem(icon: "calendar", title: "Week Plan", tag: 1),
        TabItem(icon: "note.text", title: "Notes", tag: 2),
        TabItem(icon: "heart", title: "Favorites", tag: 3),
        TabItem(icon: "gearshape", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.15))
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 32, height: 32)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? AppColors.primaryPurple : AppColors.secondaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .frame(height: 32)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack {
            AppColors.mainBackgroundGradient
                .ignoresSafeArea()
            
                Group {
                    switch selectedTab {
                    case 0:
                        OutfitListView()
                    case 1:
                        WeekPlanView()
                    case 2:
                        NotesListView()
                    case 3:
                        FavoritesView()
                    case 4:
                        SettingsView()
                    default:
                        OutfitListView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(dataManager)
    }
}

struct FavoritesView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var viewModel = OutfitListViewModel()
    
    var favoriteOutfits: [Outfit] {
        return dataManager.outfits.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Favorites")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if favoriteOutfits.isEmpty {
                        EmptyStateView(
                            icon: "heart",
                            title: "No Favorite Outfits",
                            description: "Mark outfits as favorites to see them here"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(favoriteOutfits) { outfit in
                                    NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
                                        OutfitCard(outfit: outfit, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainTabView()
}
