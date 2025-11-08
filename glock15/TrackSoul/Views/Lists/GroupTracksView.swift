import SwiftUI
import Combine

struct GroupTracksView: View {
    let groupTitle: String
    let tracks: [TrackData]
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTrack: TrackData?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                if tracks.isEmpty {
                    EmptyGroupView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(tracks) { track in
                                TrackCardView(track: track) {
                                    selectedTrack = track
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle(groupTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.appPrimaryBlue)
                }
            }
        }
        .sheet(item: $selectedTrack) { track in
            TrackDetailView(track: track, viewModel: viewModel)
        }
    }
}

struct EmptyGroupView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "music.note.slash")
                .font(.system(size: 60))
                .foregroundColor(.appSecondaryText)
            
            Text("No tracks in this group")
                .font(.appTitle2)
                .foregroundColor(.appPrimaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    GroupTracksView(
        groupTitle: "Radio",
        tracks: [],
        viewModel: TrackViewModel()
    )
    .background(BackgroundView())
}
