import SwiftUI

struct JournalView: View {
    @EnvironmentObject private var meetingStore: MeetingStore
    @State private var showingFilterSheet = false
    @State private var showingAddMeeting = false
    @State private var selectedMeeting: Meeting?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBar
                    
                    if meetingStore.filteredMeetings.isEmpty {
                        emptyStateView
                    } else {
                        meetingsList
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilterSheet) {
                FilterSheet(meetingStore: meetingStore)
            }
            .sheet(isPresented: $showingAddMeeting) {
                if let meeting = selectedMeeting {
                    AddEditMeetingView(meetingStore: meetingStore, meetingToEdit: meeting)
                        .onDisappear {
                            selectedMeeting = nil
                        }
                } else {
                    AddEditMeetingView(meetingStore: meetingStore)
                }
            }
            .sheet(item: $selectedMeeting) { meeting in
                if showingAddMeeting {
                    EmptyView()
                } else {
                    MeetingDetailView(meeting: meeting, meetingStore: meetingStore)
                }
            }
            .onReceive(meetingStore.$searchText) { _ in
                meetingStore.updateFilteredMeetings()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Meeting Journal")
                .font(.theme.title1)
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    showingFilterSheet = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(Color.theme.primaryPurple)
                }
                
                Button(action: {
                    showingAddMeeting = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 5)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.lightText)
            
            TextField("Search meetings...", text: $meetingStore.searchText)
                .font(.theme.body)
                .foregroundColor(Color.theme.primaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.theme.shadowColor, radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private var meetingsList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Total meetings for selected period: \(meetingStore.meetingsCount)")
                    .font(.theme.footnote)
                    .foregroundColor(Color.theme.secondaryText)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 8) {
                    ForEach(meetingStore.filteredMeetings) { meeting in
                        MeetingCard(meeting: meeting) {
                            selectedMeeting = meeting
                        }
                        .contextMenu {
                            Button("Edit") {
                                selectedMeeting = meeting
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showingAddMeeting = true
                                }
                            }
                            Button("Delete", role: .destructive) {
                                meetingStore.deleteMeeting(meeting)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                .padding(.top, 12)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.lightText)
            
            VStack(spacing: 12) {
                Text(meetingStore.meetings.isEmpty ? "No unusual meetings yet" : "No meetings found")
                    .font(.theme.title3)
                    .foregroundColor(Color.theme.primaryText)
                
                Text(meetingStore.meetings.isEmpty ? 
                     "Start capturing your unexpected encounters" : 
                     "Try adjusting your filters")
                    .font(.theme.body)
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if meetingStore.meetings.isEmpty {
                    showingAddMeeting = true
                } else {
                    meetingStore.resetFilters()
                }
            }) {
                Text(meetingStore.meetings.isEmpty ? "Add First Meeting" : "Reset Filters")
                    .font(.theme.buttonText)
                    .foregroundColor(Color.theme.buttonText)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.buttonBackground)
                            .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct MeetingCard: View {
    let meeting: Meeting
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(meeting.title)
                        .font(.theme.headline)
                        .foregroundColor(Color.theme.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(meeting.formattedDate)
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.secondaryText)
                        Text(meeting.formattedTime)
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.lightText)
                    }
                }
                
                Text(meeting.shortDescription)
                    .font(.theme.body)
                    .foregroundColor(Color.theme.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let location = meeting.location, !location.isEmpty {
                    HStack {
                        Image(systemName: "location")
                            .font(.caption)
                            .foregroundColor(Color.theme.accentTeal)
                        Text(location)
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.accentTeal)
                            .lineLimit(2)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: 200)
            .concaveCard(cornerRadius: 8, depth: 3, color: .white)
            .overlay {
                ConcaveShape(cornerRadius: 8, depth: 3)
                    .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 1))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    JournalView()
        .environmentObject(MeetingStore())
}
