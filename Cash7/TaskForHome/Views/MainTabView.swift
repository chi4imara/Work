import SwiftUI

struct MainTabView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .today:
                        NavigationView {
                            TodayView(viewModel: taskViewModel)
                                .navigationBarHidden(true)
                        }
                        
                    case .rooms:
                        NavigationView {
                            RoomsView(viewModel: taskViewModel)
                                .navigationBarHidden(true)
                        }
                        
                    case .statistics:
                        NavigationView {
                            StatisticsView(viewModel: taskViewModel)
                                .navigationBarHidden(true)
                        }
                        
                    case .archive:
                        NavigationView {
                            ArchiveView(viewModel: taskViewModel)
                                .navigationBarHidden(true)
                        }
                        
                    case .settings:
                        NavigationView {
                            SettingsView()
                                .navigationBarHidden(true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            taskViewModel.resetDailyTasks()
        }
    }
}

#Preview {
    MainTabView()
}

