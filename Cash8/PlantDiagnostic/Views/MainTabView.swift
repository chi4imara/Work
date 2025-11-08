import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        PlantCatalogView()
                    case 1:
                        CareAdviceView()
                    case 2:
                        DiagnosticsView()
                    case 3:
                        FavoritesView()
                    case 4:
                        SettingsView()
                    default:
                        PlantCatalogView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .shadow(color: Color.black, radius: 15, x: 0, y: 12)
            }
        }
        .environmentObject(appState)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "leaf.fill", title: "Catalog", index: 0),
        TabItem(icon: "book.fill", title: "Tips", index: 1),
        TabItem(icon: "stethoscope", title: "Diagnose", index: 2),
        TabItem(icon: "heart.fill", title: "Favorites", index: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.index
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.cardBackground)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 22 : 18))
                    .foregroundColor(isSelected ? .primaryBackground : .secondaryText)
                
                Text(tab.title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .primaryBackground : .secondaryText)
            }
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}

