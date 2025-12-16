import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var itemStore: ItemStore
    @State private var showingSplash = true
    @State private var showingOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") == false
    @State private var selectedTab = 0
    @State private var selectedItemId: UUID?
    @State private var showingItemDetail = false
    
    var body: some View {
        ZStack {
            MainTabView()
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView(showOnboarding: $showingOnboarding)
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                }
        }
        .sheet(isPresented: $showingItemDetail, onDismiss: {
            selectedItemId = nil
        }) {
            if let itemId = selectedItemId {
                NavigationView {
                    ItemDetailView(itemId: itemId)
                        .environmentObject(itemStore)
                }
            }
        }
        .onChange(of: selectedItemId) { newValue in
            showingItemDetail = newValue != nil
        }
    }
    
    @ViewBuilder
    private func MainTabView() -> some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    CatalogView()
                        .environmentObject(itemStore)
                case 1:
                    CategoriesView()
                        .environmentObject(itemStore)
                case 2:
                    StoriesView()
                        .environmentObject(itemStore)
                case 3:
                    StatisticsView()
                        .environmentObject(itemStore)
                case 4:
                    SettingsView()
                default:
                    CatalogView()
                        .environmentObject(itemStore)
                }
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainAppView()
        .environmentObject(ItemStore())
}
