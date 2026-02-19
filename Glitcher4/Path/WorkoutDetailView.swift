import SwiftUI

struct WorkoutDetailView: View {
    let workoutId: UUID
    @ObservedObject var workoutViewModel: WorkoutViewModel
    let onDismiss: () -> Void
    
    @State private var editWorkoutId: UUID?
    @State private var showingDeleteAlert = false
    
    private var workout: Workout? {
        workoutViewModel.getWorkout(by: workoutId)
    }
    
    var body: some View {
        Group {
            if let workout = workout {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            HStack {
                                Button(action: onDismiss) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(AppColors.white)
                                        .frame(width: 44, height: 44)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(22)
                                }
                                
                                Spacer()
                                
                                Text(workout.type)
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(AppColors.white)
                                
                                Spacer()
                                
                                Color.clear
                                    .frame(width: 44, height: 44)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .padding(.bottom, 32)
                            
                            ScrollView {
                                VStack(spacing: 24) {
                                    VStack(spacing: 20) {
                                        HStack(spacing: 32) {
                                            StatCard(
                                                icon: "timer",
                                                title: "Duration",
                                                value: workout.formattedDuration,
                                                color: AppColors.lightBlue
                                            )
                                            
                                            StatCard(
                                                icon: "location",
                                                title: "Distance",
                                                value: workout.formattedDistance,
                                                color: AppColors.orange
                                            )
                                        }
                                        
                                        HStack {
                                            Image(systemName: "calendar")
                                                .font(.system(size: 16))
                                                .foregroundColor(AppColors.white.opacity(0.7))
                                            
                                            Text("Date")
                                                .font(.ubuntu(16, weight: .medium))
                                                .foregroundColor(AppColors.white.opacity(0.7))
                                            
                                            Spacer()
                                            
                                            Text(workout.formattedDate)
                                                .font(.ubuntu(16, weight: .bold))
                                                .foregroundColor(AppColors.white)
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                    .padding(24)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(20)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "text.bubble")
                                                .font(.system(size: 16))
                                                .foregroundColor(AppColors.white.opacity(0.7))
                                            
                                            Text("Comment")
                                                .font(.ubuntu(18, weight: .bold))
                                                .foregroundColor(AppColors.white)
                                            
                                            Spacer()
                                        }
                                        
                                        Text(workout.hasComment ? workout.comment : "No comment added.")
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(workout.hasComment ? AppColors.white : AppColors.white.opacity(0.5))
                                            .lineSpacing(4)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(24)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(20)
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 120)
                            }
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Button(action: { editWorkoutId = workoutId }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Edit")
                                            .font(.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.lightBlue)
                                    .cornerRadius(25)
                                }
                                
                                Button(action: { showingDeleteAlert = true }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Delete")
                                            .font(.ubuntu(16, weight: .medium))
                                    }
                                    .foregroundColor(AppColors.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.red)
                                    .cornerRadius(25)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 50)
                        }
                    }
                }
                .navigationBarHidden(true)
                .sheet(item: $editWorkoutId) { workoutId in
                    EditWorkoutView(
                        workoutId: workoutId,
                        workoutViewModel: workoutViewModel
                    ) {
                        editWorkoutId = nil
                    }
                }
                .alert("Delete Workout", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        workoutViewModel.deleteWorkout(workout)
                        onDismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this workout? This action cannot be undone.")
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.white.opacity(0.7))
            
            Text(value)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let workout = Workout(
        type: "Running",
        duration: 30,
        distance: 5.2,
        date: Date(),
        comment: "Great morning run in the park!"
    )
    return WorkoutDetailView(
        workoutId: workout.id,
        workoutViewModel: WorkoutViewModel(),
        onDismiss: {}
    )
}
