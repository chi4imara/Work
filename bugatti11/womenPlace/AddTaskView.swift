import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle = ""
    @State private var isHabit = false
    @State private var selectedIcon = "circle"
    @State private var selectedTime: Date?
    @State private var hasTime = false
    @State private var repeatDaily = false
    
    let onSave: (TaskG) -> Void
    
    private let availableIcons = [
        "circle", "star", "heart", "leaf", "drop", "flame",
        "book", "pencil", "phone", "envelope", "house", "car",
        "cart", "bag", "creditcard", "gift", "gamecontroller", "music.note"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackgroundView()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Task Name")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter task name", text: $taskTitle)
                                .font(AppFonts.playfairRegular(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(15)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Task Type")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 20) {
                                TaskTypeButton(
                                    title: "One-time Task",
                                    icon: "checkmark.circle",
                                    isSelected: !isHabit
                                ) {
                                    isHabit = false
                                    repeatDaily = false
                                }
                                
                                TaskTypeButton(
                                    title: "Daily Habit",
                                    icon: "repeat.circle",
                                    isSelected: isHabit
                                ) {
                                    isHabit = true
                                    repeatDaily = true
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Choose Icon")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 15) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedIcon == icon ? AppColors.primaryBlue : AppColors.primaryText)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selectedIcon == icon ? AppColors.accentYellow : Color.white.opacity(0.1))
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Set Time")
                                    .font(AppFonts.playfairMedium(size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: $hasTime)
                                    .toggleStyle(SwitchToggleStyle(tint: AppColors.accentYellow))
                            }
                            
                            if hasTime {
                                DatePicker(
                                    "Time",
                                    selection: Binding(
                                        get: { selectedTime ?? Date() },
                                        set: { selectedTime = $0 }
                                    ),
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(WheelDatePickerStyle())
                                .colorScheme(.dark)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                )
                            }
                        }
                        
                        if !isHabit {
                            HStack {
                                Text("Repeat Daily")
                                    .font(AppFonts.playfairMedium(size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: $repeatDaily)
                                    .toggleStyle(SwitchToggleStyle(tint: AppColors.accentYellow))
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(taskTitle.isEmpty ? AppColors.secondaryText : AppColors.accentYellow)
                    .disabled(taskTitle.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task = TaskG(
            title: taskTitle,
            isHabit: isHabit,
            icon: selectedIcon,
            time: hasTime ? selectedTime : nil,
            repeatDaily: repeatDaily
        )
        
        onSave(task)
        dismiss()
    }
}

struct TaskTypeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                
                Text(title)
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.accentYellow : Color.white.opacity(0.1))
            )
        }
    }
}
