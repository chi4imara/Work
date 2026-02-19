import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Environment(\.presentationMode) var presentationMode
    
    let workout: Workout
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var currentWorkout: Workout {
        workoutStore.workouts.first { $0.id == workout.id } ?? workout
    }
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(currentWorkout.name)
                            .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Exercises")
                                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                                    .foregroundColor(ColorManager.secondaryText)
                                
                                Text("\(currentWorkout.exerciseCount)")
                                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                    .foregroundColor(ColorManager.accentBlue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Last Completed")
                                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                                    .foregroundColor(ColorManager.secondaryText)
                                
                                Text(currentWorkout.lastPerformedText)
                                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                    .foregroundColor(currentWorkout.lastPerformed != nil ? ColorManager.successGreen : ColorManager.secondaryText)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(ColorManager.cardGradient)
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Exercises")
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        ForEach(currentWorkout.exercises.indices, id: \.self) { index in
                            ExerciseDetailRow(
                                exercise: currentWorkout.exercises[index],
                                number: index + 1
                            )
                        }
                    }
                    
                    if !currentWorkout.note.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notes")
                                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text(currentWorkout.note)
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(ColorManager.cardGradient)
                                .cornerRadius(12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            workoutStore.completeWorkout(currentWorkout)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Mark as Completed")
                            }
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorManager.accentGradient)
                            .cornerRadius(25)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                showingEditSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(ColorManager.buttonBackground)
                                .cornerRadius(22)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                }
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(ColorManager.errorRed)
                                .cornerRadius(22)
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .id("\(currentWorkout.id)-\(currentWorkout.lastPerformed?.timeIntervalSince1970 ?? 0)")
        .sheet(isPresented: $showingEditSheet) {
            NewWorkoutView(editingWorkout: currentWorkout)
        }
        .alert("Delete Workout", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                workoutStore.deleteWorkout(currentWorkout)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this workout? This action cannot be undone.")
        }
    }
}

struct ExerciseDetailRow: View {
    let exercise: Exercise
    let number: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(number)")
                .font(FontManager.playfairDisplay(size: 16, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .frame(width: 32, height: 32)
                .background(ColorManager.accentBlue.opacity(0.2))
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(exercise.reps)
                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.accentBlue)
            }
            
            Spacer()
        }
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorManager.accentBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    let sampleWorkout = Workout(
        name: "Morning Set",
        exercises: [
            Exercise(name: "Push-ups", reps: "20 reps"),
            Exercise(name: "Squats", reps: "30 reps"),
            Exercise(name: "Plank", reps: "60 seconds")
        ],
        note: "Quick morning routine"
    )
    
    return NavigationView {
        WorkoutDetailView(workout: sampleWorkout)
            .environmentObject(WorkoutStore())
    }
}
