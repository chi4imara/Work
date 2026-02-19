import SwiftUI

struct FilterView: View {
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    Text("Filters")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                    
                    Button("Apply") {
                        workoutsVM.applyFilters()
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(ColorTheme.primaryYellow)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Fitness Goal") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                    FilterButton(
                                        title: goal.rawValue,
                                        isSelected: workoutsVM.selectedGoal == goal
                                    ) {
                                        workoutsVM.selectedGoal = workoutsVM.selectedGoal == goal ? nil : goal
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Fitness Level") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(FitnessLevel.allCases, id: \.self) { level in
                                    FilterButton(
                                        title: level.rawValue,
                                        isSelected: workoutsVM.selectedLevel == level
                                    ) {
                                        workoutsVM.selectedLevel = workoutsVM.selectedLevel == level ? nil : level
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Workout Type") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(WorkoutType.allCases, id: \.self) { type in
                                    FilterButton(
                                        title: type.rawValue,
                                        isSelected: workoutsVM.selectedType == type
                                    ) {
                                        workoutsVM.selectedType = workoutsVM.selectedType == type ? nil : type
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Max Duration") {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Up to \(workoutsVM.selectedDuration ?? 60) minutes")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    Spacer()
                                    
                                    if workoutsVM.selectedDuration != nil {
                                        Button("Clear") {
                                            workoutsVM.selectedDuration = nil
                                        }
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.primaryYellow)
                                    }
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { Double(workoutsVM.selectedDuration ?? 60) },
                                        set: { workoutsVM.selectedDuration = Int($0) }
                                    ),
                                    in: 15...90,
                                    step: 15
                                )
                                .accentColor(ColorTheme.primaryYellow)
                                
                                HStack {
                                    Text("15 min")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text("90 min")
                                        .font(.ubuntu(12, weight: .regular))
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                            }
                        }
                        
                        Button("Clear All Filters") {
                            workoutsVM.clearFilters()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct FilterSection<Content: View>: View {
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
    }
}

struct FilterButton: View {
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
