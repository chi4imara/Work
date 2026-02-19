import SwiftUI

struct AddWorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    
    let selectedDay: DayOfWeek?
    let editingWorkout: Workout?
    
    @State private var selectedDayState: DayOfWeek = .monday
    @State private var selectedType: WorkoutType = .strength
    @State private var note: String = ""
    
    init(viewModel: WorkoutViewModel, selectedDay: DayOfWeek? = nil, editingWorkout: Workout? = nil) {
        self.viewModel = viewModel
        self.selectedDay = selectedDay
        self.editingWorkout = editingWorkout
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Day of Week")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(DayOfWeek.allCases, id: \.self) { day in
                                    Button(action: {
                                        selectedDayState = day
                                    }) {
                                        Text(day.rawValue)
                                            .font(.ubuntu(14, weight: .medium))
                                            .foregroundColor(selectedDayState == day ? ColorManager.white : ColorManager.secondaryText)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(selectedDayState == day ? AnyShapeStyle(ColorManager.lightBlue) : AnyShapeStyle(ColorManager.cardGradient))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Workout Type")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 12) {
                            ForEach(WorkoutType.allCases, id: \.self) { type in
                                Button(action: {
                                    selectedType = type
                                }) {
                                    Text(type.displayName)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(selectedType == type ? ColorManager.white : ColorManager.secondaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedType == type ? AnyShapeStyle(ColorManager.orange) : AnyShapeStyle(ColorManager.cardGradient))
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Note (Optional)")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                        
                        TextField("Add a note about your workout...", text: $note, axis: .vertical)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorManager.primaryText)
                            .padding(16)
                            .background(ColorManager.cardGradient)
                            .cornerRadius(12)
                            .lineLimit(3...6)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveWorkout) {
                        Text("Save")
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [ColorManager.lightBlue, ColorManager.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.top, 20)
            }
            .navigationTitle(editingWorkout != nil ? "Edit Workout" : "Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    private func setupInitialValues() {
        if let editingWorkout = editingWorkout {
            selectedDayState = editingWorkout.day
            selectedType = editingWorkout.type
            note = editingWorkout.note
        } else if let selectedDay = selectedDay {
            selectedDayState = selectedDay
        }
    }
    
    private func saveWorkout() {
        if let editingWorkout = editingWorkout {
            var updatedWorkout = editingWorkout
            updatedWorkout.day = selectedDayState
            updatedWorkout.type = selectedType
            updatedWorkout.note = note
            viewModel.updateWorkout(updatedWorkout)
        } else {
            let newWorkout = Workout(
                day: selectedDayState,
                type: selectedType,
                note: note
            )
            viewModel.addWorkout(newWorkout)
        }
        
        dismiss()
    }
}

#Preview {
    AddWorkoutView(viewModel: WorkoutViewModel())
}
