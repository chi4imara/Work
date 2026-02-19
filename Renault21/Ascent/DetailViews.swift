import SwiftUI

struct WorkoutDetailView: View {
    let workoutId: UUID
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var isFavorite: Bool = false
    
    private var workout: Workout? {
        dataManager.getWorkout(withId: workoutId)
    }
    
    init(workoutId: UUID) {
        self.workoutId = workoutId
    }
    
    var body: some View {
        Group {
            if let workout = workout {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(ColorTheme.primaryAccent.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: workout.category.icon)
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryAccent)
                            }
                            
                            Text(workout.name)
                                .font(FontManager.playfairBold(size: 28))
                                .foregroundColor(ColorTheme.primaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    DetailRow(
                        icon: "tag.fill",
                        title: "Category",
                        value: workout.category.rawValue
                    )
                    
                    DetailRow(
                        icon: "clock.fill",
                        title: "Duration",
                        value: "\(workout.duration) minutes"
                    )
                    
                    if let repetitions = workout.repetitions {
                        DetailRow(
                            icon: "repeat",
                            title: "Repetitions",
                            value: "\(repetitions) reps"
                        )
                    }
                    
                    if let notes = workout.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "note.text")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryAccent)
                                
                                Text("Notes")
                                    .font(FontManager.playfairSemiBold(size: 16))
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                            
                            Text(notes)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    DetailRow(
                        icon: "calendar",
                        title: "Created",
                        value: DateFormatter.shortDate.string(from: workout.createdDate)
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .cardBackground()
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    Button(action: toggleFavorite) {
                        HStack {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                .font(FontManager.playfairSemiBold(size: 16))
                        }
                        .foregroundColor(isFavorite ? ColorTheme.error : ColorTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            (isFavorite ? ColorTheme.error : ColorTheme.primaryAccent).opacity(0.1)
                        )
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showingEditView = true }) {
                        HStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Edit Workout")
                                .font(FontManager.playfairSemiBold(size: 16))
                        }
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.accentGradient)
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Delete Workout")
                                .font(FontManager.playfairSemiBold(size: 16))
                        }
                        .foregroundColor(ColorTheme.error)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.error.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                        Spacer(minLength: 40)
                    }
                }
                .primaryBackground()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    isFavorite = workout.isFavorite
                }
            } else {
                VStack {
                    Text("Workout not found")
                        .font(FontManager.playfairMedium(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .primaryBackground()
            }
        }
        .alert("Delete Workout", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.removeWorkout(withId: workoutId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this workout? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            if let workout = workout {
                EditWorkoutView(workout: workout) { updatedWorkout in
                    dataManager.updateWorkout(updatedWorkout)
                }
            }
        }
    }
    
    private func toggleFavorite() {
        guard var workout = workout else { return }
        isFavorite.toggle()
        workout.isFavorite = isFavorite
        dataManager.updateWorkout(workout)
    }
}

struct NutritionDetailView: View {
    let nutritionId: UUID
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var isFavorite: Bool = false
    
    private var nutrition: Nutrition? {
        dataManager.getNutrition(withId: nutritionId)
    }
    
    init(nutritionId: UUID) {
        self.nutritionId = nutritionId
    }
    
    var body: some View {
        Group {
            if let nutrition = nutrition {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(ColorTheme.primaryAccent.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: nutrition.mealType.icon)
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryAccent)
                            }
                            
                            Text(nutrition.name)
                                .font(FontManager.playfairBold(size: 28))
                                .foregroundColor(ColorTheme.primaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    DetailRow(
                        icon: nutrition.mealType.icon,
                        title: "Meal Type",
                        value: nutrition.mealType.rawValue
                    )
                    
                    DetailRow(
                        icon: "flame.fill",
                        title: "Calories",
                        value: "\(nutrition.calories) cal"
                    )
                    
                    if let notes = nutrition.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "note.text")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryAccent)
                                
                                Text("Notes")
                                    .font(FontManager.playfairSemiBold(size: 16))
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                            
                            Text(notes)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    DetailRow(
                        icon: "calendar",
                        title: "Created",
                        value: DateFormatter.shortDate.string(from: nutrition.createdDate)
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .cardBackground()
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                actionButtons
                
                        Spacer(minLength: 40)
                    }
                }
                .primaryBackground()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    isFavorite = nutrition.isFavorite
                }
            } else {
                VStack {
                    Text("Nutrition item not found")
                        .font(FontManager.playfairMedium(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .primaryBackground()
            }
        }
        .alert("Delete Nutrition Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.removeNutrition(withId: nutritionId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this nutrition item? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            if let nutrition = nutrition {
                EditNutritionView(nutrition: nutrition) { updatedNutrition in
                    dataManager.updateNutrition(updatedNutrition)
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: toggleFavorite) {
                HStack {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(FontManager.playfairSemiBold(size: 16))
                }
                .foregroundColor(isFavorite ? ColorTheme.error : ColorTheme.primaryAccent)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    (isFavorite ? ColorTheme.error : ColorTheme.primaryAccent).opacity(0.1)
                )
                .cornerRadius(12)
            }
            
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Edit Item")
                        .font(FontManager.playfairSemiBold(size: 16))
                }
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.accentGradient)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Delete Item")
                        .font(FontManager.playfairSemiBold(size: 16))
                }
                .foregroundColor(ColorTheme.error)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.error.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func toggleFavorite() {
        guard var nutrition = nutrition else { return }
        isFavorite.toggle()
        nutrition.isFavorite = isFavorite
        dataManager.updateNutrition(nutrition)
    }
}

