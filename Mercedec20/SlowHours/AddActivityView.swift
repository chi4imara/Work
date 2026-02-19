import SwiftUI

struct AddActivityView: View {
    @StateObject private var viewModel: AddActivityViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(appViewModel: AppViewModel) {
        self._viewModel = StateObject(wrappedValue: AddActivityViewModel(appViewModel: appViewModel))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        basicInfoSection
                        typeAndGoalSection
                        durationSection
                        schedulingSection
                        notesSection
                        saveButton
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(ColorTheme.primaryBlue)
            
            Text("Create New Activity")
                .font(.playfair(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Add a new leisure activity or event to your schedule")
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Activity Name")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    TextField("Enter activity name", text: $viewModel.name)
                        .font(.playfair(16))
                        .padding()
                        .background(ColorTheme.backgroundWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.name.isEmpty ? ColorTheme.lightBlue : ColorTheme.primaryBlue, lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    TextEditor(text: $viewModel.description)
                        .font(.playfair(16))
                        .frame(minHeight: 80)
                        .padding()
                        .background(ColorTheme.backgroundWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.description.isEmpty ? ColorTheme.lightBlue : ColorTheme.primaryBlue, lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var typeAndGoalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category & Goal")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Activity Type")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            TypeSelectionChip(
                                type: type,
                                isSelected: viewModel.selectedType == type
                            ) {
                                viewModel.selectedType = type
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Primary Goal")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(ActivityGoal.allCases, id: \.self) { goal in
                            GoalSelectionChip(
                                goal: goal,
                                isSelected: viewModel.selectedGoal == goal
                            ) {
                                viewModel.selectedGoal = goal
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Duration")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Duration: \(viewModel.duration) minutes")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text(durationCategory)
                        .font(.playfair(12))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(durationColor.opacity(0.2))
                        .foregroundColor(durationColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Slider(
                    value: Binding(
                        get: { Double(viewModel.duration) },
                        set: { viewModel.duration = Int($0) }
                    ),
                    in: 15...180,
                    step: 15
                ) {
                    Text("Duration")
                } minimumValueLabel: {
                    Text("15m")
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.secondaryText)
                } maximumValueLabel: {
                    Text("3h")
                        .font(.playfair(12))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .accentColor(ColorTheme.primaryBlue)
                
                HStack {
                    quickDurationButton(15, "Quick")
                    quickDurationButton(30, "Short")
                    quickDurationButton(60, "Medium")
                    quickDurationButton(120, "Long")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var schedulingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Scheduling")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 16) {
                DatePicker(
                    "Scheduled Date & Time",
                    selection: $viewModel.scheduledDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .font(.playfair(16))
                .foregroundColor(ColorTheme.primaryText)
                .accentColor(ColorTheme.primaryBlue)
                
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(ColorTheme.primaryBlue)
                    
                    Text("You can schedule this activity for later or add it immediately to your events.")
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .padding()
                .background(ColorTheme.lightBlue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Notes")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Personal notes or reminders")
                    .font(.playfair(14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                TextEditor(text: $viewModel.notes)
                    .font(.playfair(16))
                    .frame(minHeight: 100)
                    .padding()
                    .background(ColorTheme.backgroundWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.lightBlue, lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var saveButton: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.saveActivity()
                dismiss()
            } label: {
                Text("Save Activity")
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(viewModel.isValid ? ColorTheme.primaryText : ColorTheme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        viewModel.isValid ? ColorTheme.buttonGradient : LinearGradient(colors: [ColorTheme.secondaryText.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: viewModel.isValid ? ColorTheme.primaryYellow.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .disabled(!viewModel.isValid)
            
            if !viewModel.isValid {
                Text("Please fill in all required fields")
                    .font(.playfair(14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
    }
    
    private var durationCategory: String {
        switch viewModel.duration {
        case 0..<30: return "Quick"
        case 30..<60: return "Short"
        case 60..<120: return "Medium"
        default: return "Long"
        }
    }
    
    private var durationColor: Color {
        switch viewModel.duration {
        case 0..<30: return ColorTheme.accentGreen
        case 30..<60: return ColorTheme.primaryBlue
        case 60..<120: return ColorTheme.accentOrange
        default: return ColorTheme.accentPink
        }
    }
    
    private func quickDurationButton(_ minutes: Int, _ label: String) -> some View {
        Button(action: {
            viewModel.duration = minutes
        }) {
            VStack(spacing: 4) {
                Text("\(minutes)m")
                    .font(.playfair(14, weight: .semibold))
                Text(label)
                    .font(.playfair(10))
            }
            .foregroundColor(viewModel.duration == minutes ? ColorTheme.primaryText : ColorTheme.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(viewModel.duration == minutes ? ColorTheme.primaryBlue.opacity(0.2) : ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.duration == minutes ? ColorTheme.primaryBlue : ColorTheme.lightBlue, lineWidth: 1)
                    )
            )
        }
    }
}

struct TypeSelectionChip: View {
    let type: ActivityType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                
                Text(type.rawValue)
                    .font(.playfair(12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : ColorTheme.primaryText)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct GoalSelectionChip: View {
    let goal: ActivityGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "target")
                    .font(.system(size: 16))
                
                Text(goal.rawValue)
                    .font(.playfair(14, weight: .medium))
                
                Spacer()
            }
            .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.secondaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryYellow.opacity(0.3) : ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? ColorTheme.primaryYellow : ColorTheme.lightBlue, lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    AddActivityView(appViewModel: AppViewModel())
}
