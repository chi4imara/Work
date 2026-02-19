import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ProcedureViewModel()
    
    var body: some View {
        TabView {
            ProceduresView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("Procedures")
                }
                .tag(0)
            
            ScheduleView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
                .tag(1)
            
            TodayView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "sun.max")
                    Text("Today")
                }
                .tag(2)
            
            ProgressView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primaryYellow)
    }
}

struct PlaceholderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: icon)
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                    
                    VStack(spacing: 15) {
                        Text(title)
                            .font(.bellGothic(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryBlue)
                        
                        Text("Coming soon...")
                            .font(.bellGothic(size: 16))
                            .foregroundColor(AppColors.darkGray)
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
