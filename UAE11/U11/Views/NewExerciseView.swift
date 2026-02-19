import SwiftUI

struct NewExerciseView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var exerciseName = ""
    @State private var weight = ""
    @State private var reps = ""
    
    private var isFormValid: Bool {
        !exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
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
                        
                        Text("New Exercise")
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
                            
                            FormField(
                                title: "Weight (kg)",
                                text: $weight,
                                placeholder: "80",
                                keyboardType: .decimalPad
                            )
                            
                            FormField(
                                title: "Repetitions",
                                text: $reps,
                                placeholder: "5",
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
    
    private func saveExercise() {
        guard let weightValue = Double(weight),
              let repsValue = Int(reps) else { return }
        
        viewModel.addExercise(
            name: exerciseName.trimmingCharacters(in: .whitespacesAndNewlines),
            weight: weightValue,
            reps: repsValue
        )
        
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardGradient)
                )
                .keyboardType(keyboardType)
        }
    }
}

#Preview {
    NewExerciseView()
        .environmentObject(ExerciseViewModel())
}
