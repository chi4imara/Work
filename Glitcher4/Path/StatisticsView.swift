import SwiftUI

struct StatisticsView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @State private var selectedWorkoutId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Statistics")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Text("Your training progress")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if let statistics = workoutViewModel.getStatistics() {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    StatisticCard(
                                        title: "Total Distance",
                                        value: statistics.formattedTotalDistance,
                                        icon: "location.fill",
                                        color: AppColors.lightBlue
                                    )
                                    
                                    StatisticCard(
                                        title: "Total Duration",
                                        value: statistics.formattedTotalDuration,
                                        icon: "timer.circle.fill",
                                        color: AppColors.orange
                                    )
                                }
                                
                                HStack(spacing: 16) {
                                    if let bestDistance = statistics.bestDistanceWorkout {
                                        StatisticCard(
                                            title: "Best Distance",
                                            value: bestDistance.formattedDistance,
                                            icon: "trophy.fill",
                                            color: AppColors.green
                                        )
                                    }
                                    
                                    if let bestDuration = statistics.bestDurationWorkout {
                                        StatisticCard(
                                            title: "Best Duration",
                                            value: bestDuration.formattedDuration,
                                            icon: "medal.fill",
                                            color: AppColors.red
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("All Workouts")
                                        .font(.ubuntu(20, weight: .bold))
                                        .foregroundColor(AppColors.white)
                                    
                                    Spacer()
                                    
                                    Text("\(workoutViewModel.workouts.count) total")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(AppColors.white.opacity(0.7))
                                }
                                .padding(.horizontal, 24)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(workoutViewModel.sortedWorkouts) { workout in
                                        StatisticsWorkoutRow(workout: workout) {
                                            selectedWorkoutId = workout.id
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                } else {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.white.opacity(0.5))
                        
                        VStack(spacing: 8) {
                            Text("No statistics yet")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.white)
                            
                            Text("Not enough data for statistics.")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
        .sheet(item: $selectedWorkoutId) { workoutId in
            WorkoutDetailView(
                workoutId: workoutId,
                workoutViewModel: workoutViewModel
            ) {
                selectedWorkoutId = nil
            }
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
    }
}

struct StatisticsWorkoutRow: View {
    let workout: Workout
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(AppColors.lightBlue)
                    .frame(width: 8, height: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(workout.type)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.white)
                    
                    Text(workout.formattedDate)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.6))
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Text(workout.formattedDistance)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.orange)
                    
                    Text(workout.formattedDuration)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardGradient.opacity(0.5))
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    StatisticsView(workoutViewModel: WorkoutViewModel())
}
