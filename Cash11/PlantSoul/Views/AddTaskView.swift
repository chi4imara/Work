import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPlantId: UUID?
    @State private var selectedPlantName = ""
    @State private var selectedTaskType = TaskType.watering
    @State private var selectedDate = Date()
    @State private var selectedTime: Date?
    @State private var description = ""
    @State private var requiredItems: [String] = []
    @State private var newItem = ""
    @State private var isFavorite = false
    @State private var includeTime = false
    
    private let samplePlants = [
        (id: UUID(), name: "Monstera Deliciosa"),
        (id: UUID(), name: "Snake Plant"),
        (id: UUID(), name: "Rose Bush"),
        (id: UUID(), name: "Water Lily")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Plant")
                                .font(FontManager.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            Menu {
                                ForEach(samplePlants, id: \.id) { plant in
                                    Button(plant.name) {
                                        selectedPlantId = plant.id
                                        selectedPlantName = plant.name
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedPlantName.isEmpty ? "Choose a plant" : selectedPlantName)
                                        .font(FontManager.body)
                                        .foregroundColor(selectedPlantName.isEmpty ? ColorScheme.mediumGray : ColorScheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(ColorScheme.mediumGray)
                                }
                                .padding(DesignConstants.mediumPadding)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                        .fill(ColorScheme.cardGradient)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Type")
                                .font(FontManager.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(TaskType.allCases, id: \.self) { taskType in
                                    TaskTypeButton(
                                        taskType: taskType,
                                        isSelected: selectedTaskType == taskType
                                    ) {
                                        selectedTaskType = taskType
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
                            Text("Schedule")
                                .font(FontManager.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .accentColor(ColorScheme.accent)
                            
                            Toggle(isOn: $includeTime) {
                                Text("Include specific time")
                                    .font(FontManager.body)
                                    .foregroundColor(ColorScheme.lightText)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: ColorScheme.accent))
                            
                            if includeTime {
                                DatePicker("Time", selection: Binding(
                                    get: { selectedTime ?? Date() },
                                    set: { selectedTime = $0 }
                                ), displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .accentColor(ColorScheme.accent)
                            }
                        }
                        .padding(DesignConstants.mediumPadding)
                        .background(
                            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                .fill(ColorScheme.cardGradient.opacity(0.5))
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(FontManager.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            TextField("", text: $description, axis: .vertical)
                                .font(FontManager.body)
                                .overlay(
                                    HStack {
                                        Text("Add task description...")
                                            .font(FontManager.body)
                                            .foregroundColor(.gray)
                                            .opacity(description.isEmpty ? 1 : 0)
                                            .allowsTightening(false)
                                        
                                        Spacer()
                                    }
                                )
                                .lineLimit(2...4)
                                .padding(DesignConstants.mediumPadding)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                        .fill(ColorScheme.cardGradient)
                                )
                            
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
                            Text("Required Items")
                                .font(FontManager.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorScheme.lightText)
                            
                            HStack {
                                TextField("", text: $newItem)
                                    .font(FontManager.body)
                                    .overlay(
                                        HStack {
                                            Text("Add item...")
                                                .font(FontManager.body)
                                                .foregroundColor(.gray)
                                                .opacity(newItem.isEmpty ? 1 : 0)
                                                .allowsTightening(false)
                                            
                                            Spacer()
                                            
                                        }
                                    )
                                
                                Button("Add") {
                                    if !newItem.isEmpty {
                                        requiredItems.append(newItem)
                                        newItem = ""
                                    }
                                }
                                .foregroundColor(ColorScheme.accent)
                                .fontWeight(.semibold)
                                .disabled(newItem.isEmpty)
                            }
                            .padding(DesignConstants.mediumPadding)
                            .background(
                                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                    .fill(ColorScheme.cardGradient)
                            )
                            
                            ForEach(Array(requiredItems.enumerated()), id: \.offset) { index, item in
                                HStack {
                                    Text(item)
                                        .font(FontManager.body)
                                        .foregroundColor(ColorScheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        requiredItems.remove(at: index)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(ColorScheme.error)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .padding(DesignConstants.mediumPadding)
                        .background(
                            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                .fill(ColorScheme.cardGradient.opacity(0.5))
                        )
                        
                        Toggle(isOn: $isFavorite) {
                            Text("Add to Favorites")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorScheme.lightText)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: ColorScheme.accent))
                    }
                    .padding(DesignConstants.largePadding)
                }
            }
            .navigationTitle("Add Task")
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
                        saveTask()
                    }
                    .foregroundColor(ColorScheme.accent)
                    .fontWeight(.semibold)
                    .disabled(selectedPlantId == nil || selectedPlantName.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        guard let plantId = selectedPlantId else { return }
        
        let task = Task(
            plantId: plantId,
            plantName: selectedPlantName,
            type: selectedTaskType,
            date: selectedDate,
            time: includeTime ? selectedTime : nil,
            description: description,
            requiredItems: requiredItems
        )
        
        taskViewModel.addTask(task)
        dismiss()
    }
}

struct TaskTypeButton: View {
    let taskType: TaskType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: taskType.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? ColorScheme.white : colorForTaskType(taskType))
                
                Text(taskType.rawValue)
                    .font(FontManager.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? ColorScheme.white : ColorScheme.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .fill(isSelected ? AnyShapeStyle(colorForTaskType(taskType)) : AnyShapeStyle(ColorScheme.cardGradient))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                            .stroke(colorForTaskType(taskType), lineWidth: isSelected ? 0 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.softGreen
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.warmYellow
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
}

#Preview {
    AddTaskView(taskViewModel: TaskViewModel())
}

