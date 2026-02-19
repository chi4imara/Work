import SwiftUI

struct MainTabView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NewWorkoutView(workoutViewModel: workoutViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "plus.circle.fill" : "plus.circle")
                        .font(.system(size: 24))
                    Text("Add")
                        .font(.ubuntu(12, weight: .medium))
                }
                .tag(0)
            
            WorkoutJournalView(workoutViewModel: workoutViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                        .font(.system(size: 24))
                    Text("Journal")
                        .font(.ubuntu(12, weight: .medium))
                }
                .tag(1)
            
            StatisticsView(workoutViewModel: workoutViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: 24))
                    Text("Statistics")
                        .font(.ubuntu(12, weight: .medium))
                }
                .tag(2)
            
            SettingsView(workoutViewModel: workoutViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 24))
                    Text("Settings")
                        .font(.ubuntu(12, weight: .medium))
                }
                .tag(3)
        }
        .accentColor(AppColors.lightBlue)
        .preferredColorScheme(.dark)
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Profile")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Text("Your fitness profile")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Text("Coming Soon")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Text("Profile features will be available in future updates.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MainTabView()
}
