import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var viewModel = TrackViewModel()
    @State private var searchText = ""
    @State private var selectedWhereHeard: WhereHeardOption?
    @State private var onlyWithReminders = false
    @State private var selectedDateRange: DateRange = .all
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var sortOption: SortOption = .dateNewest
    @State private var showingStartDatePicker = false
    @State private var showingEndDatePicker = false
    @State private var showingResults = false
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    @State private var selectedTrack: TrackData?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            searchSection
                            
                            filtersSection
                            
                            if showingResults {
                                resultsSection
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.vertical, 20)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    bottomButtons
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showingResults {
                        Button("New Search") {
                            resetSearch()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingStartDatePicker) {
            DatePickerSheet(selectedDate: $customStartDate, title: "Start Date")
        }
        .sheet(isPresented: $showingEndDatePicker) {
            DatePickerSheet(selectedDate: $customEndDate, title: "End Date")
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
        .sheet(item: $selectedTrack) { track in
            TrackDetailView(track: track, viewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchTracks()
            viewModel.applyFilters()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("TrackDataChanged"))) { _ in
            viewModel.fetchTracks()
        }
    }
    
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search Text")
                        .font(.appCallout)
                        .foregroundColor(.appPrimaryText)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appSecondaryText)
                        
                        TextField("Search by title or artist", text: $searchText)
                            .font(.appCallout)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.appBackgroundGray)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Source (Where Heard)")
                        .font(.appCallout)
                        .foregroundColor(.appPrimaryText)
                    
                    Picker("Source", selection: $selectedWhereHeard) {
                        Text("All Sources").tag(nil as WhereHeardOption?)
                        ForEach(WhereHeardOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option as WhereHeardOption?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.appBackgroundGray)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Only tracks with 'What Reminds' notes", isOn: $onlyWithReminders)
                        .font(.appCallout)
                        .toggleStyle(SwitchToggleStyle(tint: .appPrimaryBlue))
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var filtersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Filters")
                .font(.appTitle3)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date Range")
                        .font(.appCallout)
                        .foregroundColor(.appPrimaryText)
                    
                    Picker("Date Range", selection: $selectedDateRange) {
                        ForEach(DateRange.allCases, id: \.self) { range in
                            Text(range.displayName).tag(range)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.appBackgroundGray)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if selectedDateRange == .custom {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("From")
                                    .font(.appCaption1)
                                    .foregroundColor(.appSecondaryText)
                                
                                Button(action: { showingStartDatePicker = true }) {
                                    Text(dateFormatter.string(from: customStartDate))
                                        .font(.appCallout)
                                        .foregroundColor(.appPrimaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.appBackgroundGray)
                                        .cornerRadius(6)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("To")
                                    .font(.appCaption1)
                                    .foregroundColor(.appSecondaryText)
                                
                                Button(action: { showingEndDatePicker = true }) {
                                    Text(dateFormatter.string(from: customEndDate))
                                        .font(.appCallout)
                                        .foregroundColor(.appPrimaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.appBackgroundGray)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sort Results")
                        .font(.appCallout)
                        .foregroundColor(.appPrimaryText)
                    
                    Picker("Sort", selection: $sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.appBackgroundGray)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Search Results")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
                
                Text("\(viewModel.filteredTracks.count) tracks")
                    .font(.appCaption1)
                    .foregroundColor(.appSecondaryText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appBackgroundGray)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            
            if viewModel.filteredTracks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.appSecondaryText)
                    
                    Text("No tracks match your search criteria")
                        .font(.appCallout)
                        .foregroundColor(.appSecondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button("Clear Search") {
                        resetSearch()
                    }
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryBlue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredTracks, id: \.id) { track in
                        TrackCardView(track: track) {
                            selectedTrack = track
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var bottomButtons: some View {
            HStack(spacing: 16) {
                Button {
                    resetFilters()
                } label: {
                    Text("Reset")
                        .font(.appCallout)
                        .foregroundColor(.appSecondaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appBackgroundGray)
                        .cornerRadius(25)
                }
                
                Button {
                    performSearch()
                } label: {
                    Text("Show Results")
                        .font(.appCallout)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
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
            .padding(.horizontal, 8)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func resetFilters() {
        searchText = ""
        selectedWhereHeard = nil
        onlyWithReminders = false
        selectedDateRange = .all
        customStartDate = Date()
        customEndDate = Date()
        sortOption = .dateNewest
    }
    
    private func resetSearch() {
        resetFilters()
        showingResults = false
        viewModel.clearFilters()
    }
    
    private func performSearch() {
        if selectedDateRange == .custom {
            if customStartDate > customEndDate {
                validationMessage = "Start date cannot be after end date"
                showingValidationAlert = true
                return
            }
            
            if customStartDate > Date() || customEndDate > Date() {
                validationMessage = "Cannot select future dates"
                showingValidationAlert = true
                return
            }
        }
        
        viewModel.searchText = searchText
        viewModel.selectedWhereHeard = selectedWhereHeard
        viewModel.onlyWithReminders = onlyWithReminders
        viewModel.selectedDateRange = selectedDateRange
        viewModel.customStartDate = customStartDate
        viewModel.customEndDate = customEndDate
        viewModel.sortOption = sortOption
        
        viewModel.applyFilters()
        showingResults = true
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    title,
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .background(BackgroundView())
}
