import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var appState: AppState
    
    var totalWorkouts: Int {
        appState.phases.reduce(0) { $0 + $1.workouts.count }
    }
    
    var recentWorkouts: [WorkoutWithPhase] {
        var workouts: [WorkoutWithPhase] = []
        
        for phase in appState.phases {
            for workout in phase.workouts {
                workouts.append(WorkoutWithPhase(workout: workout, phaseName: phase.name.rawValue))
            }
        }
        
        return workouts.sorted { $0.workout.date > $1.workout.date }.prefix(10).map { $0 }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Results")
                        .font(.playfairDisplay(.bold, size: 32))
                        .foregroundColor(AppColors.white)
                        .padding(.vertical, 20)
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            StatCard(
                                title: "Total Phases",
                                value: "\(appState.phases.count)",
                                color: AppColors.lightBlue
                            )
                            
                            StatCard(
                                title: "Total Workouts",
                                value: "\(totalWorkouts)",
                                color: AppColors.orange
                            )
                        }
                        
                        HStack(spacing: 15) {
                            StatCard(
                                title: "Active Phases",
                                value: "\(appState.phases.count)",
                                color: AppColors.green
                            )
                            
                            StatCard(
                                title: "This Week",
                                value: "\(workoutsThisWeek())",
                                color: AppColors.red
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Recent Workouts")
                                .font(.playfairDisplay(.semiBold, size: 20))
                                .foregroundColor(AppColors.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        if recentWorkouts.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "chart.bar")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppColors.lightBlue.opacity(0.6))
                                
                                Text("No workouts recorded yet.")
                                    .font(.playfairDisplay(.medium, size: 16))
                                    .foregroundColor(AppColors.white.opacity(0.7))
                            }
                            .padding(40)
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(recentWorkouts, id: \.workout.id) { workoutWithPhase in
                                    RecentWorkoutCard(workoutWithPhase: workoutWithPhase)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private func workoutsThisWeek() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        
        return recentWorkouts.filter { workoutWithPhase in
            workoutWithPhase.workout.date >= startOfWeek
        }.count
    }
}

struct WorkoutWithPhase {
    let workout: Workout
    let phaseName: String
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Text(value)
                .font(.playfairDisplay(.bold, size: 28))
                .foregroundColor(color)
            
            Text(title)
                .font(.playfairDisplay(.medium, size: 14))
                .foregroundColor(AppColors.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
    }
}

struct RecentWorkoutCard: View {
    let workoutWithPhase: WorkoutWithPhase
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(workoutWithPhase.workout.date, style: .date)
                    .font(.playfairDisplay(.medium, size: 12))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(workoutWithPhase.workout.type)
                    .font(.playfairDisplay(.semiBold, size: 16))
                    .foregroundColor(AppColors.white)
                
                Text(workoutWithPhase.workout.result)
                    .font(.playfairDisplay(.regular, size: 14))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(workoutWithPhase.phaseName)
                    .font(.playfairDisplay(.medium, size: 12))
                    .foregroundColor(AppColors.orange)
            }
        }
        .padding(15)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

#Preview {
    ResultsView()
        .environmentObject(AppState())
}
