import SwiftUI

struct NewWorkoutView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var workoutName = ""
    @State private var exercises: [Exercise] = []
    @State private var notes = ""
    @State private var newExerciseName = ""
    @State private var newExerciseReps = ""
    
    let editingWorkout: Workout?
    
    init(editingWorkout: Workout? = nil) {
        self.editingWorkout = editingWorkout
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Workout Name")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Enter workout name", text: $workoutName)
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(16)
                                .background(ColorManager.inputBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Exercises")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            ForEach(exercises.indices, id: \.self) { index in
                                ExerciseRow(
                                    exercise: exercises[index],
                                    onDelete: {
                                        exercises.remove(at: index)
                                    }
                                )
                            }
                            
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    TextField("Exercise name", text: $newExerciseName)
                                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(ColorManager.primaryText)
                                        .padding(16)
                                        .background(ColorManager.inputBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    TextField("Reps/Time", text: $newExerciseReps)
                                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(ColorManager.primaryText)
                                        .padding(16)
                                        .background(ColorManager.inputBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 1)
                                        )
                                        .frame(width: 120)
                                }
                                
                                Button(action: addExercise) {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add Exercise")
                                    }
                                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(ColorManager.buttonBackground)
                                    .cornerRadius(12)
                                }
                                .disabled(newExerciseName.isEmpty || newExerciseReps.isEmpty)
                                .opacity(newExerciseName.isEmpty || newExerciseReps.isEmpty ? 0.6 : 1.0)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Add workout notes", text: $notes, axis: .vertical)
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(16)
                                .background(ColorManager.inputBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 1)
                                )
                                .frame(minHeight: 80)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(editingWorkout != nil ? "Edit Workout" : "New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorManager.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.accentBlue)
                    .disabled(workoutName.isEmpty || exercises.isEmpty)
                }
            }
        }
        .onAppear {
            if let workout = editingWorkout {
                workoutName = workout.name
                exercises = workout.exercises
                notes = workout.note
            }
        }
    }
    
    private func addExercise() {
        let exercise = Exercise(name: newExerciseName, reps: newExerciseReps)
        exercises.append(exercise)
        newExerciseName = ""
        newExerciseReps = ""
    }
    
    private func saveWorkout() {
        if let editingWorkout = editingWorkout {
            var updatedWorkout = editingWorkout
            updatedWorkout.name = workoutName
            updatedWorkout.exercises = exercises
            updatedWorkout.note = notes
            workoutStore.updateWorkout(updatedWorkout)
        } else {
            let newWorkout = Workout(name: workoutName, exercises: exercises, note: notes)
            workoutStore.addWorkout(newWorkout)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(exercise.reps)
                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(ColorManager.errorRed)
            }
        }
        .padding(16)
        .background(ColorManager.inputBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorManager.accentBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    NewWorkoutView()
        .environmentObject(WorkoutStore())
}
