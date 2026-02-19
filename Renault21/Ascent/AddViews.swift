import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedCategory = WorkoutCategory.cardio
    @State private var duration = 30
    @State private var repetitions = ""
    @State private var notes = ""
    
    let onSave: (Workout) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryAccent)
                        
                        Text("Add New Workout")
                            .font(FontManager.playfairBold(size: 24))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        FormField(title: "Workout Name", text: $name, placeholder: "e.g., Morning Run")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(WorkoutCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Duration (minutes)")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack {
                                Stepper(value: $duration, in: 5...180, step: 5) {
                                    Text("\(duration) minutes")
                                        .font(FontManager.playfairMedium(size: 16))
                                        .foregroundColor(ColorTheme.primaryText)
                                }
                                .accentColor(ColorTheme.primaryAccent)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .cardBackground()
                            .cornerRadius(12)
                        }
                        
                        FormField(title: "Repetitions (Optional)", text: $repetitions, placeholder: "e.g., 20", keyboardType: .numberPad)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notes (Optional)")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextEditor(text: $notes)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 80)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .cardBackground()
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
            }
            .primaryBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryAccent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .foregroundColor(ColorTheme.primaryAccent)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveWorkout() {
        let workout = Workout(
            name: name,
            category: selectedCategory,
            duration: duration,
            repetitions: repetitions.isEmpty ? nil : Int(repetitions),
            notes: notes.isEmpty ? nil : notes
        )
        onSave(workout)
        dismiss()
    }
}

struct AddNutritionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedMealType = MealType.breakfast
    @State private var calories = 200
    @State private var notes = ""
    
    let onSave: (Nutrition) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryAccent)
                        
                        Text("Add Nutrition Item")
                            .font(FontManager.playfairBold(size: 24))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        FormField(title: "Food/Meal Name", text: $name, placeholder: "e.g., Greek Yogurt")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Meal Type")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(MealType.allCases, id: \.self) { mealType in
                                        MealTypeButton(
                                            mealType: mealType,
                                            isSelected: selectedMealType == mealType
                                        ) {
                                            selectedMealType = mealType
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Calories")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack {
                                Stepper(value: $calories, in: 10...2000, step: 10) {
                                    Text("\(calories) calories")
                                        .font(FontManager.playfairMedium(size: 16))
                                        .foregroundColor(ColorTheme.primaryText)
                                }
                                .accentColor(ColorTheme.primaryAccent)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .cardBackground()
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notes (Optional)")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextEditor(text: $notes)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 80)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .cardBackground()
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
            }
            .primaryBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryAccent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNutrition()
                    }
                    .foregroundColor(ColorTheme.primaryAccent)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveNutrition() {
        let nutrition = Nutrition(
            name: name,
            mealType: selectedMealType,
            calories: calories,
            notes: notes.isEmpty ? nil : notes
        )
        onSave(nutrition)
        dismiss()
    }
}

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedCategory = TaskCategory.work
    @State private var selectedPriority = TaskPriority.medium
    @State private var notes = ""
    
    let onSave: (ProductivityTask) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryAccent)
                        
                        Text("Add New Task")
                            .font(FontManager.playfairBold(size: 24))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        FormField(title: "Task Name", text: $name, placeholder: "e.g., Review project proposal")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(TaskCategory.allCases, id: \.self) { category in
                                        TaskCategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Priority")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    PriorityButton(
                                        priority: priority,
                                        isSelected: selectedPriority == priority
                                    ) {
                                        selectedPriority = priority
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notes (Optional)")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextEditor(text: $notes)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 80)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .cardBackground()
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
            }
            .primaryBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryAccent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(ColorTheme.primaryAccent)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task = ProductivityTask(
            name: name,
            category: selectedCategory,
            priority: selectedPriority,
            notes: notes.isEmpty ? nil : notes
        )
        onSave(task)
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(FontManager.playfairSemiBold(size: 16))
                .foregroundColor(ColorTheme.primaryText)
            
            TextField(placeholder, text: $text)
                .font(FontManager.playfairRegular(size: 16))
                .foregroundColor(ColorTheme.primaryText)
                .keyboardType(keyboardType)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .cardBackground()
                .cornerRadius(12)
        }
    }
}

struct CategoryButton: View {
    let category: WorkoutCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(category.rawValue)
                    .font(FontManager.playfairMedium(size: 14))
            }
            .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryAccent)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? ColorTheme.primaryAccent : ColorTheme.primaryAccent.opacity(0.1))
            .cornerRadius(20)
        }
    }
}

struct MealTypeButton: View {
    let mealType: MealType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: mealType.icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(mealType.rawValue)
                    .font(FontManager.playfairMedium(size: 14))
            }
            .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryAccent)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? ColorTheme.primaryAccent : ColorTheme.primaryAccent.opacity(0.1))
            .cornerRadius(20)
        }
    }
}

struct TaskCategoryButton: View {
    let category: TaskCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(category.rawValue)
                    .font(FontManager.playfairMedium(size: 14))
            }
            .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryAccent)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? ColorTheme.primaryAccent : ColorTheme.primaryAccent.opacity(0.1))
            .cornerRadius(20)
        }
    }
}

struct PriorityButton: View {
    let priority: TaskPriority
    let isSelected: Bool
    let action: () -> Void
    
    var priorityColor: Color {
        switch priority {
        case .low: return ColorTheme.success
        case .medium: return ColorTheme.warning
        case .high: return ColorTheme.error
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(priority.rawValue)
                .font(FontManager.playfairMedium(size: 14))
                .foregroundColor(isSelected ? ColorTheme.primaryText : priorityColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? priorityColor : priorityColor.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

#Preview {
    AddWorkoutView { _ in }
}
