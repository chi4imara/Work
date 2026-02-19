import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.presentationMode) var presentationMode
    
    let workout: Workout
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        exerciseResultsView
                        
                        if !workout.comment.isEmpty {
                            commentView
                        }
                        
                        actionButtonsView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            AddEditWorkoutView(workoutToEdit: workout)
                .environmentObject(workoutManager)
        }
        .alert("Delete Workout?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                workoutManager.deleteWorkout(workout)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text(dateFormatter.string(from: workout.date))
                    .font(.ubuntu(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                if workoutManager.hasPersonalBest(workout) {
                    Text("Personal Best Achieved!")
                        .font(.ubuntu(.medium, size: 14))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.orangeGradient)
                        )
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var exerciseResultsView: some View {
        VStack(spacing: 16) {
            Text("Exercise Results")
                .font(.ubuntu(.medium, size: 20))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ForEach(workout.exercises, id: \.id) { exercise in
                    ExerciseResultRow(
                        exercise: exercise,
                        isPersonalBest: workoutManager.isPersonalBest(workout, for: exercise.type)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var commentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            Text(workout.comment)
                .font(.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Workout")
                        .font(.ubuntu(.medium, size: 16))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.buttonGradient)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Workout")
                        .font(.ubuntu(.medium, size: 16))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.error, AppColors.error.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
        }
    }
}

struct ExerciseResultRow: View {
    let exercise: ExerciseResult
    let isPersonalBest: Bool
    
    var body: some View {
        HStack {
            Text(exercise.type.rawValue)
                .font(.ubuntu(.medium, size: 16))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(exercise.value)")
                    .font(.ubuntu(.bold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text(exercise.type.unit)
                    .font(.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                
                if isPersonalBest {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.orange)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isPersonalBest ? AppColors.orange.opacity(0.1) : Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isPersonalBest ? AppColors.orange.opacity(0.3) : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
    }
}

#Preview {
    let sampleWorkout = Workout(
        date: Date(),
        exercises: [
            ExerciseResult(type: .pushUps, value: 35),
            ExerciseResult(type: .abs, value: 50),
            ExerciseResult(type: .plank, value: 60)
        ],
        comment: "Great morning workout!"
    )
    
    return NavigationView {
        WorkoutDetailView(workout: sampleWorkout)
            .environmentObject(WorkoutManager())
    }
}
