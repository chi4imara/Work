import SwiftUI

struct MainView: View {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var fragranceViewModel = FragranceViewModel()
    
    var body: some View {
        ZStack {
            if appViewModel.isFirstLaunch {
                OnboardingView(appViewModel: appViewModel)
            } else {
                MainTabView(
                    appViewModel: appViewModel,
                    fragranceViewModel: fragranceViewModel
                )
            }
        }
    }
}

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    @ObservedObject var fragranceViewModel: FragranceViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
                Group {
                    switch appViewModel.selectedTab {
                    case 0:
                        ArchiveView(fragranceViewModel: fragranceViewModel)
                    case 1:
                        SelectionView(
                            fragranceViewModel: fragranceViewModel,
                            appViewModel: appViewModel
                        )
                    case 2:
                        FiltersView(
                            fragranceViewModel: fragranceViewModel,
                            appViewModel: appViewModel
                        )
                    case 3:
                        StatisticsView(fragranceViewModel: fragranceViewModel)
                    case 4:
                        SettingsView()
                    default:
                        ArchiveView(fragranceViewModel: fragranceViewModel)
                    }
                }
                
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
    }
}

#Preview {
    MainView()
}
