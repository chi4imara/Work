import SwiftUI

struct TripsView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddTrip = false
    @State private var showingFilterMenu = false
    @State private var selectedTrips: Set<UUID> = []
    @State private var isMultiSelectMode = false
    
    @State private var selectedSortOption: SortOption = .dateDescending
    @State private var selectedFilterOption: FilterOption = .all
    @State private var searchText = ""
    @State private var showingSortOptions = false
    @State private var showingFilterOptions = false
    
    enum SortOption: String, CaseIterable {
        case dateDescending = "Newest First"
        case dateAscending = "Oldest First"
        case titleAscending = "Title A-Z"
        case titleDescending = "Title Z-A"
        case countryAscending = "Country A-Z"
        case countryDescending = "Country Z-A"
    }
    
    enum FilterOption: String, CaseIterable {
        case all = "All Trips"
        case upcoming = "Upcoming"
        case past = "Past"
        case thisMonth = "This Month"
        case thisYear = "This Year"
    }
    
    var filteredAndSortedTrips: [Trip] {
        let trips = dataManager.getActiveTrips()
        
        let searchFiltered = searchText.isEmpty ? trips : trips.filter { trip in
            trip.title.localizedCaseInsensitiveContains(searchText) ||
            trip.country.localizedCaseInsensitiveContains(searchText) ||
            (trip.city?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            trip.notes.localizedCaseInsensitiveContains(searchText)
        }
        
        let dateFiltered = filterTripsByDate(searchFiltered)
        
        return sortTrips(dateFiltered)
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if filteredAndSortedTrips.isEmpty {
                    emptyStateView
                } else {
                    tripsList
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddTrip) {
            TripFormView(trip: nil)
        }
        .confirmationDialog("Filter & Sort", isPresented: $showingFilterMenu) {
            Button("Filter by Date") {
                showingFilterOptions = true
            }
            Button("Sort Options") {
                showingSortOptions = true
            }
            Button("Reset Filters") {
                selectedFilterOption = .all
                selectedSortOption = .dateDescending
                searchText = ""
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingFilterOptions) {
            FilterOptionsView(selectedFilter: $selectedFilterOption)
        }
        .sheet(isPresented: $showingSortOptions) {
            SortOptionsView(selectedSort: $selectedSortOption)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Travels")
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingAddTrip = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorTheme.secondaryText)
            
            TextField("Search trips...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(ColorTheme.primaryText)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ColorTheme.cardBackground
                .cornerRadius(12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "suitcase")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryText.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No trips yet")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Start documenting your adventures")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddTrip = true }) {
                Text("Add First Trip")
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.background)
                    .frame(width: 200, height: 50)
                    .background(ColorTheme.primaryText)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var tripsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredAndSortedTrips) { trip in
                    NavigationLink {
                        TripDetailView(trip: trip)
                    } label: {
                        TripCardView(
                            trip: trip,
                            isSelected: false,
                            isMultiSelectMode: false
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    
    private var multiSelectToolbar: some View {
        Group {
            if isMultiSelectMode {
                HStack {
                    Button("Cancel") {
                        isMultiSelectMode = false
                        selectedTrips.removeAll()
                    }
                    .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Button("Archive Selected (\(selectedTrips.count))") {
                        archiveSelectedTrips()
                    }
                    .foregroundColor(ColorTheme.primaryText)
                    .disabled(selectedTrips.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(ColorTheme.tabBarBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private func toggleSelection(for trip: Trip) {
        if selectedTrips.contains(trip.id) {
            selectedTrips.remove(trip.id)
        } else {
            selectedTrips.insert(trip.id)
        }
        
        if selectedTrips.isEmpty {
            isMultiSelectMode = false
        }
    }
    
    private func archiveSelectedTrips() {
        for tripId in selectedTrips {
            if let trip = filteredAndSortedTrips.first(where: { $0.id == tripId }) {
                dataManager.archiveTrip(trip)
            }
        }
        selectedTrips.removeAll()
        isMultiSelectMode = false
    }
    
    private func filterTripsByDate(_ trips: [Trip]) -> [Trip] {
        let now = Date()
        let calendar = Calendar.current
        
        switch selectedFilterOption {
        case .all:
            return trips
        case .upcoming:
            return trips.filter { $0.startDate > now }
        case .past:
            return trips.filter { $0.endDate < now }
        case .thisMonth:
            return trips.filter { trip in
                calendar.isDate(trip.startDate, equalTo: now, toGranularity: .month) ||
                calendar.isDate(trip.endDate, equalTo: now, toGranularity: .month)
            }
        case .thisYear:
            return trips.filter { trip in
                calendar.isDate(trip.startDate, equalTo: now, toGranularity: .year) ||
                calendar.isDate(trip.endDate, equalTo: now, toGranularity: .year)
            }
        }
    }
    
    private func sortTrips(_ trips: [Trip]) -> [Trip] {
        switch selectedSortOption {
        case .dateDescending:
            return trips.sorted { $0.startDate > $1.startDate }
        case .dateAscending:
            return trips.sorted { $0.startDate < $1.startDate }
        case .titleAscending:
            return trips.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .titleDescending:
            return trips.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        case .countryAscending:
            return trips.sorted { $0.country.localizedCaseInsensitiveCompare($1.country) == .orderedAscending }
        case .countryDescending:
            return trips.sorted { $0.country.localizedCaseInsensitiveCompare($1.country) == .orderedDescending }
        }
    }
}

struct TripCardView: View {
    let trip: Trip
    let isSelected: Bool
    let isMultiSelectMode: Bool
    
    var body: some View {
            HStack(spacing: 16) {
                if isMultiSelectMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.borderColor)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trip.title)
                            .font(FontManager.headline)
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(trip.locationString)
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    Text(trip.dateString)
                        .font(FontManager.small)
                        .foregroundColor(ColorTheme.accent)
                    
                    if !trip.notes.isEmpty {
                        Text(trip.shortNotes)
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.secondaryText)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                ColorTheme.cardGradient
                    .cornerRadius(12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.primaryText : ColorTheme.borderColor, lineWidth: 1)
            )
    }
}

struct FilterOptionsView: View {
    @Binding var selectedFilter: TripsView.FilterOption
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(TripsView.FilterOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedFilter = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(option.rawValue)
                                .foregroundColor(ColorTheme.primaryText)
                            Spacer()
                            if selectedFilter == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(ColorTheme.accent)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Trips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct SortOptionsView: View {
    @Binding var selectedSort: TripsView.SortOption
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(TripsView.SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedSort = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(option.rawValue)
                                .foregroundColor(ColorTheme.primaryText)
                            Spacer()
                            if selectedSort == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(ColorTheme.accent)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sort Trips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TripsView()
}
