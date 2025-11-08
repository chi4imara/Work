import SwiftUI

struct TaskDetailView: View {
    let task: Task
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var localTask: Task
    @State private var showingArchiveConfirmation = false
    @State private var showingEditView = false
    
    init(task: Task, taskViewModel: TaskViewModel) {
        self.task = task
        self.taskViewModel = taskViewModel
        self._localTask = State(initialValue: task)
    }
    
    private func updateLocalTask() {
        if let updatedTask = taskViewModel.tasks.first(where: { $0.id == task.id }) {
            localTask = updatedTask
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        headerSection
                        
                        if !localTask.requiredItems.isEmpty {
                            requiredItemsSection
                        }
                        
                        if !localTask.steps.isEmpty {
                            stepsSection
                        }
                        
                        notesSection
                        
                        actionButtonsSection
                    }
                    .padding(DesignConstants.largePadding)
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.lightText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            taskViewModel.toggleTaskFavorite(localTask)
                            updateLocalTask()
                        }
                    }) {
                        Image(systemName: localTask.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(localTask.isFavorite ? ColorScheme.accent : ColorScheme.lightText)
                    }
                }
            }
        }
        .alert("Archive Task", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                taskViewModel.archiveTask(localTask)
                dismiss()
            }
        } message: {
            Text("This task will be moved to the archive.")
        }
        .sheet(isPresented: $showingEditView) {
            EditTaskView(task: localTask, taskViewModel: taskViewModel) { updatedTask in
                taskViewModel.updateTask(updatedTask)
                updateLocalTask()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            HStack {
                Image(systemName: localTask.type.icon)
                    .font(.title)
                    .foregroundColor(colorForTaskType(localTask.type))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(localTask.plantName)
                        .font(FontManager.headline)
                        .fontWeight(.bold)
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(localTask.type.rawValue)
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                }
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Scheduled for")
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.lightText.opacity(0.7))
                    
                    Text(localTask.date, style: .date)
                        .font(FontManager.body)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.lightText)
                    
                    if let time = localTask.time {
                        Text(time, style: .time)
                            .font(FontManager.body)
                            .foregroundColor(ColorScheme.accent)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        taskViewModel.toggleTaskCompletion(localTask)
                        updateLocalTask()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: localTask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundColor(localTask.isCompleted ? ColorScheme.success : Color.white)
                        
                        Text(localTask.isCompleted ? "Completed" : "Mark Done")
                            .font(FontManager.caption)
                            .foregroundColor(localTask.isCompleted ? ColorScheme.success : Color.white)
                    }
                }
            }
            
            if !localTask.description.isEmpty {
                HStack {
                    Text(localTask.description)
                        .font(FontManager.body)
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var requiredItemsSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            Text("What You'll Need")
                .font(FontManager.headline)
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.lightText)
            
            ForEach(Array(localTask.requiredItems.enumerated()), id: \.offset) { index, item in
                HStack(spacing: DesignConstants.mediumPadding) {
                    Button(action: {
                    }) {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundColor(ColorScheme.mediumGray)
                    }
                    
                    Text(item)
                        .font(FontManager.body)
                        .foregroundColor(ColorScheme.lightText)
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            Text("Step-by-Step Guide")
                .font(FontManager.headline)
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.lightText)
            
            ForEach(Array(localTask.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: DesignConstants.mediumPadding) {
                    Button(action: {
                        var updatedTask = localTask
                        updatedTask.steps[index].isCompleted.toggle()
                        taskViewModel.updateTask(updatedTask)
                        updateLocalTask()
                    }) {
                        Image(systemName: step.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(step.isCompleted ? ColorScheme.success : ColorScheme.mediumGray)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Step \(index + 1)")
                            .font(FontManager.caption)
                            .foregroundColor(ColorScheme.lightText.opacity(0.7))
                        
                        Text(step.title)
                            .font(FontManager.body)
                            .fontWeight(.semibold)
                            .foregroundColor(step.isCompleted ? ColorScheme.mediumGray : ColorScheme.lightText)
                            .strikethrough(step.isCompleted)
                        
                        if !step.description.isEmpty {
                            Text(step.description)
                                .font(FontManager.caption)
                                .foregroundColor(ColorScheme.lightText.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            
            if localTask.steps.allSatisfy({ $0.isCompleted }) && !localTask.steps.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ColorScheme.success)
                    
                    Text("Task completed!")
                        .font(FontManager.body)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.success)
                }
                .padding(.top, DesignConstants.smallPadding)
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            Text("Notes")
                .font(FontManager.headline)
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.lightText)
            
            Text("Add your observations and notes about this task...")
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText.opacity(0.6))
                .italic()
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            HStack(spacing: DesignConstants.mediumPadding) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        taskViewModel.toggleTaskFavorite(localTask)
                        updateLocalTask()
                    }
                }) {
                    HStack {
                        Image(systemName: localTask.isFavorite ? "heart.fill" : "heart")
                        Text(localTask.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .font(Font.custom("Poppins-Medium", size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(localTask.isFavorite ? ColorScheme.error : ColorScheme.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignConstants.mediumPadding)
                    .background(
                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                            .stroke(localTask.isFavorite ? ColorScheme.error : ColorScheme.accent, lineWidth: 1)
                    )
                }
                
                Button(action: {
                    showingArchiveConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "archivebox")
                        Text("Move to Archive")
                    }
                    .font(Font.custom("Poppins-Medium", size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(ColorScheme.error)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignConstants.mediumPadding)
                    .background(
                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                            .stroke(ColorScheme.error, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.lightBlue
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.lightBlue
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
}

struct EditTaskView: View {
    let task: Task
    @ObservedObject var taskViewModel: TaskViewModel
    let onUpdate: (Task) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var editedTask: Task
    
    init(task: Task, taskViewModel: TaskViewModel, onUpdate: @escaping (Task) -> Void) {
        self.task = task
        self.taskViewModel = taskViewModel
        self.onUpdate = onUpdate
        self._editedTask = State(initialValue: task)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                Text("Edit Task View")
                    .font(FontManager.headline)
                    .foregroundColor(ColorScheme.lightText)
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.lightText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        taskViewModel.updateTask(editedTask)
                        onUpdate(editedTask)
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.accent)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct PlantDetailView: View {
    let plant: Plant
    @ObservedObject var plantViewModel: PlantViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var localPlant: Plant
    
    init(plant: Plant, plantViewModel: PlantViewModel, taskViewModel: TaskViewModel) {
        self.plant = plant
        self.plantViewModel = plantViewModel
        self.taskViewModel = taskViewModel
        self._localPlant = State(initialValue: plant)
    }
    
    private func updateLocalPlant() {
        if let updatedPlant = plantViewModel.plants.first(where: { $0.id == plant.id }) {
            localPlant = updatedPlant
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        VStack(spacing: DesignConstants.mediumPadding) {
                            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                .fill(ColorScheme.accent.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(ColorScheme.accent)
                                )
                            
                            Text(localPlant.name)
                                .font(FontManager.title)
                                .fontWeight(.bold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            Text(localPlant.category.displayName)
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorScheme.lightText.opacity(0.8))
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
                            Text("Care Schedule")
                                .font(FontManager.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            CareScheduleRow(title: "Watering", frequency: localPlant.careSchedule.wateringFrequency, icon: "drop.fill")
                            CareScheduleRow(title: "Fertilizing", frequency: localPlant.careSchedule.fertilizingFrequency, icon: "leaf.fill")
                            CareScheduleRow(title: "Repotting", frequency: localPlant.careSchedule.repottingFrequency, icon: "leaf.circle.fill")
                            CareScheduleRow(title: "Cleaning", frequency: localPlant.careSchedule.cleaningFrequency, icon: "sparkles")
                        }
                        .padding(DesignConstants.mediumPadding)
                        .background(
                            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                .fill(ColorScheme.cardGradient.opacity(0.3))
                        )
                        
                        if !localPlant.notes.isEmpty {
                            HStack {
                                VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
                                    Text("Notes")
                                        .font(FontManager.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(ColorScheme.lightText)
                                    
                                    Text(localPlant.notes)
                                        .font(FontManager.body)
                                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                                }
                                Spacer()
                            }
                            .padding(DesignConstants.mediumPadding)
                            .background(
                                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                    .fill(ColorScheme.cardGradient.opacity(0.3))
                            )
                        }
                        
                        VStack(spacing: DesignConstants.mediumPadding) {
                            HStack(spacing: DesignConstants.mediumPadding) {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        plantViewModel.toggleFavorite(localPlant)
                                        updateLocalPlant()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: localPlant.isFavorite ? "heart.fill" : "heart")
                                        Text(localPlant.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                    }
                                    .font(Font.custom("Poppins-Medium", size: 13))
                                    .fontWeight(.semibold)
                                    .foregroundColor(localPlant.isFavorite ? ColorScheme.error : ColorScheme.accent)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, DesignConstants.mediumPadding)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                            .stroke(localPlant.isFavorite ? ColorScheme.error : ColorScheme.accent, lineWidth: 1)
                                    )
                                }
                                
                                Button(action: {
                                    plantViewModel.deletePlant(plant)
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "archivebox")
                                        Text("Move to Archive")
                                    }
                                    .font(Font.custom("Poppins-Medium", size: 13))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ColorScheme.error)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, DesignConstants.mediumPadding)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                            .stroke(ColorScheme.error, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    .padding(DesignConstants.largePadding)
                }
            }
            .navigationTitle("Plant Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.lightText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            plantViewModel.toggleFavorite(localPlant)
                            updateLocalPlant()
                        }
                    }) {
                        Image(systemName: localPlant.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(localPlant.isFavorite ? ColorScheme.accent : ColorScheme.lightText)
                    }
                }
            }
        }
    }
}

struct CareScheduleRow: View {
    let title: String
    let frequency: Int
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(ColorScheme.accent)
                .frame(width: 24)
            
            Text(title)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText)
            
            Spacer()
            
            Text("Every \(frequency) days")
                .font(FontManager.caption)
                .foregroundColor(ColorScheme.lightText.opacity(0.7))
        }
    }
}

#Preview {
    TaskDetailView(
        task: Task(
            plantId: UUID(),
            plantName: "Monstera Deliciosa",
            type: .watering,
            date: Date(),
            description: "Water thoroughly until it drains"
        ),
        taskViewModel: TaskViewModel()
    )
}

