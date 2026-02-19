import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var workoutViewModel: WorkoutViewModel
    @State private var workoutType = ""
    @State private var duration = ""
    @State private var distance = ""
    @State private var selectedDate = Date()
    @State private var comment = ""
    @State private var savedWorkout: Workout?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("New Workout")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.white)
                        
                        Text("Track your endurance session")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(AppColors.white.opacity(0.7))
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        CustomInputField(
                            title: "Workout Type",
                            text: $workoutType,
                            placeholder: "e.g. Running, Cycling, Swimming"
                        )
                        
                        CustomInputField(
                            title: "Duration (min)",
                            text: $duration,
                            placeholder: "e.g. 30, 45, 90",
                            keyboardType: .numberPad
                        )
                        
                        CustomInputField(
                            title: "Distance (km)",
                            text: $distance,
                            placeholder: "e.g. 5.2, 12, 1.5",
                            keyboardType: .decimalPad
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(AppColors.lightBlue)
                                .colorScheme(.dark)
                                .padding()
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            TextEditor(text: $comment)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.white)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 80)
                                .padding()
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Button(action: saveWorkout) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                            Text("Save Workout")
                                .font(.ubuntu(18, weight: .medium))
                        }
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [AppColors.lightBlue, AppColors.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: $savedWorkout) { workout in
            WorkoutSavedView(workout: workout) {
                savedWorkout = nil
                clearForm()
            }
        }
    }
    
    private var isFormValid: Bool {
        !workoutType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !duration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !distance.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Int(duration) != nil &&
        Double(distance) != nil
    }
    
    private func saveWorkout() {
        guard let durationInt = Int(duration),
              let distanceDouble = Double(distance) else { return }
        
        let workout = Workout(
            type: workoutType.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: durationInt,
            distance: distanceDouble,
            date: selectedDate,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        workoutViewModel.addWorkout(workout)
        savedWorkout = workout
    }
    
    private func clearForm() {
        workoutType = ""
        duration = ""
        distance = ""
        selectedDate = Date()
        comment = ""
    }
}

struct CustomInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.white)
            
            TextField(placeholder, text: $text)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.white)
                .keyboardType(keyboardType)
                .padding()
                .background(AppColors.cardGradient)
                .cornerRadius(12)
        }
    }
}

#Preview {
    NewWorkoutView(workoutViewModel: WorkoutViewModel())
}
