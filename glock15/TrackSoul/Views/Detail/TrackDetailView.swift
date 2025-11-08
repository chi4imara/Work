import SwiftUI
import Combine

struct TrackDetailView: View {
    let track: TrackData
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var currentTrack: TrackData
    
    init(track: TrackData, viewModel: TrackViewModel) {
        self.track = track
        self.viewModel = viewModel
        self._currentTrack = State(initialValue: track)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        trackInfoSection
                        
                        notesSection
                        
                        technicalInfoSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical, 20)
                }
                
                bottomActionButtons
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingEditView) {
            AddEditTrackView(viewModel: viewModel, trackToEdit: currentTrack)
        }
        .alert("Delete Track", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteTrack(currentTrack)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this track? This action cannot be undone.")
        }
        .onAppear {
            viewModel.fetchTracks()
            updateCurrentTrack()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("TrackDataChanged"))) { _ in
            updateCurrentTrack()
        }
    }
    
    private func updateCurrentTrack() {
        if let updatedTrack = viewModel.tracks.first(where: { $0.id == track.id }) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentTrack = updatedTrack
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.appSecondaryText)
                        .frame(width: 32, height: 32)
                        .background(Color.appBackgroundGray)
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Image(systemName: "music.note")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(.appPrimaryBlue)
                .padding(.bottom, 8)
        }
    }
    
    private var trackInfoSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Track")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "music.note",
                    title: "Title",
                    content: currentTrack.title,
                    isLarge: true
                )
                
                if let artist = currentTrack.artist, !artist.isEmpty {
                    InfoRow(
                        icon: "person",
                        title: "Artist",
                        content: artist
                    )
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Notes")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "location",
                    title: "Where Heard",
                    content: currentTrack.whereHeard
                )
                
                if let context = currentTrack.context, !context.isEmpty {
                    InfoRow(
                        icon: "text.quote",
                        title: "Context",
                        content: context,
                        isMultiline: true
                    )
                }
                
                if let whatReminds = currentTrack.whatReminds, !whatReminds.isEmpty {
                    InfoRow(
                        icon: "heart",
                        title: "What Reminds",
                        content: whatReminds,
                        isMultiline: true
                    )
                }
            }
        }
    }
    
    private var technicalInfoSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Details")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "calendar",
                    title: "Date Added",
                    content: dateFormatter.string(from: currentTrack.dateAdded)
                )
            }
        }
    }
    
    private var bottomActionButtons: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingEditView = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.appBackgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.appPrimaryBlue, lineWidth: 2)
                    )
                    .cornerRadius(25)
                }
                
                Button(action: { showingDeleteAlert = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .font(.appCallout)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.red)
                    .cornerRadius(25)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let content: String
    var isLarge: Bool = false
    var isMultiline: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appPrimaryBlue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appCaption1)
                    .foregroundColor(.appSecondaryText)
                
                Text(content)
                    .font(isLarge ? .appTitle3 : .appCallout)
                    .foregroundColor(.appPrimaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isMultiline ? nil : 1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appBackgroundWhite)
                .shadow(color: .appShadow, radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    let sampleTrack = TrackData(
        title: "Bohemian Rhapsody",
        artist: "Queen",
        whereHeard: .radio,
        context: "Morning drive to work on a rainy Tuesday",
        whatReminds: "My college days and late night study sessions with friends. The epic guitar solo always takes me back to those carefree times."
    )
    
    return TrackDetailView(
        track: sampleTrack,
        viewModel: TrackViewModel()
    )
}