struct TaskDetailView: View {
    let taskId: UUID
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var isFavorite: Bool = false
    
    private var task: ProductivityTask? {
        dataManager.getTask(withId: taskId)
    }
    
    init(taskId: UUID) {
        self.taskId = taskId
    }
    
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .low: return ColorTheme.success
        case .medium: return ColorTheme.warning
        case .high: return ColorTheme.error
        }
    }
    
    var body: some View {
        Group {
            if let task = task {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(ColorTheme.primaryAccent.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: task.category.icon)
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryAccent)
                            }
                            
                            Text(task.name)
                                .font(FontManager.playfairBold(size: 28))
                                .foregroundColor(ColorTheme.primaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    DetailRow(
                        icon: task.category.icon,
                        title: "Category",
                        value: task.category.rawValue
                    )
                    
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(priorityColor(for: task.priority))
                            
                            Text("Priority")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(priorityColor(for: task.priority))
                                    .frame(width: 8, height: 8)
                                
                                Text(task.priority.rawValue)
                                    .font(FontManager.playfairMedium(size: 16))
                                    .foregroundColor(priorityColor(for: task.priority))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(priorityColor(for: task.priority).opacity(0.1))
                            .cornerRadius(8)
                        }
                    
                    if let notes = task.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "note.text")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryAccent)
                                
                                Text("Notes")
                                    .font(FontManager.playfairSemiBold(size: 16))
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                            
                            Text(notes)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorTheme.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    DetailRow(
                        icon: "calendar",
                        title: "Created",
                        value: DateFormatter.shortDate.string(from: task.createdDate)
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .cardBackground()
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                actionButtons
                
                        Spacer(minLength: 40)
                    }
                }
                .primaryBackground()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    isFavorite = task.isFavorite
                }
            } else {
                VStack {
                    Text("Task not found")
                        .font(FontManager.playfairMedium(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .primaryBackground()
            }
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.removeTask(withId: taskId)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this task? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            if let task = task {
                EditTaskView(task: task) { updatedTask in
                    dataManager.updateTask(updatedTask)
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: toggleFavorite) {
                HStack {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(FontManager.playfairSemiBold(size: 16))
                }
                .foregroundColor(isFavorite ? ColorTheme.error : ColorTheme.primaryAccent)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    (isFavorite ? ColorTheme.error : ColorTheme.primaryAccent).opacity(0.1)
                )
                .cornerRadius(12)
            }
            
            Button(action: { showingEditView = true }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Edit Task")
                        .font(FontManager.playfairSemiBold(size: 16))
                }
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.accentGradient)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Delete Task")
                        .font(FontManager.playfairSemiBold(size: 16))
                }
                .foregroundColor(ColorTheme.error)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.error.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func toggleFavorite() {
        guard var task = task else { return }
        isFavorite.toggle()
        task.isFavorite = isFavorite
        dataManager.updateTask(task)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 20)
            
            Text(title)
                .font(FontManager.playfairSemiBold(size: 16))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.playfairMedium(size: 16))
                .foregroundColor(ColorTheme.secondaryText)
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct EditWorkoutView: View {
    let workout: Workout
    let onSave: (Workout) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedCategory: WorkoutCategory
    @State private var duration: Int
    @State private var repetitions: String
    @State private var notes: String
    
    init(workout: Workout, onSave: @escaping (Workout) -> Void) {
        self.workout = workout
        self.onSave = onSave
        _name = State(initialValue: workout.name)
        _selectedCategory = State(initialValue: workout.category)
        _duration = State(initialValue: workout.duration)
        _repetitions = State(initialValue: workout.repetitions.map { String($0) } ?? "")
        _notes = State(initialValue: workout.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryAccent)
                        Text("Edit Workout")
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
                                        CategoryButton(category: category, isSelected: selectedCategory == category) {
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
                    Button("Cancel") { dismiss() }
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
        var updated = workout
        updated.name = name
        updated.category = selectedCategory
        updated.duration = duration
        updated.repetitions = repetitions.isEmpty ? nil : Int(repetitions)
        updated.notes = notes.isEmpty ? nil : notes
        onSave(updated)
        dismiss()
    }
}

struct EditNutritionView: View {
    let nutrition: Nutrition
    let onSave: (Nutrition) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedMealType: MealType
    @State private var calories: Int
    @State private var notes: String
    
    init(nutrition: Nutrition, onSave: @escaping (Nutrition) -> Void) {
        self.nutrition = nutrition
        self.onSave = onSave
        _name = State(initialValue: nutrition.name)
        _selectedMealType = State(initialValue: nutrition.mealType)
        _calories = State(initialValue: nutrition.calories)
        _notes = State(initialValue: nutrition.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryAccent)
                        Text("Edit Nutrition Item")
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
                                        MealTypeButton(mealType: mealType, isSelected: selectedMealType == mealType) {
                                            selectedMealType = mealType
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
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
                    Button("Cancel") { dismiss() }
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
        var updated = nutrition
        updated.name = name
        updated.mealType = selectedMealType
        updated.calories = calories
        updated.notes = notes.isEmpty ? nil : notes
        onSave(updated)
        dismiss()
    }
}

struct EditTaskView: View {
    let task: ProductivityTask
    let onSave: (ProductivityTask) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedCategory: TaskCategory
    @State private var selectedPriority: TaskPriority
    @State private var notes: String
    
    init(task: ProductivityTask, onSave: @escaping (ProductivityTask) -> Void) {
        self.task = task
        self.onSave = onSave
        _name = State(initialValue: task.name)
        _selectedCategory = State(initialValue: task.category)
        _selectedPriority = State(initialValue: task.priority)
        _notes = State(initialValue: task.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.primaryAccent)
                        Text("Edit Task")
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
                                        TaskCategoryButton(category: category, isSelected: selectedCategory == category) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Priority")
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.primaryText)
                            HStack(spacing: 12) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    PriorityButton(priority: priority, isSelected: selectedPriority == priority) {
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
                    Button("Cancel") { dismiss() }
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
        var updated = task
        updated.name = name
        updated.category = selectedCategory
        updated.priority = selectedPriority
        updated.notes = notes.isEmpty ? nil : notes
        onSave(updated)
        dismiss()
    }
}

#Preview {
    NavigationView {
        WorkoutDetailView(workoutId: UUID())
    }
}
