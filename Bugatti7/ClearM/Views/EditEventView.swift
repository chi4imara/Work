import SwiftUI

struct EditEventView: View {
    let event: Event
    let eventStore: EventStore
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventTitle: String
    @State private var eventDate: Date
    @State private var showingDatePicker = false
    
    init(event: Event, eventStore: EventStore, onSave: @escaping () -> Void) {
        self.event = event
        self.eventStore = eventStore
        self.onSave = onSave
        self._eventTitle = State(initialValue: event.title)
        self._eventDate = State(initialValue: event.date)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(AppFonts.body(16))
                        .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Text("Edit event")
                            .font(AppFonts.title(24))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Button("Save changes") {
                            saveChanges()
                        }
                        .font(AppFonts.body(16))
                        .foregroundColor(canSave ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.5))
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                    
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Event")
                                .font(AppFonts.caption(14))
                                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                .textCase(.uppercase)
                            
                            TextField("Enter event name", text: $eventTitle)
                                .font(AppFonts.body(16))
                                .foregroundColor(AppColors.primaryWhite)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                                        .fill(AppColors.primaryWhite.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                                                .stroke(AppColors.primaryWhite.opacity(0.2), lineWidth: 1)
                                        )
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date")
                                .font(AppFonts.caption(14))
                                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                                .textCase(.uppercase)
                            
                            Button(action: {
                                showingDatePicker.toggle()
                            }) {
                                HStack {
                                    Text(formattedDate)
                                        .font(AppFonts.body(16))
                                        .foregroundColor(AppColors.primaryWhite)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppColors.primaryYellow)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                                        .fill(AppColors.primaryWhite.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                                                .stroke(AppColors.primaryWhite.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            
                            if showingDatePicker {
                                DatePicker("", selection: $eventDate, displayedComponents: .date)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var canSave: Bool {
        let trimmedTitle = eventTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedTitle.isEmpty && (trimmedTitle != event.title || eventDate != event.date)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: eventDate)
    }
    
    private func saveChanges() {
        let trimmedTitle = eventTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        var updatedEvent = event
        updatedEvent.title = trimmedTitle
        updatedEvent.date = eventDate
        
        eventStore.updateEvent(updatedEvent)
        onSave()
        presentationMode.wrappedValue.dismiss()
    }
}
