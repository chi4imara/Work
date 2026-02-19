import SwiftUI

struct EditWorkoutView: View {
    let workout: Workout
    @ObservedObject var viewModel: WorkoutViewModel
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate: Date
    @State private var selectedMuscleGroups: Set<MuscleGroup>
    @State private var comment: String
    @State private var otherMuscleGroup: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(workout: Workout, viewModel: WorkoutViewModel, onSave: @escaping () -> Void) {
        self.workout = workout
        self.viewModel = viewModel
        self.onSave = onSave
        
        _selectedDate = State(initialValue: workout.date)
        _selectedMuscleGroups = State(initialValue: workout.muscleGroups)
        _comment = State(initialValue: workout.comment)
        _otherMuscleGroup = State(initialValue: workout.otherMuscleGroup ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        dateSelectionView
                        
                        muscleGroupsView
                        
                        commentView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.gray),
                trailing: Button("Save Changes") {
                    saveWorkout()
                }
                .foregroundColor(AppColors.lightBlue)
                .font(.ubuntu(size: 16, weight: .medium))
            )
            .preferredColorScheme(.dark)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.white)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .colorScheme(.dark)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private var muscleGroupsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Muscle Groups")
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(MuscleGroup.allCases, id: \.self) { group in
                    MuscleGroupCheckbox(
                        group: group,
                        isSelected: selectedMuscleGroups.contains(group),
                        otherText: $otherMuscleGroup
                    ) { isSelected in
                        if isSelected {
                            selectedMuscleGroups.insert(group)
                        } else {
                            selectedMuscleGroups.remove(group)
                            if group == .other {
                                otherMuscleGroup = ""
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var commentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comment (Optional)")
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.white)
            
            TextEditor(text: $comment)
                .font(.ubuntu(size: 16, weight: .regular))
                .foregroundColor(AppColors.white)
                .scrollContentBackground(.hidden)
                .padding(16)
                .frame(minHeight: 100)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private func saveWorkout() {
        guard !selectedMuscleGroups.isEmpty else {
            alertMessage = "Please select at least one muscle group"
            showingAlert = true
            return
        }
        
        if selectedMuscleGroups.contains(.other) && otherMuscleGroup.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Please specify the 'Other' muscle group"
            showingAlert = true
            return
        }
        
        var updatedWorkout = workout
        updatedWorkout.date = selectedDate
        updatedWorkout.muscleGroups = selectedMuscleGroups
        updatedWorkout.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedWorkout.otherMuscleGroup = otherMuscleGroup.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateWorkout(updatedWorkout)
        onSave()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleWorkout = Workout(
        date: Date(),
        muscleGroups: [.chest, .shoulders],
        comment: "Sample workout comment"
    )
    
    EditWorkoutView(workout: sampleWorkout, viewModel: WorkoutViewModel()) {
    }
}
