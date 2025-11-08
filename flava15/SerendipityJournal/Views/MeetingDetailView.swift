import SwiftUI

struct MeetingDetailView: View {
    let meeting: Meeting
    @ObservedObject var meetingStore: MeetingStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var currentMeeting: Meeting {
        meetingStore.meetings.first { $0.id == meeting.id } ?? meeting
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(currentMeeting.title)
                            .font(.theme.title1)
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.theme.primaryBlue)
                                Text(currentMeeting.formattedDate)
                                    .font(.theme.body)
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(Color.theme.primaryBlue)
                                Text(currentMeeting.formattedTime)
                                    .font(.theme.body)
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            
                            if let location = currentMeeting.location, !location.isEmpty {
                                HStack {
                                    Image(systemName: "location")
                                        .foregroundColor(Color.theme.accentTeal)
                                    Text(location)
                                        .font(.theme.body)
                                        .foregroundColor(Color.theme.accentTeal)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.cardGradient)
                                .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.theme.headline)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text(currentMeeting.description)
                                .font(.theme.body)
                                .foregroundColor(Color.theme.secondaryText)
                                .lineSpacing(4)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.cardGradient)
                                .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
                        )
                        
                        VStack(spacing: 12) {
                            Button("Edit Meeting") {
                                showingEditView = true
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            
                            Button("Delete Meeting") {
                                showingDeleteAlert = true
                            }
                            .buttonStyle(DeleteButtonStyle())
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Meeting Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryPurple)
                }
            }
            .sheet(isPresented: $showingEditView) {
                AddEditMeetingView(meetingStore: meetingStore, meetingToEdit: currentMeeting)
            }
            .alert("Delete Meeting", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    meetingStore.deleteMeeting(currentMeeting)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this meeting? This action cannot be undone.")
            }
        }
    }
}

struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.theme.buttonText)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.deleteRed)
                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    let sampleMeeting = Meeting(
        title: "Conversation with Street Musician",
        description: "Had an amazing conversation with a street musician playing violin near the central park. He told me about his journey from classical music to street performance and how it changed his perspective on connecting with people. We talked for about 30 minutes about music, life, and the beauty of unexpected encounters.",
        location: "Central Park",
        date: Date()
    )
    
    MeetingDetailView(meeting: sampleMeeting, meetingStore: MeetingStore())
}
