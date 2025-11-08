import SwiftUI

struct AddEditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Binding var isPresented: Bool
    
    let taskToEdit: CleaningTask?
    
    @State private var title = ""
    @State private var selectedRoom: Room = .kitchen
    @State private var customRoom = ""
    @State private var frequency: TaskFrequency = .daily
    @State private var selectedWeekDay: WeekDay = .monday
    @State private var note = ""
    @State private var showingDiscardAlert = false
    @State private var hasUnsavedChanges = false
    
    init(viewModel: TaskViewModel, isPresented: Binding<Bool>, taskToEdit: CleaningTask? = nil) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self.taskToEdit = taskToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button("Cancel") {
                            if hasUnsavedChanges {
                                showingDiscardAlert = true
                            } else {
                                isPresented = false
                            }
                        }
                        .foregroundColor(.pureWhite)
                        
                        Spacer()
                        
                        Text(taskToEdit == nil ? "New Task" : "Edit Task")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveTask()
                        }
                        .foregroundColor(.pureWhite)
                        .disabled(!isFormValid)
                    }
                    .padding(16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Task Name")
                                    .font(.customSubheadline())
                                    .foregroundColor(.pureWhite)
                                
                                TextField("Enter task name", text: $title)
                                    .font(.customBody())
                                    .padding()
                                    .background(Color.pureWhite)
                                    .cornerRadius(12)
                                    .onChange(of: title) { _ in
                                        hasUnsavedChanges = true
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Room")
                                    .font(.customSubheadline())
                                    .foregroundColor(.pureWhite)
                                
                                VStack(spacing: 12) {
                                    ForEach(Room.allCases, id: \.self) { room in
                                        HStack {
                                            Text(room.displayName)
                                                .font(.customBody())
                                                .foregroundColor(.darkGray)
                                            
                                            Spacer()
                                            
                                            Image(systemName: selectedRoom == room ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedRoom == room ? .primaryBlue : .mediumGray)
                                        }
                                        .padding()
                                        .background(Color.pureWhite)
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            selectedRoom = room
                                            hasUnsavedChanges = true
                                        }
                                    }
                                    
                                    if selectedRoom == .other {
                                        TextField("Enter custom room name", text: $customRoom)
                                            .font(.customBody())
                                            .padding()
                                            .background(Color.pureWhite.opacity(0.9))
                                            .cornerRadius(12)
                                            .onChange(of: customRoom) { _ in
                                                hasUnsavedChanges = true
                                            }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Frequency")
                                    .font(.customSubheadline())
                                    .foregroundColor(.pureWhite)
                                
                                VStack(spacing: 12) {
                                    ForEach(TaskFrequency.allCases, id: \.self) { freq in
                                        HStack {
                                            Text(freq.displayName)
                                                .font(.customBody())
                                                .foregroundColor(.darkGray)
                                            
                                            Spacer()
                                            
                                            Image(systemName: frequency == freq ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(frequency == freq ? .primaryBlue : .mediumGray)
                                        }
                                        .padding()
                                        .background(Color.pureWhite)
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            frequency = freq
                                            hasUnsavedChanges = true
                                        }
                                    }
                                    
                                    if frequency == .weekly {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Select Day")
                                                .font(.customCaption())
                                                .foregroundColor(.pureWhite.opacity(0.8))
                                            
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                                ForEach(WeekDay.allCases, id: \.self) { day in
                                                    HStack {
                                                        Text(day.displayName)
                                                            .font(.customCaption())
                                                            .foregroundColor(.darkGray)
                                                        
                                                        Spacer()
                                                        
                                                        Image(systemName: selectedWeekDay == day ? "checkmark.circle.fill" : "circle")
                                                            .foregroundColor(selectedWeekDay == day ? .primaryBlue : .mediumGray)
                                                            .font(.system(size: 16))
                                                    }
                                                    .padding(8)
                                                    .background(Color.pureWhite.opacity(0.9))
                                                    .cornerRadius(8)
                                                    .onTapGesture {
                                                        selectedWeekDay = day
                                                        hasUnsavedChanges = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note (Optional)")
                                    .font(.customSubheadline())
                                    .foregroundColor(.pureWhite)
                                
                                TextField("Add a note...", text: $note, axis: .vertical)
                                    .font(.customBody())
                                    .padding()
                                    .background(Color.pureWhite)
                                    .cornerRadius(12)
                                    .lineLimit(3...6)
                                    .onChange(of: note) { _ in
                                        hasUnsavedChanges = true
                                    }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
                Button("Keep Editing", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    isPresented = false
                }
            } message: {
                Text("Your changes will be lost if you continue.")
            }
        }
        .onAppear {
            setupInitialValues()
        }

    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (frequency == .daily || (frequency == .weekly))
    }
    
    private func setupInitialValues() {
        if let task = taskToEdit {
            title = task.title
            selectedRoom = task.room
            customRoom = task.customRoom ?? ""
            frequency = task.frequency
            selectedWeekDay = task.weekDay ?? .monday
            note = task.note ?? ""
        }
    }
    
    private func saveTask() {
        if let existingTask = taskToEdit {
            var updatedTask = existingTask
            updatedTask.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedTask.room = selectedRoom
            updatedTask.customRoom = selectedRoom == .other ? customRoom : nil
            updatedTask.frequency = frequency
            updatedTask.weekDay = frequency == .weekly ? selectedWeekDay : nil
            updatedTask.note = note.isEmpty ? nil : note
            
            viewModel.updateTask(updatedTask)
            isPresented = false
        } else {
            let newTask = CleaningTask(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                room: selectedRoom,
                customRoom: selectedRoom == .other ? customRoom : nil,
                frequency: frequency,
                weekDay: frequency == .weekly ? selectedWeekDay : nil,
                note: note.isEmpty ? nil : note
            )
            
            viewModel.addTask(newTask)
            isPresented = false
        }
    }
}

#Preview {
    AddEditTaskView(viewModel: TaskViewModel(), isPresented: .constant(true))
}
