import SwiftUI
import Combine

struct GroupData: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let tracks: [TrackData]
    
    static func == (lhs: GroupData, rhs: GroupData) -> Bool {
        lhs.id == rhs.id
    }
}

struct ListsView: View {
    @StateObject private var viewModel = TrackViewModel()
    @State private var showingAddTrack = false
    @State private var selectedGroup: GroupData?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    if viewModel.tracks.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            VStack(spacing: 24) {
                                bySourceSection
                                
                                byDateSection
                            }
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .navigationTitle("Lists & Groups")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingAddTrack) {
            AddEditTrackView(viewModel: viewModel)
        }
        .sheet(item: $selectedGroup) { group in
            GroupTracksView(
                groupTitle: group.title,
                tracks: group.tracks,
                viewModel: viewModel
            )
        }
        .onAppear {
            viewModel.fetchTracks()
            viewModel.applyFilters()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("TrackDataChanged"))) { _ in
            viewModel.fetchTracks()
        }
    }
    
    
    private var bySourceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "folder")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.appPrimaryBlue)
                
                Text("By Source")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                ForEach(viewModel.getTracksByWhereHeard(), id: \.0) { source, count in
                    GroupRow(
                        icon: iconForWhereHeard(source),
                        title: source.displayName,
                        count: count,
                        action: {
                            filterBySource(source)
                        }
                    )
                }
            }
        }
    }
    
    private var byDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.appAccent)
                
                Text("By Date")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                ForEach(viewModel.getTracksByMonth(), id: \.0) { month, count in
                    GroupRow(
                        icon: "calendar.circle",
                        title: month,
                        count: count,
                        action: {
                            filterByMonth(month)
                        }
                    )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appSecondaryText)
            
            VStack(spacing: 8) {
                Text("No Data for Groups")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Text("Add some tracks to see them organized by source and date")
                    .font(.appCallout)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddTrack = true }) {
                Text("Add Track")
                    .font(.appCallout)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.appPrimaryBlue, Color.appDarkBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private func iconForWhereHeard(_ option: WhereHeardOption) -> String {
        switch option {
        case .radio:
            return "radio"
        case .cafe:
            return "cup.and.saucer"
        case .movie:
            return "tv"
        case .series:
            return "tv.and.mediabox"
        case .advertisement:
            return "megaphone"
        case .concert:
            return "music.mic"
        case .other:
            return "ellipsis.circle"
        }
    }
    
    private func filterBySource(_ source: WhereHeardOption) {
        let filteredTracks = viewModel.tracks.filter { $0.whereHeard == source.rawValue }
        selectedGroup = GroupData(title: source.rawValue, tracks: filteredTracks)
    }
    
    private func filterByMonth(_ month: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        if let date = formatter.date(from: month) {
            let calendar = Calendar.current
            let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start ?? date
            let endOfMonth = calendar.dateInterval(of: .month, for: date)?.end ?? date
            
            let filteredTracks = viewModel.tracks.filter { track in
                track.dateAdded >= startOfMonth && track.dateAdded < endOfMonth
            }
            selectedGroup = GroupData(title: month, tracks: filteredTracks)
        }
    }
}

struct GroupRow: View {
    let icon: String
    let title: String
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appPrimaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.appCaption1)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appPrimaryBlue)
                    .cornerRadius(12)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.appSecondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appBackgroundWhite)
                    .shadow(color: .appShadow, radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appGridBlue, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
    }
}

#Preview {
    ListsView()
        .background(BackgroundView())
}
