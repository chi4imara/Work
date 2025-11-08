import SwiftUI

struct MainTabView: View {
    @StateObject private var hobbyViewModel = HobbyViewModel()
    @State private var selectedTab: TabItem = .home
    @State private var showingHobbyDetail = false
    @State private var isSidebarOpen = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5)) {
                            isSidebarOpen = true
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(ColorTheme.primaryBlue.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text(selectedTab.title)
                        .font(FontManager.headline)
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .background( WebPatternBackground())
                
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(viewModel: hobbyViewModel)
                    case .planner:
                        PlannerView(viewModel: hobbyViewModel)
                    case .analytics:
                        AnalyticsView(viewModel: hobbyViewModel)
                    case .settings:
                        SettingsView()
                    }
                }
            }
            
            if isSidebarOpen {
                CustomSidebar(selectedTab: $selectedTab, isOpen: $isSidebarOpen)
                    .zIndex(1000)
            }
        }
        .sheet(isPresented: $showingHobbyDetail) {
            if hobbyViewModel.selectedHobby != nil {
                NavigationView {
                    HobbyDetailView(viewModel: hobbyViewModel)
                }
            }
        }
        .onChange(of: hobbyViewModel.selectedHobby) { hobby in
            if hobby != nil {
                showingHobbyDetail = true
            }
        }
        .onChange(of: showingHobbyDetail) { isShowing in
            if !isShowing {
                hobbyViewModel.selectedHobby = nil
            }
        }
    }
}
