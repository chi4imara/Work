import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var workoutName = ""
    @State private var selectedType: WorkoutType = .cardio
    @State private var selectedGoal: FitnessGoal = .weightLoss
    @State private var selectedLevel: FitnessLevel = .beginner
    @State private var duration = 30
    @State private var notes = ""
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    
                    Spacer()
                    
                    Text("Add Workout")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveWorkout()
                    }
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.primaryYellow)
                    .disabled(workoutName.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        AddWorkoutSection(title: "Basic Information") {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Workout Name")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    TextField("Enter workout name", text: $workoutName)
                                        .font(.ubuntu(16, weight: .regular))
                                        .foregroundColor(ColorTheme.textPrimary)
                                        .padding(12)
                                        .background(ColorTheme.cardBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(ColorTheme.cardBorder, lineWidth: 1)
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Workout Type")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                        ForEach(WorkoutType.allCases, id: \.self) { type in
                                            SelectionButton(
                                                title: type.rawValue,
                                                isSelected: selectedType == type
                                            ) {
                                                selectedType = type
                                            }
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Duration")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    HStack {
                                        Text("\(duration) minutes")
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(ColorTheme.textPrimary)
                                        
                                        Spacer()
                                    }
                                    
                                    Slider(
                                        value: Binding(
                                            get: { Double(duration) },
                                            set: { duration = Int($0) }
                                        ),
                                        in: 15...120,
                                        step: 15
                                    )
                                    .accentColor(ColorTheme.primaryYellow)
                                    
                                    HStack {
                                        Text("15 min")
                                            .font(.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.textSecondary)
                                        
                                        Spacer()
                                        
                                        Text("120 min")
                                            .font(.ubuntu(12, weight: .regular))
                                            .foregroundColor(ColorTheme.textSecondary)
                                    }
                                }
                            }
                        }
                        
                        AddWorkoutSection(title: "Goals & Level") {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Fitness Goal")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                        ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                            SelectionButton(
                                                title: goal.rawValue,
                                                isSelected: selectedGoal == goal
                                            ) {
                                                selectedGoal = goal
                                            }
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Difficulty Level")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                        ForEach(FitnessLevel.allCases, id: \.self) { level in
                                            SelectionButton(
                                                title: level.rawValue,
                                                isSelected: selectedLevel == level
                                            ) {
                                                selectedLevel = level
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        AddWorkoutSection(title: "Additional Notes") {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes (Optional)")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(ColorTheme.textPrimary)
                                
                                TextEditor(text: $notes)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(ColorTheme.textPrimary)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 80)
                                    .padding(8)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private func saveWorkout() {
        let workout = Workout(
            name: workoutName,
            type: selectedType,
            duration: duration,
            difficulty: selectedLevel,
            goal: selectedGoal,
            imageName: getIconForType(selectedType),
            description: notes.isEmpty ? "Custom workout" : notes
        )
        
        workoutsVM.addWorkoutTemplate(workout)
        dismiss()
    }
    
    private func getIconForType(_ type: WorkoutType) -> String {
        switch type {
        case .cardio:
            return "heart.fill"
        case .strength:
            return "dumbbell.fill"
        case .yoga:
            return "figure.yoga"
        case .pilates:
            return "figure.pilates"
        }
    }
}

struct AddWorkoutSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.primaryBlue : ColorTheme.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? ColorTheme.primaryYellow : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isSelected ? ColorTheme.primaryYellow : ColorTheme.cardBorder,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
