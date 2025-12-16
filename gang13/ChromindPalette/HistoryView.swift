import SwiftUI

struct HistoryView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var showingFilters = false
    @State private var filterOptions = FilterOptions()
    @State private var selectedEntry: DayEntry?
    @State private var showingEntryDetail: IdentifiableID<DayEntry.ID>?
    
    private var filteredEntries: [DayEntry] {
        dataManager.getFilteredEntries(with: filterOptions)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if filteredEntries.isEmpty {
                        emptyStateView
                    } else {
                        entriesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                FilterView(options: $filterOptions)
            }
            .sheet(item: $showingEntryDetail) { identifiableId in
                if let entry = dataManager.dayEntries.first(where: { $0.id == identifiableId.wrappedId }) {
                    EntryDetailView(entry: entry)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Color History")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(colorTheme.primaryWhite)
            
            Spacer()
            
            Button(action: {
                showingFilters = true
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite)
                    .frame(width: 44, height: 44)
                    .background(colorTheme.primaryPurple.opacity(0.3))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEntries) { entry in
                    EntryCard(entry: entry) {
                        showingEntryDetail = IdentifiableID(entry.id)
                    }
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintpalette")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
            
            Text("Here will appear the colors of your days. Start today.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct EntryCard: View {
    let entry: DayEntry
    let onTap: () -> Void
    @StateObject private var colorTheme = ColorTheme.shared
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Circle()
                    .fill(entry.color.color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(colorTheme.primaryWhite.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate(entry.date))
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(colorTheme.primaryWhite)
                    
                    Text(entry.description)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(formatTime(entry.createdAt))
                        .font(.playfairDisplay(12, weight: .light))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.5))
            }
            .padding()
            .background(colorTheme.primaryWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var options: FilterOptions
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var tempOptions: FilterOptions
    
    init(options: Binding<FilterOptions>) {
        self._options = options
        self._tempOptions = State(initialValue: options.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 25) {
                        searchSection
                        periodSection
                        colorFilterSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Reset") {
                    tempOptions = FilterOptions()
                },
                trailing: Button("Apply") {
                    options = tempOptions
                    dismiss()
                }
            )
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Search in descriptions")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
            
            TextField("Enter search text", text: $tempOptions.searchText)
                .font(.playfairDisplay(14))
                .padding(12)
                .background(colorTheme.primaryWhite.opacity(0.9))
                .cornerRadius(8)
        }
    }
    
    private var periodSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Period")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
            
            ForEach(FilterPeriod.allCases, id: \.self) { period in
                Button(action: {
                    tempOptions.period = period
                }) {
                    HStack {
                        Text(period.rawValue)
                            .font(.playfairDisplay(14))
                            .foregroundColor(colorTheme.primaryWhite)
                        
                        Spacer()
                        
                        if tempOptions.period == period {
                            Image(systemName: "checkmark")
                                .foregroundColor(colorTheme.primaryPurple)
                        }
                    }
                    .padding(12)
                    .background(colorTheme.primaryWhite.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var colorFilterSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Filter by colors")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(colorTheme.moodColors) { color in
                    Button(action: {
                        if tempOptions.selectedColors.contains(color.name) {
                            tempOptions.selectedColors.remove(color.name)
                        } else {
                            tempOptions.selectedColors.insert(color.name)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            tempOptions.selectedColors.contains(color.name) ? colorTheme.primaryWhite : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                            
                            if tempOptions.selectedColors.contains(color.name) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(colorTheme.primaryWhite)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EntryDetailView: View {
    let entry: DayEntry
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 30) {
                    Circle()
                        .fill(entry.color.color)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle()
                                .stroke(colorTheme.primaryWhite, lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    VStack(spacing: 15) {
                        Text(entry.description)
                            .font(.playfairDisplay(18, weight: .regular))
                            .foregroundColor(colorTheme.primaryWhite)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 5) {
                            Text(formatDate(entry.date))
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                            
                            Text(formatTime(entry.createdAt))
                                .font(.playfairDisplay(14, weight: .light))
                                .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            Text("Edit")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(colorTheme.primaryPurple)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(colorTheme.primaryWhite)
                                .cornerRadius(22)
                        }
                        
                        Button(action: {
                            showingDeleteConfirmation = true
                        }) {
                            Text("Delete")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(colorTheme.errorRed)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(colorTheme.primaryWhite.opacity(0.2))
                                .cornerRadius(22)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(colorTheme.errorRed.opacity(0.5), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                }
            )
            .sheet(isPresented: $showingEditView) {
                EditDayView(entry: entry)
            }
            .alert("Delete Day", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    dataManager.deleteDayEntry(entry)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this day?")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
}
