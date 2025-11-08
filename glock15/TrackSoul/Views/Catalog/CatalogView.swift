import SwiftUI
import Combine

struct CatalogView: View {
    @StateObject private var viewModel = TrackViewModel()
    @State private var showingAddTrack = false
    @State private var showingFilters = false
    @State private var showingMenu = false
    @State private var selectedTrack: TrackData?
    @State private var trackToEdit: TrackData?
    @State private var showingDeleteAllAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    searchAndSortBar
                    
                    if viewModel.hasActiveFilters() {
                        filterIndicator
                    }
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.filteredTracks.isEmpty {
                        emptyStateView
                    } else {
                        tracksList
                    }
                }
            }
            .navigationTitle("Song Catalog")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Clear Filters") {
                            viewModel.clearFilters()
                        }
                        .disabled(!viewModel.hasActiveFilters())
                        
                        Button("Clear Catalog", role: .destructive) {
                            showingDeleteAllAlert = true
                        }
                        .disabled(viewModel.tracks.isEmpty)
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTrack) {
            AddEditTrackView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel)
        }
        .sheet(item: $selectedTrack) { track in
            TrackDetailView(track: track, viewModel: viewModel)
        }
        .sheet(item: $trackToEdit) { track in
            AddEditTrackView(viewModel: viewModel, trackToEdit: track)
        }
        .alert("Delete All Tracks", isPresented: $showingDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                viewModel.deleteAllTracks()
            }
        } message: {
            Text("Are you sure you want to delete all tracks and notes? This action cannot be undone.")
        }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.applyFilters()
        }
        .onAppear {
            viewModel.fetchTracks()
            viewModel.applyFilters()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.fetchTracks()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("TrackDataChanged"))) { _ in
            viewModel.fetchTracks()
        }
    }
    
    
    private var searchAndSortBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.appSecondaryText)
                    
                    TextField("Search by title or artist", text: $viewModel.searchText)
                        .font(.appCallout)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.appBackgroundGray)
                .cornerRadius(8)
                
                Button(action: { showingFilters = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter")
                    }
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.appPrimaryBlue, lineWidth: 1)
                    )
                }
            }
            
            HStack {
                HStack {
                    Text("Sort:")
                        .font(.appCallout)
                        .foregroundColor(.appSecondaryText)
                    
                    Picker("Sort", selection: $viewModel.sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.displayName)
                                .font(.appCallout)
                                .tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.appCallout)
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
                
                Button(action: { showingAddTrack = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Add Track")
                    }
                    .font(.appCallout)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [Color.appPrimaryBlue, Color.appDarkBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .background(Color.clear)
        .onChange(of: viewModel.sortOption) { _ in
            viewModel.applyFilters()
        }
    }
    
    private var filterIndicator: some View {
        HStack {
            Text("Filters applied")
                .font(.appCaption1)
                .foregroundColor(.appPrimaryBlue)
            
            Spacer()
            
            Button("Clear") {
                viewModel.clearFilters()
            }
            .font(.appCaption1)
            .foregroundColor(.appPrimaryBlue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.appLightBlue.opacity(0.2))
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.appPrimaryBlue)
            
            Text("Loading tracks...")
                .font(.appCallout)
                .foregroundColor(.appSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: viewModel.hasActiveFilters() ? "magnifyingglass" : "music.note")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appSecondaryText)
            
            VStack(spacing: 8) {
                Text(viewModel.hasActiveFilters() ? "No tracks found" : "Catalog is empty")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Text(viewModel.hasActiveFilters() ? 
                     "No tracks match your search criteria" : 
                     "Add your first track to get started")
                    .font(.appCallout)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if viewModel.hasActiveFilters() {
                    viewModel.clearFilters()
                } else {
                    showingAddTrack = true
                }
            }) {
                Text(viewModel.hasActiveFilters() ? "Clear Filters" : "Add First Track")
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
    
    private var tracksList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTracks, id: \.id) { track in
                    TrackCardView(track: track) {
                        selectedTrack = track
                    }
                    .contextMenu {
                        Button("View Details") {
                            selectedTrack = track
                        }
                        
                        Button("Edit") {
                            trackToEdit = track
                        }
                        
                        Button("Delete", role: .destructive) {
                            viewModel.deleteTrack(track)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    CatalogView()
}
