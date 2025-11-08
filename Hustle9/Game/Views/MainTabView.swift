import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var gamesViewModel = GamesViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 16) {
                    HStack {
                        Text("BoardFans")
                            .font(AppFonts.largeTitle)
                        
                        Spacer()
                    }
                    
                    Divider()
                        .overlay(AppColors.primaryText)
                        .padding(.horizontal, -12)
                    
                    VStack(spacing: 24) {
                        NavigationLink {
                            GamesListView()
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(gamesViewModel)
                        } label: {
                            MenuCard(
                                icon: "gamecontroller.fill",
                                title: "Games",
                                subtitle: "Your game library",
                                isSelected: selectedTab == 1
                            )
                        }
                        
                        NavigationLink {
                            FavoritesView()
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(gamesViewModel)
                        } label: {
                            MenuCard(
                                icon: "star.fill",
                                title: "Favorites",
                                subtitle: "Starred games",
                                isSelected: selectedTab == 1
                            )
                        }
                        
                        NavigationLink {
                            StatisticsView()
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(gamesViewModel)
                        } label: {
                            MenuCard(
                                icon: "chart.bar.fill",
                                title: "Statistics",
                                subtitle: "Game analytics",
                                isSelected: selectedTab == 2
                            )
                        }
                        
                        NavigationLink {
                            SettingsView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            MenuCard(
                                icon: "gearshape.fill",
                                title: "Settings",
                                subtitle: "App preferences",
                                isSelected: selectedTab == 3,
                                isWide: true
                            )
                        }
                    }
                    .padding(.top, 6)
                    
                    Spacer()
                    
                    Divider()
                        .overlay(AppColors.primaryText)
                        .padding(.horizontal, -12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}
