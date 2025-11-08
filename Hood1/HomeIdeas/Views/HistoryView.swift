import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: IdeasViewModel
    @State private var searchText = ""
    @State private var showingDateFilter = false
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    
    var filteredHistory: [HistoryEvent] {
        var filtered = viewModel.historyEvents
        
        if !searchText.isEmpty {
            filtered = filtered.filter { event in
                event.idea.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let startDate = selectedStartDate {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: startDate)
            filtered = filtered.filter { event in
                event.timestamp >= startOfDay
            }
        }
        
        if let endDate = selectedEndDate {
            let calendar = Calendar.current
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) ?? endDate
            filtered = filtered.filter { event in
                event.timestamp < endOfDay
            }
        }
        
        return filtered
    }
    
    var body: some View {
        return ZStack {
            VStack(spacing: 0) {
                searchAndFilterView
                
                if selectedStartDate != nil || selectedEndDate != nil {
                    activeFiltersView
                }
                
                if filteredHistory.isEmpty {
                    emptyStateView
                } else {
                    historyListView
                }
            }
        }
        .sheet(isPresented: $showingDateFilter) {
            DateFilterView(
                startDate: $selectedStartDate,
                endDate: $selectedEndDate
            )
        }
    }
    
    
    private var searchAndFilterView: some View {
        return HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search by idea title...", text: $searchText)
                .font(.theme.body)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
    
    private var activeFiltersView: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                if let startDate = selectedStartDate {
                    FilterChipView(
                        title: "From: \(DateFormatter.shortDate.string(from: startDate))"
                    ) {
                        selectedStartDate = nil
                    }
                }
                
                if let endDate = selectedEndDate {
                    FilterChipView(
                        title: "To: \(DateFormatter.shortDate.string(from: endDate))"
                    ) {
                        selectedEndDate = nil
                    }
                }
                
                if selectedStartDate != nil || selectedEndDate != nil {
                    Button("Clear All") {
                        selectedStartDate = nil
                        selectedEndDate = nil
                    }
                    .font(.theme.caption1)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.buttonSecondary)
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
    
    private var historyListView: some View {
        return ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredHistory) { event in
                    HistoryEventCardView(event: event, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
        }
    }
    
    private var emptyStateView: some View {
        return VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text(viewModel.historyEvents.isEmpty ? "No History" : "No Results Found")
                .font(.theme.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text(viewModel.historyEvents.isEmpty ? 
                 "Your activity history will appear here" : 
                 "Try adjusting your search or date filters")
                .font(.theme.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if viewModel.historyEvents.isEmpty {
                NavigationLink("Go to Ideas") {
                    IdeasListView()
                }
                .font(.theme.buttonMedium)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(AppColors.primaryOrange)
                .cornerRadius(20)
            } else {
                Button("Clear Filters") {
                    searchText = ""
                    selectedStartDate = nil
                    selectedEndDate = nil
                }
                .font(.theme.buttonMedium)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(AppColors.primaryOrange)
                .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct HistoryEventCardView: View {
    let event: HistoryEvent
    @ObservedObject var viewModel: IdeasViewModel
    @State private var selectedIdea: Idea?
    
    private var eventIcon: String {
        switch event.eventType {
        case .added:
            return "plus.circle.fill"
        case .modified:
            return "pencil.circle.fill"
        case .deleted:
            return "trash.circle.fill"
        }
    }
    
    private var eventColor: Color {
        switch event.eventType {
        case .added:
            return AppColors.success
        case .modified:
            return AppColors.primaryOrange
        case .deleted:
            return AppColors.error
        }
    }
    
    private var isClickable: Bool {
        if let idea = viewModel.ideas.first(where: { $0.id == event.idea.id }) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        Button(action: {
            if isClickable {
                if let idea = viewModel.ideas.first(where: { $0.id == event.idea.id }) {
                    selectedIdea = idea
                }
            }
        }) {
            HStack(spacing: 15) {
                Image(systemName: eventIcon)
                    .font(.title2)
                    .foregroundColor(eventColor)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.displayText)
                        .font(.theme.body)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(DateFormatter.timeFormatter.string(from: event.timestamp))
                        .font(.theme.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                if isClickable {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(15)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isClickable)
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(ideaId: idea.id, viewModel: viewModel)
        }
    }
}

struct FilterChipView: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .font(.theme.caption1)
                .foregroundColor(AppColors.textPrimary)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(AppColors.primaryOrange.opacity(0.8))
        .cornerRadius(15)
    }
}

struct DateFilterView: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempStartDate = Date()
    @State private var tempEndDate = Date()
    @State private var useStartDate = false
    @State private var useEndDate = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Filter from date", isOn: $useStartDate)
                            .font(.theme.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        if useStartDate {
                            DatePicker(
                                "Start Date",
                                selection: $tempStartDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                        }
                    }
                    .padding(15)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle("Filter to date", isOn: $useEndDate)
                            .font(.theme.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        if useEndDate {
                            DatePicker(
                                "End Date",
                                selection: $tempEndDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                        }
                    }
                    .padding(15)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Date Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        startDate = useStartDate ? tempStartDate : nil
                        endDate = useEndDate ? tempEndDate : nil
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                }
            }
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            if let start = startDate {
                tempStartDate = start
                useStartDate = true
            }
            if let end = endDate {
                tempEndDate = end
                useEndDate = true
            }
        }
    }
}

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

#Preview {
    HistoryView()
        .environmentObject(IdeasViewModel())
}
