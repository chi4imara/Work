import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager = DataManager.shared
    
    @State private var selectedType: EventType?
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var comment = ""
    
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false
    @State private var showingValidationError = false
    @State private var validationMessage = ""
    
    let editingEvent: PetEvent?
    let eventType: EventType?
    
    init(eventType: EventType? = nil, editingEvent: PetEvent? = nil) {
        self.eventType = eventType
        self.editingEvent = editingEvent
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        eventTypeSection
                        
                        dateTimeSection
                        
                        commentSection
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Event" : "New Event")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                    .foregroundColor(canSave ? .white : .white.opacity(0.5))
                    .disabled(!canSave)
                }
            }
        }
        .alert("Validation Error", isPresented: $showingValidationError) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var eventTypeSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Event Type")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Required")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(EventType.allCases, id: \.self) { eventType in
                    EventTypeCard(
                        eventType: eventType,
                        isSelected: selectedType == eventType,
                        onTapped: {
                            selectedType = eventType
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var dateTimeSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Date & Time")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Date")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showingDatePicker = true }) {
                        Text(DateFormatter.dayMonthYear.string(from: selectedDate))
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                
                HStack {
                    Text("Time")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showingTimePicker = true }) {
                        Text(DateFormatter.timeOnly.string(from: selectedTime))
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate, maxDate: Date())
        }
        .sheet(isPresented: $showingTimePicker) {
            TimePickerSheet(selectedTime: $selectedTime)
        }
    }
    
    private var commentSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Comment")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(comment.count)/120")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(comment.count > 120 ? Color.theme.accentRed : .white.opacity(0.6))
            }
            
            TextField("Add a comment (optional)", text: $comment, axis: .vertical)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.white)
                .padding(16)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .lineLimit(3...6)
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var saveButton: some View {
        Button(action: saveEvent) {
            HStack {
                Spacer()
                
                Text(isEditing ? "Update Event" : "Save Event")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .background(
                canSave ? 
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.secondaryPurple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.buttonDisabled, Color.theme.buttonDisabled]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: canSave ? Color.theme.primaryPurple.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!canSave)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private var isEditing: Bool {
        editingEvent != nil
    }
    
    private var canSave: Bool {
        guard let _ = selectedType else { return false }
        guard comment.count <= 120 else { return false }
        guard !isFutureDateTime else { return false }
        return true
    }
    
    private var isFutureDateTime: Bool {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        guard let combinedDate = calendar.date(from: combinedComponents) else { return false }
        return combinedDate > Date()
    }
    
    private func setupInitialValues() {
        if let event = editingEvent {
            selectedType = event.type
            selectedDate = event.date
            selectedTime = event.time
            comment = event.comment
        } else {
            selectedType = eventType
            selectedDate = Date()
            selectedTime = Date()
            comment = ""
        }
    }
    
    private func saveEvent() {
        guard let type = selectedType else {
            showValidationError("Please select an event type")
            return
        }
        
        guard comment.count <= 120 else {
            showValidationError("Comment must be 120 characters or less")
            return
        }
        
        guard !isFutureDateTime else {
            showValidationError("Future dates and times are not allowed")
            return
        }
        
        if let existingEvent = editingEvent {
            var updatedEvent = existingEvent
            updatedEvent.type = type
            updatedEvent.date = selectedDate
            updatedEvent.time = selectedTime
            updatedEvent.comment = comment
            
            dataManager.updateEvent(updatedEvent)
        } else {
            let newEvent = PetEvent(
                type: type,
                date: selectedDate,
                time: selectedTime,
                comment: comment
            )
            
            dataManager.addEvent(newEvent)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func showValidationError(_ message: String) {
        validationMessage = message
        showingValidationError = true
    }
}

struct EventTypeCard: View {
    let eventType: EventType
    let isSelected: Bool
    let onTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: eventType.iconName)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(isSelected ? .white : eventColor)
            
            Text(eventType.displayName)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            isSelected ? 
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.secondaryPurple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ) :
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
        .onTapGesture {
            onTapped()
        }
    }
    
    private var eventColor: Color {
        switch eventType {
        case .feeding:
            return Color.theme.accentOrange
        case .walk:
            return Color.theme.accentGreen
        case .vitamins:
            return Color.theme.accentYellow
        case .veterinarian:
            return Color.theme.accentRed
        }
    }
}

struct DatePickerSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedDate: Date
    let maxDate: Date
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...maxDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct TimePickerSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTime: Date
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Time",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Select Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AddEventView()
}
