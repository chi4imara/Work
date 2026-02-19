import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedMealType: MealType = .breakfast
    @State private var selectedGoal: MoodGoal = .energy
    @State private var calories = ""
    @State private var descriptionText = ""
    @State private var ingredientsText = ""

    let onSave: (Food) -> Void

    private var isValid: Bool {
        !name.isEmpty && !calories.isEmpty && Int(calories) != nil
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.primaryBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        inputSection(title: "Meal Name") {
                            TextField("Enter meal name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        inputSection(title: "Meal Type") {
                            Picker("Meal Type", selection: $selectedMealType) {
                                ForEach(MealType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorScheme(.dark)
                        }

                        inputSection(title: "Goal") {
                            Picker("Goal", selection: $selectedGoal) {
                                ForEach(MoodGoal.allCases) { goal in
                                    Text(goal.rawValue).tag(goal)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .colorScheme(.dark)
                        }

                        inputSection(title: "Calories") {
                            TextField("Enter calories", text: $calories)
                                .keyboardType(.numberPad)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        inputSection(title: "Description (optional)") {
                            TextField("Short description", text: $descriptionText)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        inputSection(title: "Ingredients (optional, comma-separated)") {
                            TextField("e.g. Banana, Oats, Honey", text: $ingredientsText)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        Button(action: saveFood) {
                            Text("Add to Recommendations")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.medium)
                                        .fill(isValid ? AppColors.accentYellow : AppColors.cardBackground)
                                )
                        }
                        .disabled(!isValid)
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Add Meal Suggestion")
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

    private func saveFood() {
        guard isValid, let calorieCount = Int(calories) else { return }

        let ingredients = ingredientsText
            .split(separator: ",")
            .map { String($0.trimmingCharacters(in: .whitespaces)) }
            .filter { !$0.isEmpty }

        let food = Food(
            name: name,
            type: selectedMealType,
            calories: calorieCount,
            goal: selectedGoal,
            description: descriptionText.isEmpty ? "Custom meal" : descriptionText,
            ingredients: ingredients
        )

        onSave(food)
        dismiss()
    }
}

#Preview {
    AddFoodView { _ in }
}
