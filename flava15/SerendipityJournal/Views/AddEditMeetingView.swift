import SwiftUI

struct AddEditMeetingView: View {
    @ObservedObject var meetingStore: MeetingStore
    @Environment(\.dismiss) private var dismiss
    
    let meetingToEdit: Meeting?
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    @State private var titleError = ""
    @State private var descriptionError = ""
    
    init(meetingStore: MeetingStore, meetingToEdit: Meeting? = nil) {
        self.meetingStore = meetingStore
        self.meetingToEdit = meetingToEdit
        
        if let meeting = meetingToEdit {
            self._title = State(initialValue: meeting.title)
            self._description = State(initialValue: meeting.description)
            self._location = State(initialValue: meeting.location ?? "")
            self._selectedDate = State(initialValue: meeting.date)
        }
    }
    
    private var isEditing: Bool {
        meetingToEdit != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("e.g., conversation with street musician", text: $title)
                                .font(.theme.body)
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                                        }
                                )
                                .onChange(of: title) { _ in
                                    validateTitle()
                                }
                            
                            if !titleError.isEmpty {
                                Text(titleError)
                                    .font(.theme.caption)
                                    .foregroundColor(Color.theme.deleteRed)
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal, -20)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                                    }
                                    .frame(minHeight: 120)
                                
                                if description.isEmpty {
                                    Text("Describe what happened...")
                                        .font(.theme.body)
                                        .foregroundColor(Color.theme.lightText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                
                                TextEditor(text: $description)
                                    .font(.theme.body)
                                    .foregroundColor(Color.theme.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.clear)
                                    .onChange(of: description) { _ in
                                        validateDescription()
                                    }
                            }
                            
                            if !descriptionError.isEmpty {
                                Text(descriptionError)
                                    .font(.theme.caption)
                                    .foregroundColor(Color.theme.deleteRed)
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal, -20)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location (Optional)")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Where did this happen?", text: $location)
                                .font(.theme.body)
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                                        }
                                )
                        }
                        
                        Divider()
                            .padding(.horizontal, -20)
                            .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date & Time")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.theme.primaryBlue)
                                    
                                    Text(formatDateTime(selectedDate))
                                        .font(.theme.body)
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color.theme.lightText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                                        }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Meeting" : "New Meeting")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryPurple)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMeeting()
                    }
                    .foregroundColor(canSave ? Color.theme.primaryBlue : Color.theme.lightText)
                    .disabled(!canSave)
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $selectedDate)
            }
        }
    }
    
    private func validateTitle() {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleError = "Please enter a title"
        } else {
            titleError = ""
        }
    }
    
    private func validateDescription() {
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            descriptionError = "Please enter a description"
        } else {
            descriptionError = ""
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy 'at' HH:mm"
        return formatter.string(from: date)
    }
    
    private func saveMeeting() {
        validateTitle()
        validateDescription()
        
        guard canSave else { return }
        
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalLocation = trimmedLocation.isEmpty ? nil : trimmedLocation
        
        if let meetingToEdit = meetingToEdit {
            var updatedMeeting = meetingToEdit
            updatedMeeting.update(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                location: finalLocation,
                date: selectedDate
            )
            meetingStore.updateMeeting(updatedMeeting)
        } else {
            let newMeeting = Meeting(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                location: finalLocation,
                date: selectedDate
            )
            meetingStore.addMeeting(newMeeting)
        }
        
        dismiss()
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date & Time",
                        selection: $selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Date & Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    AddEditMeetingView(meetingStore: MeetingStore())
}
