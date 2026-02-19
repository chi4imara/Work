import SwiftUI

struct AddEditWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.presentationMode) var presentationMode
    
    let workoutToEdit: Workout?
    
    @State private var selectedDate = Date()
    @State private var pushUps = ""
    @State private var abs = ""
    @State private var plankSeconds = ""
    @State private var squats = ""
    @State private var coreLifts = ""
    @State private var comment = ""
    
    init(workoutToEdit: Workout? = nil) {
        self.workoutToEdit = workoutToEdit
    }
    
    var isEditing: Bool {
        workoutToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        dateSection
                        
                        exerciseSection
                        
                        commentSection
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Workout" : "New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.primaryText)
            )
            .preferredColorScheme(.dark)
        }
        .onAppear {
            if let workout = workoutToEdit {
                loadWorkoutData(workout)
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .accentColor(AppColors.lightBlue)
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
    
    private var exerciseSection: some View {
        VStack(spacing: 16) {
            Text("Exercises")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ExerciseInputRow(
                title: "Push-ups",
                unit: "reps",
                value: $pushUps
            )
            
            ExerciseInputRow(
                title: "Abs",
                unit: "reps",
                value: $abs
            )
            
            ExerciseInputRow(
                title: "Plank",
                unit: "seconds",
                value: $plankSeconds
            )
            
            ExerciseInputRow(
                title: "Squats",
                unit: "reps",
                value: $squats
            )
            
            ExerciseInputRow(
                title: "Core Lifts",
                unit: "reps",
                value: $coreLifts
            )
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
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            TextField("Add a comment...", text: $comment, axis: .vertical)
                .font(.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .lineLimit(3...6)
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
    
    private var saveButton: some View {
        Button(action: saveWorkout) {
            Text(isEditing ? "Save Changes" : "Save Workout")
                .font(.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.buttonGradient)
                )
        }
        .disabled(!hasValidData)
        .opacity(hasValidData ? 1.0 : 0.5)
    }
    
    private var hasValidData: Bool {
        !pushUps.isEmpty || !abs.isEmpty || !plankSeconds.isEmpty || !squats.isEmpty || !coreLifts.isEmpty
    }
    
    private func loadWorkoutData(_ workout: Workout) {
        selectedDate = workout.date
        comment = workout.comment
        
        for exercise in workout.exercises {
            switch exercise.type {
            case .pushUps:
                pushUps = String(exercise.value)
            case .abs:
                abs = String(exercise.value)
            case .plank:
                plankSeconds = String(exercise.value)
            case .squats:
                squats = String(exercise.value)
            case .coreLifts:
                coreLifts = String(exercise.value)
            }
        }
    }
    
    private func saveWorkout() {
        var exercises: [ExerciseResult] = []
        
        if let pushUpsValue = Int(pushUps), pushUpsValue > 0 {
            exercises.append(ExerciseResult(type: .pushUps, value: pushUpsValue))
        }
        
        if let absValue = Int(abs), absValue > 0 {
            exercises.append(ExerciseResult(type: .abs, value: absValue))
        }
        
        if let plankValue = Int(plankSeconds), plankValue > 0 {
            exercises.append(ExerciseResult(type: .plank, value: plankValue))
        }
        
        if let squatsValue = Int(squats), squatsValue > 0 {
            exercises.append(ExerciseResult(type: .squats, value: squatsValue))
        }
        
        if let coreLiftsValue = Int(coreLifts), coreLiftsValue > 0 {
            exercises.append(ExerciseResult(type: .coreLifts, value: coreLiftsValue))
        }
        
        let workout = Workout(
            date: selectedDate,
            exercises: exercises,
            comment: comment
        )
        
        if let existingWorkout = workoutToEdit {
            let updatedWorkout = Workout(
                date: selectedDate,
                exercises: exercises,
                comment: comment,
                id: existingWorkout.id
            )
            workoutManager.updateWorkout(updatedWorkout)
        } else {
            workoutManager.addWorkout(workout)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct ExerciseInputRow: View {
    let title: String
    let unit: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(.medium, size: 16))
                .foregroundColor(AppColors.primaryText)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            TextField("0", text: $value)
                .font(.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.primaryText)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            
            Text(unit)
                .font(.ubuntu(.regular, size: 14))
                .foregroundColor(AppColors.secondaryText)
                .frame(width: 60, alignment: .leading)
        }
    }
}

#Preview {
    AddEditWorkoutView()
        .environmentObject(WorkoutManager())
}
