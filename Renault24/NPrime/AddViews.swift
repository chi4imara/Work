import SwiftUI

private func addFormCard<Content: View>(icon: String, title: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 14) {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.accent)
                .frame(width: 32, height: 32)
                .background(Circle().fill(AppColors.accent.opacity(0.15)))
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.text)
            Spacer()
        }
        content()
    }
    .padding(18)
    .background(
        RoundedRectangle(cornerRadius: 18)
            .fill(AppColors.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
            )
    )
}

private func addFormCard<Content: View, T: View>(icon: String, title: String, @ViewBuilder trailing: () -> T, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 14) {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.accent)
                .frame(width: 32, height: 32)
                .background(Circle().fill(AppColors.accent.opacity(0.15)))
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.text)
            Spacer()
            trailing()
        }
        content()
    }
    .padding(18)
    .background(
        RoundedRectangle(cornerRadius: 18)
            .fill(AppColors.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
            )
    )
}

struct AddWorkoutView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedCategory = WorkoutCategory.strength
    @State private var duration = 30
    @State private var exercises: [Exercise] = []
    @State private var notes = ""
    @State private var showingAddExercise = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        addFormCard(icon: "dumbbell", title: "Workout") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Name")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                TextField("Enter workout name", text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                                Text("Category")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(WorkoutCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                Text("Duration")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                Stepper(value: $duration, in: 5...180, step: 5) {
                                    Text("\(duration) min")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.text)
                                }
                            }
                        }
                        
                        addFormCard(icon: "list.bullet", title: "Exercises", trailing: {
                            Button(action: { showingAddExercise = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 26))
                                    .foregroundStyle(AppColors.accentGradient)
                            }
                        }) {
                            if exercises.isEmpty {
                                Text("No exercises added")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 24)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(exercises) { exercise in
                                        ExerciseRowView(exercise: exercise) {
                                            exercises.removeAll { $0.id == exercise.id }
                                        }
                                    }
                                }
                            }
                        }
                        
                        addFormCard(icon: "note.text", title: "Notes (Optional)") {
                            TextField("Add any notes...", text: $notes, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .foregroundColor(AppColors.accent)
                    .disabled(name.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView { exercise in
                    exercises.append(exercise)
                }
            }
        }
    }
    
    private func saveWorkout() {
        let workout = Workout(
            name: name,
            category: selectedCategory,
            duration: duration,
            exercises: exercises,
            notes: notes
        )
        appState.addWorkout(workout)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    let onSave: (Exercise) -> Void
    
    @State private var name = ""
    @State private var sets = 3
    @State private var reps = 10
    @State private var weight: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    addFormCard(icon: "figure.strengthtraining.functional", title: "Exercise") {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Name")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            TextField("Enter exercise name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                            Text("Sets & Reps")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            HStack(spacing: 20) {
                                Stepper(value: $sets, in: 1...10) {
                                    Text("Sets: \(sets)")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.text)
                                }
                                Stepper(value: $reps, in: 1...100) {
                                    Text("Reps: \(reps)")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(AppColors.text)
                                }
                            }
                            Text("Weight (Optional)")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            TextField("kg", text: $weight)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let exercise = Exercise(
                            name: name,
                            sets: sets,
                            reps: reps,
                            weight: Double(weight)
                        )
                        onSave(exercise)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                    .disabled(name.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct AddMealView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedMealType = MealType.breakfast
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        addFormCard(icon: "fork.knife", title: "Meal") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Name")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                TextField("Enter meal name", text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                                Text("Meal Type")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                Picker("Meal Type", selection: $selectedMealType) {
                                    ForEach(MealType.allCases, id: \.self) { mealType in
                                        Text(mealType.rawValue).tag(mealType)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                Text("Calories")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                TextField("Enter calories", text: $calories)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        addFormCard(icon: "flame.fill", title: "Macronutrients (g)") {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Protein")
                                        .font(.ubuntu(12, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $protein)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Carbs")
                                        .font(.ubuntu(12, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $carbs)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Fat")
                                        .font(.ubuntu(12, weight: .medium))
                                        .foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $fat)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                }
                            }
                        }
                        
                        addFormCard(icon: "note.text", title: "Notes (Optional)") {
                            TextField("Add any notes...", text: $notes, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("New Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMeal()
                    }
                    .foregroundColor(AppColors.accent)
                    .disabled(name.isEmpty || calories.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveMeal() {
        let meal = Meal(
            name: name,
            mealType: selectedMealType,
            calories: Int(calories) ?? 0,
            protein: Double(protein) ?? 0,
            carbs: Double(carbs) ?? 0,
            fat: Double(fat) ?? 0,
            notes: notes
        )
        appState.addMeal(meal)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddGoalView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var targetValue = ""
    @State private var currentValue = ""
    @State private var unit = ""
    @State private var selectedCategory = GoalCategory.weightLoss
    @State private var deadline = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        addFormCard(icon: "target", title: "Goal") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Title")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                TextField("Enter goal title", text: $title)
                                    .textFieldStyle(CustomTextFieldStyle())
                                Text("Description")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                TextField("Describe your goal", text: $description, axis: .vertical)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .lineLimit(2...4)
                                Text("Category")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(GoalCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        
                        addFormCard(icon: "chart.bar.fill", title: "Progress") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Target")
                                            .font(.ubuntu(12, weight: .medium))
                                            .foregroundColor(AppColors.textSecondary)
                                        TextField("100", text: $targetValue)
                                            .textFieldStyle(CustomTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                    }
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Current")
                                            .font(.ubuntu(12, weight: .medium))
                                            .foregroundColor(AppColors.textSecondary)
                                        TextField("0", text: $currentValue)
                                            .textFieldStyle(CustomTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                    }
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Unit")
                                            .font(.ubuntu(12, weight: .medium))
                                            .foregroundColor(AppColors.textSecondary)
                                        TextField("kg", text: $unit)
                                            .textFieldStyle(CustomTextFieldStyle())
                                    }
                                }
                                Text("Deadline")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .padding(.top, 4)
                                DatePicker("", selection: $deadline, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .tint(AppColors.accent)
                            }
                        }
                        
                        addFormCard(icon: "note.text", title: "Notes (Optional)") {
                            TextField("Add any notes...", text: $notes, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGoal()
                    }
                    .foregroundColor(AppColors.accent)
                    .disabled(title.isEmpty || targetValue.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveGoal() {
        let goal = Goal(
            title: title,
            description: description,
            targetValue: Double(targetValue) ?? 0,
            currentValue: Double(currentValue) ?? 0,
            unit: unit,
            category: selectedCategory,
            deadline: deadline,
            notes: notes
        )
        appState.addGoal(goal)
        presentationMode.wrappedValue.dismiss()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(AppStyles.smallCornerRadius)
            .foregroundColor(AppColors.text)
            .font(.ubuntu(16, weight: .medium))
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text("\(exercise.sets) sets × \(exercise.reps) reps" + (exercise.weight != nil ? " @ \(Int(exercise.weight!))kg" : ""))
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(AppColors.error)
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(AppColors.cardBackground.opacity(0.3))
        .cornerRadius(AppStyles.smallCornerRadius)
    }
}
