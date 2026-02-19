import SwiftUI

struct NewResultView: View {
    let exercise: Exercise
    @EnvironmentObject var viewModel: ExerciseViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var weight = ""
    @State private var reps = ""
    
    private var isFormValid: Bool {
        !weight.isEmpty &&
        !reps.isEmpty &&
        Double(weight) != nil &&
        Int(reps) != nil
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
                        
                        Text("New Result")
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveResult()
                        }
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(isFormValid ? AppColors.lightBlue : AppColors.secondaryText)
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    HStack {
                        VStack(spacing: 8) {
                            Text("Adding result for")
                                .font(.playfairDisplay(size: 14))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(exercise.name)
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            FormField(
                                title: "Weight (kg)",
                                text: $weight,
                                placeholder: exercise.lastResult?.formattedWeight.replacingOccurrences(of: " kg", with: "") ?? "80",
                                keyboardType: .decimalPad
                            )
                            
                            FormField(
                                title: "Repetitions",
                                text: $reps,
                                placeholder: "\(exercise.lastResult?.reps ?? 5)",
                                keyboardType: .numberPad
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
    
    private func saveResult() {
        guard let weightValue = Double(weight),
              let repsValue = Int(reps) else { return }
        
        viewModel.addResult(to: exercise, weight: weightValue, reps: repsValue)
        dismiss()
    }
}

#Preview {
    let sampleExercise = Exercise(name: "Bench Press")
    NewResultView(exercise: sampleExercise)
        .environmentObject(ExerciseViewModel())
}
