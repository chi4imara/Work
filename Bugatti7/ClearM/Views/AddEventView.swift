import SwiftUI

struct AddEventView: View {
    let eventStore: EventStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventTitle = ""
    @State private var eventDate = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
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
                    
                    Text("New event")
                        .font(AppFonts.title(24))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveEvent()
                    }
                    .font(AppFonts.body(16))
                    .foregroundColor(canSave ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.5))
                    .disabled(!canSave)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView(showsIndicators: false) {
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
                }
            }
        }
    }
    
    private var canSave: Bool {
        !eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: eventDate)
    }
    
    private func saveEvent() {
        let trimmedTitle = eventTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let newEvent = Event(title: trimmedTitle, date: eventDate)
        eventStore.addEvent(newEvent)
        presentationMode.wrappedValue.dismiss()
    }
}
