import SwiftUI

struct EditExerciseView: View {
    let exercise: Exercise
    @EnvironmentObject var viewModel: ExerciseViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var exerciseName: String
    
    init(exercise: Exercise) {
        self.exercise = exercise
        _exerciseName = State(initialValue: exercise.name)
    }
    
    private var isFormValid: Bool {
        !exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        exerciseName != exercise.name
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                        
                        Spacer()
                        
                        Text("Edit Exercise")
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveExercise()
                        }
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(isFormValid ? AppColors.lightBlue : AppColors.secondaryText)
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            FormField(
                                title: "Exercise Name",
                                text: $exerciseName,
                                placeholder: "Bench Press"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
    
    private func saveExercise() {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.updateExercise(exercise, newName: trimmedName)
        dismiss()
    }
}

#Preview {
    let sampleExercise = Exercise(name: "Bench Press")
    EditExerciseView(exercise: sampleExercise)
        .environmentObject(ExerciseViewModel())
}

