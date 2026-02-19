import SwiftUI

struct AddMealView: View {
    @StateObject private var viewModel = AddMealViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let onSave: ((MealEntry) -> Void)?
    
    init(onSave: ((MealEntry) -> Void)? = nil) {
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        inputSection(title: "Meal Name") {
                            TextField("Enter meal name", text: $viewModel.mealName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        inputSection(title: "Meal Type") {
                            Picker("Meal Type", selection: $viewModel.selectedMealType) {
                                ForEach(MealType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorScheme(.dark)
                        }
                        
                        inputSection(title: "Goal") {
                            Picker("Goal", selection: $viewModel.selectedGoal) {
                                ForEach(MoodGoal.allCases) { goal in
                                    Text(goal.rawValue).tag(goal)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorScheme(.dark)
                        }
                        
                        inputSection(title: "Calories") {
                            TextField("Enter calories", text: $viewModel.calories)
                                .keyboardType(.numberPad)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        inputSection(title: "Date & Time") {
                            VStack(spacing: AppSpacing.md) {
                                DatePicker("Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .accentColor(AppColors.accentYellow)
                                    .colorScheme(.dark)
                                
                                DatePicker("Time", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .accentColor(AppColors.accentYellow)
                                    .colorScheme(.dark)
                            }
                        }
                        
                        Button(action: saveMeal) {
                            Text("Save Meal")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.medium)
                                        .fill(viewModel.isValid ? AppColors.accentYellow : AppColors.cardBackground)
                                )
                        }
                        .disabled(!viewModel.isValid)
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
    
    private func inputSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            content()
        }
    }
    
    private func saveMeal() {
        guard let mealEntry = viewModel.createMealEntry() else { return }
        
        onSave?(mealEntry)
        viewModel.reset()
        dismiss()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryText)
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.medium)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.medium)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
    }
}

#Preview {
    AddMealView()
}
