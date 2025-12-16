import SwiftUI

enum TabItem: Int, CaseIterable {
    case recipes = 0
    case categories = 1
    case notes = 2
    case inspiration = 3
    case settings = 4
    
    var title: String {
        switch self {
        case .recipes: return "Recipes"
        case .categories: return "Categories"
        case .notes: return "Notes"
        case .inspiration: return "Inspiration"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .recipes: return "book.closed"
        case .categories: return "fork.knife"
        case .notes: return "note.text"
        case .inspiration: return "leaf"
        case .settings: return "gearshape"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: TabItem = .recipes
    @EnvironmentObject var recipeStore: RecipeStore
    @EnvironmentObject var noteStore: NoteStore
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .recipes:
                        RecipesView()
                    case .categories:
                        CategoriesView()
                    case .notes:
                        NotesView()
                    case .inspiration:
                        InspirationView()
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(recipeStore)
        .environmentObject(noteStore)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 10, x: 0, y: -5)
                .frame(height: 80)
            
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.rawValue) { tab in
                    TabBarItem(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = tab
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                            .animation(.easeInOut(duration: 0.2), value: isSelected)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                }
                
                Text(tab.title)
                    .font(FontManager.caption2)
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
