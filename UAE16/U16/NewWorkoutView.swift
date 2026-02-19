import SwiftUI

struct NewWorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date()
    @State private var selectedMuscleGroups: Set<MuscleGroup> = []
    @State private var comment = ""
    @State private var otherMuscleGroup = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.gray),
                trailing: Button("Save") {
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
        
        let workout = Workout(
            date: selectedDate,
            muscleGroups: selectedMuscleGroups,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            otherMuscleGroup: otherMuscleGroup.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addWorkout(workout)
        presentationMode.wrappedValue.dismiss()
    }
}

struct MuscleGroupCheckbox: View {
    let group: MuscleGroup
    let isSelected: Bool
    @Binding var otherText: String
    let onToggle: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                onToggle(!isSelected)
            }) {
                HStack(spacing: 12) {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.gray)
                    
                    Text(group.displayName)
                        .font(.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? AppColors.lightBlue : Color.clear, lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if group == .other && isSelected {
                TextField("Specify muscle group", text: $otherText)
                    .font(.ubuntu(size: 14, weight: .regular))
                    .foregroundColor(AppColors.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground.opacity(0.7))
                    )
            }
        }
    }
}

#Preview {
    NewWorkoutView(viewModel: WorkoutViewModel())
}
