import SwiftUI

struct FriendsFitnessApp: View {
    @EnvironmentObject var workoutViewModel: WorkoutViewModel
    @State private var selectedTab: TabItem = .journal
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if workoutViewModel.showOnboarding {
                OnboardingView(viewModel: workoutViewModel)
                    .transition(.slide)
            } else {
                mainAppView
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: workoutViewModel.showOnboarding)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showSplash = false
            }
        }
    }
    
    private var mainAppView: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .journal:
                    WorkoutJournalView(viewModel: workoutViewModel)
                case .progress:
                    ProgressView(viewModel: workoutViewModel)
                case .profile:
                    AchievementsView(viewModel: workoutViewModel)
                case .stats:
                    StatsView(viewModel: workoutViewModel)
                case .settings:
                    SettingsView()
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct StatsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(size: 32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if viewModel.workouts.isEmpty {
                            VStack(spacing: 20) {
                                Spacer()
                                
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(AppColors.gray)
                                
                                Text("No statistics available")
                                    .font(.ubuntu(size: 18, weight: .medium))
                                    .foregroundColor(AppColors.gray)
                                
                                Spacer()
                            }
                            .padding(.top, 60)
                            
                            Spacer()
                            
                        } else {
                            muscleGroupDistribution
                            
                            weeklyActivity
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var muscleGroupDistribution: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Muscle Group Distribution")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            let muscleGroupCounts = Dictionary(grouping: viewModel.workouts.flatMap { $0.muscleGroups }) { $0 }
                .mapValues { $0.count }
                .sorted { $0.value > $1.value }
            
            ForEach(Array(muscleGroupCounts.enumerated()), id: \.offset) { index, item in
                HStack {
                    Text(item.key.displayName)
                        .font(.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                    
                    Text("\(item.value)")
                        .font(.ubuntu(size: 16, weight: .bold))
                        .foregroundColor(AppColors.lightBlue)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
            }
        }
    }
    
    private var weeklyActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            let recentWorkouts = Array(viewModel.workouts.prefix(5))
            
            ForEach(recentWorkouts) { workout in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDate(workout.date))
                            .font(.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(AppColors.white)
                        
                        Text(workout.muscleGroupsString)
                            .font(.ubuntu(size: 14, weight: .regular))
                            .foregroundColor(AppColors.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.green)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    FriendsFitnessApp()
        .environmentObject(WorkoutViewModel())
}
