import SwiftUI

struct TaskFormView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    let task: GardenTask?
    
    @State private var selectedCulture: Culture?
    @State private var customCultureName: String = ""
    @State private var selectedWorkType: WorkType = .watering
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var hasTime: Bool = false
    @State private var selectedFrequency: Frequency = .once
    @State private var selectedWeekDay: Int = 1
    @State private var note: String = ""
    @State private var showingCustomCultureInput: Bool = false
    @State private var showingDeleteConfirmation: Bool = false
    @State private var showingDiscardChanges: Bool = false
    @State private var hasUnsavedChanges: Bool = false
    
    private var isEditing: Bool {
        task != nil
    }
    
    private var canSave: Bool {
        let hasCulture = selectedCulture != nil || (!customCultureName.isEmpty && showingCustomCultureInput)
        let hasValidWeekDay = selectedFrequency != .weekly || selectedWeekDay > 0
        return hasCulture && hasValidWeekDay
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        cultureSection
                        
                        workTypeSection
                        
                        dateTimeSection
                        
                        frequencySection
                        
                        noteSection
                        
                        if isEditing {
                            deleteButton
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasUnsavedChanges {
                            showingDiscardChanges = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(.appPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(canSave ? .appPrimary : .appMediumGray)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .onChange(of: selectedCulture) { _ in hasUnsavedChanges = true }
        .onChange(of: customCultureName) { _ in hasUnsavedChanges = true }
        .onChange(of: selectedWorkType) { _ in hasUnsavedChanges = true }
        .onChange(of: selectedDate) { _ in hasUnsavedChanges = true }
        .onChange(of: selectedTime) { _ in hasUnsavedChanges = true }
        .onChange(of: hasTime) { _ in hasUnsavedChanges = true }
        .onChange(of: selectedFrequency) { _ in hasUnsavedChanges = true }
        .onChange(of: selectedWeekDay) { _ in hasUnsavedChanges = true }
        .onChange(of: note) { _ in hasUnsavedChanges = true }
        .alert("Discard Changes", isPresented: $showingDiscardChanges) {
            Button("Cancel", role: .cancel) { }
            Button("Discard", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Are you sure you want to discard your changes?")
        }
        .alert("Delete Task", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let task = task {
                    taskManager.deleteTask(task)
                    dismiss()
                }
            }
        } message: {
            Text("This task will be moved to archive. This action cannot be undone.")
        }
    }
    
    private var cultureSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Culture")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            if showingCustomCultureInput {
                VStack(spacing: 12) {
                    TextField("Enter culture name", text: $customCultureName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.appBody)
                    
                    Button("Choose from list") {
                        showingCustomCultureInput = false
                        customCultureName = ""
                    }
                    .font(.appCallout)
                    .foregroundColor(.appPrimary)
                }
            } else {
                VStack(spacing: 12) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Culture.predefined, id: \.id) { culture in
                                CultureChip(
                                    culture: culture,
                                    isSelected: selectedCulture?.id == culture.id
                                ) {
                                    selectedCulture = culture
                                }
                            }
                        }
                    }
                    
                    Button("Other") {
                        showingCustomCultureInput = true
                        selectedCulture = nil
                    }
                    .font(.appCallout)
                    .foregroundColor(.appPrimary)
                    .padding(.top, 8)
                }
            }
            
            if selectedCulture == nil && !showingCustomCultureInput {
                Text("Please select a culture")
                    .font(.appCaption1)
                    .foregroundColor(.appError)
            }
        }
    }
    
    private var workTypeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Work Type")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(WorkType.allCases, id: \.self) { workType in
                        WorkTypeChip(
                            workType: workType,
                            isSelected: selectedWorkType == workType
                        ) {
                            selectedWorkType = workType
                        }
                    }
                }
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Date & Time")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            VStack(spacing: 16) {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(.appPrimary)
                
                Toggle("Set specific time", isOn: $hasTime)
                    .font(.appBody)
                    .foregroundColor(.appDarkGray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            
            DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(height: 120)
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .opacity(hasTime ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: hasTime)
                .allowsHitTesting(hasTime)
        }
    }
    
    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequency")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            VStack(spacing: 12) {
                ForEach(Frequency.allCases, id: \.self) { frequency in
                    FrequencyRow(
                        frequency: frequency,
                        isSelected: selectedFrequency == frequency
                    ) {
                        selectedFrequency = frequency
                    }
                }
                
                if selectedFrequency == .weekly {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select day of week:")
                            .font(.appCallout)
                            .foregroundColor(.appDarkGray)
                        
                        HStack(spacing: 8) {
                            ForEach(1...7, id: \.self) { dayIndex in
                                let dayName = Calendar.current.shortWeekdaySymbols[dayIndex - 1]
                                Button(dayName) {
                                    selectedWeekDay = dayIndex
                                }
                                .font(.appCaption1)
                                .foregroundColor(selectedWeekDay == dayIndex ? .white : .appDarkGray)
                                .frame(width: 35, height: 35)
                                .background(
                                    Circle()
                                        .fill(selectedWeekDay == dayIndex ? AppColors.primary : AppColors.lightGray)
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Note (Optional)")
                .font(.appTitle3)
                .foregroundColor(.appPrimary)
            
            TextField("Add a note (e.g., dosage, special instructions)", text: $note, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.appBody)
                .lineLimit(3...6)
        }
    }
    
    private var deleteButton: some View {
        Button(action: { showingDeleteConfirmation = true }) {
            Text("Delete Task")
                .font(.appHeadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.error)
                .cornerRadius(25)
        }
        .padding(.top, 20)
    }
    
    private func setupInitialValues() {
        if let task = task {
            selectedCulture = task.culture
            selectedWorkType = task.workType
            selectedDate = task.date
            selectedTime = task.time ?? Date()
            hasTime = task.time != nil
            selectedFrequency = task.frequency
            selectedWeekDay = task.weekDay ?? 1
            note = task.note
        }
    }
    
    private func saveTask() {
        let culture: Culture
        if showingCustomCultureInput {
            culture = Culture(name: customCultureName)
        } else {
            culture = selectedCulture ?? Culture(name: "Unknown")
        }
        
        if let existingTask = task {
            var updatedTask = existingTask
            updatedTask.culture = culture
            updatedTask.workType = selectedWorkType
            updatedTask.date = selectedDate
            updatedTask.time = hasTime ? selectedTime : nil
            updatedTask.frequency = selectedFrequency
            updatedTask.weekDay = selectedFrequency == .weekly ? selectedWeekDay : nil
            updatedTask.note = note
            
            taskManager.updateTask(updatedTask)
        } else {
            let newTask = GardenTask(
                culture: culture,
                workType: selectedWorkType,
                date: selectedDate,
                time: hasTime ? selectedTime : nil,
                frequency: selectedFrequency,
                weekDay: selectedFrequency == .weekly ? selectedWeekDay : nil,
                note: note
            )
            
            taskManager.addTask(newTask)
        }
        
        dismiss()
    }
}

struct CultureChip: View {
    let culture: Culture
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(culture.name)
                .font(.appCallout)
                .foregroundColor(isSelected ? .white : .appDarkGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.primary : AppColors.lightGray)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WorkTypeChip: View {
    let workType: WorkType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: workType.icon)
                    .font(.appCaption1)
                
                Text(workType.rawValue)
                    .font(.appCallout)
            }
            .foregroundColor(isSelected ? .white : .appDarkGray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.primary : AppColors.lightGray)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FrequencyRow: View {
    let frequency: Frequency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .appPrimary : .appMediumGray)
                
                Text(frequency.displayName)
                    .font(.appBody)
                    .foregroundColor(.appDarkGray)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TaskFormView_Previews: PreviewProvider {
    static var previews: some View {
        TaskFormView(task: nil)
            .environmentObject(TaskManager())
    }
}
