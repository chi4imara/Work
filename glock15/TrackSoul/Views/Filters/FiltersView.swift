import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    @State private var selectedWhereHeard: WhereHeardOption?
    @State private var onlyWithReminders: Bool = false
    @State private var selectedDateRange: DateRange = .all
    @State private var customStartDate: Date = Date()
    @State private var customEndDate: Date = Date()
    @State private var sortOption: SortOption = .dateNewest
    @State private var showingStartDatePicker = false
    @State private var showingEndDatePicker = false
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        searchSection
                        
                        whereHeardSection
                        
                        remindersSection
                        
                        dateRangeSection
                        
                        sortSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical, 20)
                }
                
                bottomButtons
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadCurrentFilters()
            viewModel.fetchTracks()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(.appCallout)
                .foregroundColor(.appSecondaryText)
                
                Spacer()
                
                Text("Search & Filters")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
                
                Button("Reset") {
                    resetFilters()
                }
                .font(.appCallout)
                .foregroundColor(.appPrimaryBlue)
            }
            .padding(.horizontal, 20)
            
            Divider()
                .background(Color.appGridBlue)
                .padding(.horizontal, 20)
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search Text")
                .font(.appHeadline)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
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
            .padding(.horizontal, 20)
        }
    }
    
    private var whereHeardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Source (Where Heard)")
                .font(.appHeadline)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                FilterOptionRow(
                    title: "All Sources",
                    isSelected: selectedWhereHeard == nil
                ) {
                    selectedWhereHeard = nil
                }
                
                ForEach(WhereHeardOption.allCases, id: \.self) { option in
                    FilterOptionRow(
                        title: option.displayName,
                        isSelected: selectedWhereHeard == option
                    ) {
                        selectedWhereHeard = option
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var remindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content Filter")
                .font(.appHeadline)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            Toggle("Only tracks with 'What Reminds' notes", isOn: $onlyWithReminders)
                .font(.appCallout)
                .toggleStyle(SwitchToggleStyle(tint: .appPrimaryBlue))
                .padding(.horizontal, 20)
        }
    }
    
    private var dateRangeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date Range")
                .font(.appHeadline)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                ForEach(DateRange.allCases, id: \.self) { range in
                    FilterOptionRow(
                        title: range.displayName,
                        isSelected: selectedDateRange == range
                    ) {
                        selectedDateRange = range
                    }
                }
            }
            .padding(.horizontal, 20)
            
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
                .padding(.top, 8)
            }
        }
    }
    
    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sort Results")
                .font(.appHeadline)
                .foregroundColor(.appPrimaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    FilterOptionRow(
                        title: option.displayName,
                        isSelected: sortOption == option
                    ) {
                        sortOption = option
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var bottomButtons: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                Button {
                    resetFilters()
                } label: {
                    Text("Clear All")
                        .font(.appCallout)
                        .foregroundColor(.appSecondaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appBackgroundGray)
                        .cornerRadius(25)
                }
                
                Button {
                    applyFilters()
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
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func loadCurrentFilters() {
        searchText = viewModel.searchText
        selectedWhereHeard = viewModel.selectedWhereHeard
        onlyWithReminders = viewModel.onlyWithReminders
        selectedDateRange = viewModel.selectedDateRange
        customStartDate = viewModel.customStartDate
        customEndDate = viewModel.customEndDate
        sortOption = viewModel.sortOption
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
    
    private func applyFilters() {
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
        dismiss()
    }
}

struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .appPrimaryBlue : .appSecondaryText)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.appCallout)
                    .foregroundColor(.appPrimaryText)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

