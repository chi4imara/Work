import SwiftUI

struct EditGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var selectedCategory: GoalCategory
    @State private var selectedFrequency: GoalFrequency
    @State private var selectedIcon: String
    @State private var description: String
    @State private var showingIconPicker = false
    
    let originalGoal: Goal
    let onSave: (Goal) -> Void
    
    init(goal: Goal, onSave: @escaping (Goal) -> Void) {
        self.originalGoal = goal
        self.onSave = onSave
        self._title = State(initialValue: goal.title)
        self._selectedCategory = State(initialValue: goal.category)
        self._selectedFrequency = State(initialValue: goal.frequency)
        self._selectedIcon = State(initialValue: goal.icon)
        self._description = State(initialValue: goal.description ?? "")
    }
    
    var isValidForm: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasChanges: Bool {
        title != originalGoal.title ||
        selectedCategory != originalGoal.category ||
        selectedFrequency != originalGoal.frequency ||
        selectedIcon != originalGoal.icon ||
        description != (originalGoal.description ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter goal title", text: $title)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(GoalCategory.allCases, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        onTap: {
                                            selectedCategory = category
                                            if selectedIcon == originalGoal.category.icon {
                                                selectedIcon = category.icon
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Icon")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                                
                                Button("Choose Icon") {
                                    showingIconPicker = true
                                }
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.secondary)
                            }
                            
                            HStack {
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.secondary)
                                    .frame(width: 40, height: 40)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(8)
                                
                                Text("Selected icon")
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Frequency")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            HStack(spacing: 12) {
                                ForEach(GoalFrequency.allCases, id: \.self) { frequency in
                                    FrequencyButton(
                                        frequency: frequency,
                                        isSelected: selectedFrequency == frequency,
                                        onTap: {
                                            selectedFrequency = frequency
                                        }
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Add a personal note...", text: $description, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                                )
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .foregroundColor(isValidForm && hasChanges ? AppColors.secondary : AppColors.textSecondary)
                    .disabled(!isValidForm || !hasChanges)
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingIconPicker) {
            IconPickerView(selectedIcon: $selectedIcon)
        }
    }
    
    private func saveChanges() {
        var updatedGoal = originalGoal
        updatedGoal.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedGoal.category = selectedCategory
        updatedGoal.frequency = selectedFrequency
        updatedGoal.icon = selectedIcon
        updatedGoal.description = description.isEmpty ? nil : description
        
        onSave(updatedGoal)
        dismiss()
    }
}

#Preview {
    EditGoalView(
        goal: Goal(title: "Morning walk", category: .body, frequency: .daily, description: "Take a refreshing morning walk"),
        onSave: { _ in }
    )
}
