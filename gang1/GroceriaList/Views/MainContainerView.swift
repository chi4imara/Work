import SwiftUI

struct MainContainerView: View {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var shoppingListViewModel = ShoppingListViewModel()
    
    var body: some View {
        ZStack {
        if appViewModel.isFirstLaunch {
                OnboardingView(appViewModel: appViewModel)
                    .transition(.slide)
            } else {
                MainTabView(
                    appViewModel: appViewModel,
                    shoppingListViewModel: shoppingListViewModel
                )
                .transition(.slide)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplashScreen)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isFirstLaunch)
        .onAppear {
            FontManager.shared.reg()
        }
    }
}

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    @ObservedObject var shoppingListViewModel: ShoppingListViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                Group {
                    switch appViewModel.selectedTab {
                    case 0:
                        ShoppingListView(appViewModel: appViewModel, viewModel: shoppingListViewModel)
                    case 1:
                        AddProductView(viewModel: shoppingListViewModel)
                    case 2:
                        CategoriesView(viewModel: shoppingListViewModel)
                    case 3:
                        ShoppingTipsView(appViewModel: appViewModel)
                    case 4:
                        ProfileView()
                    default:
                        ShoppingListView(appViewModel: appViewModel, viewModel: shoppingListViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
        .sheet(isPresented: $shoppingListViewModel.showingCategories) {
            CategoriesView(viewModel: shoppingListViewModel)
        }
        .sheet(isPresented: $shoppingListViewModel.showingTips) {
            ShoppingTipsView(appViewModel: appViewModel)
        }
        .onChange(of: appViewModel.selectedTab) { newTab in
            if newTab == 1 {
                shoppingListViewModel.showingAddProduct = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appViewModel.selectedTab = 0
                }
            }
        }
    }
}

#Preview {
    MainContainerView()
}
