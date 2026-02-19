import SwiftUI

struct NewEventView: View {
    @ObservedObject var viewModel: EventsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventText = ""
    @State private var currentTime = Date()
    
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
                                
                                Text(formatTime(currentTime))
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                    .foregroundColor(ColorTheme.textPrimary)
                                
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
                        Button(action: saveEvent) {
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
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear {
            startTimeUpdater()
        }
    }
    
    private func saveEvent() {
        let trimmedText = eventText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newEvent = Event(text: trimmedText, timestamp: currentTime)
        viewModel.addEvent(newEvent)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = viewModel.use24HourFormat ? "HH:mm" : "h:mm a"
        return formatter.string(from: date)
    }
    
    private func startTimeUpdater() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentTime = Date()
        }
    }
}
