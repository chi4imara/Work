import SwiftUI

struct EditWorkoutView: View {
    let workoutId: UUID
    @ObservedObject var workoutViewModel: WorkoutViewModel
    let onDismiss: () -> Void
    
    @State private var workoutType: String = ""
    @State private var duration: String = ""
    @State private var distance: String = ""
    @State private var selectedDate: Date = Date()
    @State private var comment: String = ""
    
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
                                    Text("Cancel")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.lightBlue)
                                }
                                
                                Spacer()
                                
                                Text("Edit Workout")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.white)
                                
                                Spacer()
                                
                                Button(action: saveChanges) {
                                    Text("Save")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(isFormValid ? AppColors.lightBlue : AppColors.gray)
                                }
                                .disabled(!isFormValid)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            .padding(.bottom, 32)
                            
                            ScrollView {
                                VStack(spacing: 24) {
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
                                    .padding(.bottom, 100)
                                }
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear {
                    loadWorkoutData(workout)
                }
                .onChange(of: workoutViewModel.workouts) { _ in
                    if let updatedWorkout = workoutViewModel.getWorkout(by: workoutId) {
                        loadWorkoutData(updatedWorkout)
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    private func loadWorkoutData(_ workout: Workout) {
        workoutType = workout.type
        duration = String(workout.duration)
        distance = String(workout.distance)
        selectedDate = workout.date
        comment = workout.comment
    }
    
    private var isFormValid: Bool {
        !workoutType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !duration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !distance.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        Int(duration) != nil &&
        Double(distance) != nil
    }
    
    private func saveChanges() {
        guard let durationInt = Int(duration),
              let distanceDouble = Double(distance),
              let currentWorkout = workout else { return }
        
        var updatedWorkout = currentWorkout
        updatedWorkout.type = workoutType.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedWorkout.duration = durationInt
        updatedWorkout.distance = distanceDouble
        updatedWorkout.date = selectedDate
        updatedWorkout.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        workoutViewModel.updateWorkout(updatedWorkout)
        onDismiss()
    }
}

#Preview {
    let workout = Workout(
        type: "Running",
        duration: 30,
        distance: 5.2,
        date: Date(),
        comment: "Great morning run!"
    )
    return EditWorkoutView(
        workoutId: workout.id,
        workoutViewModel: WorkoutViewModel(),
        onDismiss: {}
    )
}
