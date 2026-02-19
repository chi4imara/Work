import SwiftUI

struct WorkoutJournalView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @State private var selectedWorkoutId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Workout Journal")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Text("Your training history")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.7))
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if workoutViewModel.hasWorkouts {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(workoutViewModel.sortedWorkouts) { workout in
                                WorkoutJournalCard(workout: workout) {
                                    selectedWorkoutId = workout.id
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 100)
                    }
                } else {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "book.closed")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.white.opacity(0.5))
                        
                        VStack(spacing: 8) {
                            Text("No workouts yet")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.white)
                            
                            Text("You haven't added any workouts yet.")
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

struct WorkoutJournalCard: View {
    let workout: Workout
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(workout.type)
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Text(workout.formattedDate)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                HStack(spacing: 24) {
                    StatItem(
                        icon: "timer",
                        title: "Duration",
                        value: workout.formattedDuration
                    )
                    
                    StatItem(
                        icon: "location",
                        title: "Distance",
                        value: workout.formattedDistance
                    )
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.lightBlue)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
            
            Text(value)
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.white)
        }
    }
}

#Preview {
    WorkoutJournalView(workoutViewModel: WorkoutViewModel())
}
