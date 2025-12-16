import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppStateViewModel
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    
    var body: some View {
        ZStack {
        if !appState.hasCompletedOnboarding {
                OnboardingView(appState: appState)
            } else {
                MainAppView()
                    .environmentObject(itemsViewModel)
                    .environmentObject(appState)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appState.hasCompletedOnboarding)
    }
}

struct MainAppView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appState.selectedTab {
                case 0:
                    WishlistMainView(selectedTab: $appState.selectedTab)
                        .environmentObject(itemsViewModel)
                        .environmentObject(appState)
                case 1:
                    AnalysisMainView()
                        .environmentObject(itemsViewModel)
                case 2:
                    SummaryMainView()
                        .environmentObject(itemsViewModel)
                case 3:
                    NewItemView()
                        .environmentObject(itemsViewModel)
                        .environmentObject(appState)
                case 4:
                    SettingsMainView()
                default:
                    WishlistMainView(selectedTab: $appState.selectedTab)
                        .environmentObject(itemsViewModel)
                        .environmentObject(appState)
                }
            }
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
    }
}

struct QuickAddView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @EnvironmentObject var appState: AppStateViewModel
    @State private var showingNewItemView = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.purpleGradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 12) {
                    Text("Quick Add")
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.primaryPurple)
                    
                    Text("Add a new item to your wishlist")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.neutralGray)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: { showingNewItemView = true }) {
                    Text("Add New Item")
                        .font(AppTypography.buttonText)
                }
                .primaryButtonStyle()
                .padding(.horizontal, 60)
                
                Spacer()
            }
        }
        .onAppear {
            showingNewItemView = true
        }
        .sheet(isPresented: $showingNewItemView, onDismiss: {
            appState.selectTab(0)
        }) {
            NewItemView()
                .environmentObject(itemsViewModel)
                .environmentObject(appState)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppStateViewModel())
        .environmentObject(ItemsViewModel())
}
