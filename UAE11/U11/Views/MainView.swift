import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    WorkoutProgressView()
                case 2:
                    StatisticsFullView()
                case 3:
                    AchievementsView()
                case 4:
                    SettingsView()
                default:
                    HomeView()
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}


#Preview {
    MainView()
        .environmentObject(ExerciseViewModel())
}
