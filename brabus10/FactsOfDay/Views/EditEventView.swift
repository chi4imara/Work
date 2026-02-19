import SwiftUI

struct EditEventView: View {
    let event: Event
    @ObservedObject var viewModel: EventsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventText: String
    
    init(event: Event, viewModel: EventsViewModel) {
        self.event = event
        self.viewModel = viewModel
        self._eventText = State(initialValue: event.text)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What happened")
                                .font(.custom("PlayfairDisplay-Medium", size: 16))
                                .foregroundColor(ColorTheme.textSecondary)
                            
                            TextField("What happened", text: $eventText)
                                .font(.custom("PlayfairDisplay-Regular", size: 18))
                                .foregroundColor(ColorTheme.textPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.top, 30)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(.custom("PlayfairDisplay-Medium", size: 16))
                                .foregroundColor(ColorTheme.textSecondary)
                            
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(ColorTheme.primaryBlue)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(event.formattedTime)
                                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    Text(event.formattedDate)
                                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button(action: saveChanges) {
                            Text("Save")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [ColorTheme.primaryBlue, ColorTheme.accentYellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
                        }
                        .disabled(eventText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(eventText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Cancel")
                                .font(.custom("PlayfairDisplay-Medium", size: 16))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    private func saveChanges() {
        let trimmedText = eventText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let updatedEvent = Event(id: event.id, text: trimmedText, timestamp: event.timestamp)
        viewModel.updateEvent(updatedEvent)
        presentationMode.wrappedValue.dismiss()
    }
}
