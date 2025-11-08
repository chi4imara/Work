import SwiftUI

struct SummaryView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedSegment = 0
    @State private var selectedDream: Dream?
    @State private var selectedOutcomeStatus: DreamStatus = .fulfilled
    @State private var outcomeDate = Date()
    @State private var outcomeComment = ""
    
    @State private var selectedTags: Set<String> = []
    @State private var dateFilterType: DateFilterType = .dreamDate
    @State private var dateRange: DateRange = .all
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    
    @Binding var showingFilters: Bool
    
    enum DateFilterType: String, CaseIterable {
        case dreamDate = "Dream Date"
        case outcomeDate = "Outcome Date"
    }
    
    enum DateRange: String, CaseIterable {
        case all = "All Time"
        case week = "This Week"
        case month = "This Month"
        case custom = "Custom Range"
    }
    
    private let segments = ["Waiting", "Fulfilled", "Not Fulfilled"]
    
    var body: some View {
        VStack(spacing: 0) {
            segmentControl
            
            TabView(selection: $selectedSegment) {
                waitingDreamsView.tag(0)
                fulfilledDreamsView.tag(1)
                notFulfilledDreamsView.tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .sheet(isPresented: $showingFilters) {
            SummaryFiltersView(
                selectedTags: $selectedTags,
                dateFilterType: $dateFilterType,
                dateRange: $dateRange,
                customStartDate: $customStartDate,
                customEndDate: $customEndDate
            )
        }
        .sheet(item: Binding<Dream?>(
            get: { selectedDream },
            set: { _ in selectedDream = nil }
        )) { dream in
            OutcomeFormView(
                status: selectedOutcomeStatus,
                outcomeDate: $outcomeDate,
                outcomeComment: $outcomeComment
            ) {
                updateDreamStatus(dream)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Summary")
                .font(AppFonts.semiBold(18))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingFilters = true
            }) {
                Image(systemName: hasActiveFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(hasActiveFilters ? AppColors.yellow : AppColors.primaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var segmentControl: some View {
        HStack(spacing: 0) {
            ForEach(0..<segments.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedSegment = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(segments[index])
                            .font(AppFonts.medium(14))
                            .foregroundColor(selectedSegment == index ? AppColors.yellow : AppColors.secondaryText)
                        
                        Text("\(getDreamCount(for: index))")
                            .font(AppFonts.bold(16))
                            .foregroundColor(selectedSegment == index ? AppColors.yellow : AppColors.primaryText)
                        
                        Rectangle()
                            .fill(selectedSegment == index ? AppColors.yellow : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(AppColors.cardBackground.opacity(0.5))
    }
    
    private var waitingDreamsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                let dreams = getFilteredDreams(for: .waiting)
                
                if dreams.isEmpty {
                    emptyStateView(for: .waiting)
                } else {
                    ForEach(dreams.sorted { $0.checkDeadline < $1.checkDeadline }) { dream in
                        WaitingDreamCard(dream: dream) { status in
                            selectedOutcomeStatus = status
                            outcomeDate = Date()
                            outcomeComment = ""
                            selectedDream = dream
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
    }
    
    private var fulfilledDreamsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                let dreams = getFilteredDreams(for: .fulfilled)
                
                if dreams.isEmpty {
                    emptyStateView(for: .fulfilled)
                } else {
                    ForEach(dreams.sorted { 
                        ($0.outcomeDate ?? $0.dreamDate) > ($1.outcomeDate ?? $1.dreamDate) 
                    }) { dream in
                        CompletedDreamCard(dream: dream)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
    }
    
    private var notFulfilledDreamsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                let dreams = getFilteredDreams(for: .notFulfilled)
                
                if dreams.isEmpty {
                    emptyStateView(for: .notFulfilled)
                } else {
                    ForEach(dreams.sorted { 
                        ($0.outcomeDate ?? $0.dreamDate) > ($1.outcomeDate ?? $1.dreamDate) 
                    }) { dream in
                        CompletedDreamCard(dream: dream)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 10)
        }
    }
    
    private func emptyStateView(for status: DreamStatus) -> some View {
        VStack(spacing: 16) {
            Image(systemName: getEmptyStateIcon(for: status))
                .font(.system(size: 40, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            Text(getEmptyStateText(for: status))
                .font(AppFonts.medium(16))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            if hasActiveFilters {
                Button("Reset Filters") {
                    resetFilters()
                }
                .font(AppFonts.medium(14))
                .foregroundColor(AppColors.yellow)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
    
    private var hasActiveFilters: Bool {
        !selectedTags.isEmpty || dateRange != .all
    }
    
    private func getDreamCount(for segment: Int) -> Int {
        let status: DreamStatus
        switch segment {
        case 0: status = .waiting
        case 1: status = .fulfilled
        case 2: status = .notFulfilled
        default: return 0
        }
        
        return getFilteredDreams(for: status).count
    }
    
    private func getFilteredDreams(for status: DreamStatus) -> [Dream] {
        var dreams = dataManager.getDreamsByStatus(status)
        
        if !selectedTags.isEmpty {
            dreams = dreams.filter { dream in
                !Set(dream.tags).isDisjoint(with: selectedTags)
            }
        }
        
        dreams = applyDateFilter(to: dreams)
        
        return dreams
    }
    
    private func applyDateFilter(to dreams: [Dream]) -> [Dream] {
        let calendar = Calendar.current
        let now = Date()
        
        switch dateRange {
        case .all:
            return dreams
        case .week:
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            return dreams.filter { dream in
                let dateToCheck = dateFilterType == .dreamDate ? dream.dreamDate : (dream.outcomeDate ?? dream.dreamDate)
                return dateToCheck >= weekStart
            }
        case .month:
            let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
            return dreams.filter { dream in
                let dateToCheck = dateFilterType == .dreamDate ? dream.dreamDate : (dream.outcomeDate ?? dream.dreamDate)
                return dateToCheck >= monthStart
            }
        case .custom:
            return dreams.filter { dream in
                let dateToCheck = dateFilterType == .dreamDate ? dream.dreamDate : (dream.outcomeDate ?? dream.dreamDate)
                return dateToCheck >= customStartDate && dateToCheck <= customEndDate
            }
        }
    }
    
    private func getEmptyStateIcon(for status: DreamStatus) -> String {
        switch status {
        case .waiting:
            return "clock"
        case .fulfilled:
            return "checkmark.circle"
        case .notFulfilled:
            return "xmark.circle"
        }
    }
    
    private func getEmptyStateText(for status: DreamStatus) -> String {
        if hasActiveFilters {
            return "No dreams match your current filters"
        }
        
        switch status {
        case .waiting:
            return "No dreams awaiting verification"
        case .fulfilled:
            return "No fulfilled dreams yet"
        case .notFulfilled:
            return "No unfulfilled dreams yet"
        }
    }
    
    private func resetFilters() {
        selectedTags = []
        dateRange = .all
        dateFilterType = .dreamDate
    }
    
    private func updateDreamStatus(_ dream: Dream) {
        var updatedDream = dream
        updatedDream.updateStatus(selectedOutcomeStatus, outcomeDate: outcomeDate, comment: outcomeComment.isEmpty ? nil : outcomeComment)
        dataManager.updateDream(updatedDream)
        selectedDream = nil
    }
}

struct WaitingDreamCard: View {
    let dream: Dream
    let onStatusUpdate: (DreamStatus) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dream.title)
                    .font(AppFonts.semiBold(16))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Spacer()
                
                Text(formatDate(dream.dreamDate))
                    .font(AppFonts.regular(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Text(dream.expectedEvent)
                .font(AppFonts.regular(14))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
            
            HStack {
                Text("Deadline: \(formatDate(dream.checkDeadline))")
                    .font(AppFonts.medium(12))
                    .foregroundColor(isOverdue ? AppColors.red : AppColors.yellow)
                
                if isOverdue {
                    Text("OVERDUE")
                        .font(AppFonts.bold(10))
                        .foregroundColor(AppColors.red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.red.opacity(0.2))
                        )
                }
                
                Spacer()
            }
            
            if !dream.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(dream.tags, id: \.self) { tag in
                            Text(tag)
                                .font(AppFonts.regular(10))
                                .foregroundColor(AppColors.backgroundBlue)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(AppColors.yellow.opacity(0.8))
                                )
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    onStatusUpdate(.fulfilled)
                }) {
                    Text("Fulfilled")
                        .font(AppFonts.medium(12))
                        .foregroundColor(AppColors.backgroundBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppColors.green)
                        )
                }
                
                Button(action: {
                    onStatusUpdate(.notFulfilled)
                }) {
                    Text("Not Fulfilled")
                        .font(AppFonts.medium(12))
                        .foregroundColor(AppColors.backgroundBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppColors.red)
                        )
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
    
    private var isOverdue: Bool {
        dream.checkDeadline < Date()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct CompletedDreamCard: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(dream.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text(dream.title)
                        .font(AppFonts.semiBold(16))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(formatDate(dream.dreamDate))
                    .font(AppFonts.regular(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Text(dream.expectedEvent)
                .font(AppFonts.regular(14))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
            
            HStack {
                if let outcomeDate = dream.outcomeDate {
                    Text("Outcome: \(formatDate(outcomeDate))")
                        .font(AppFonts.medium(12))
                        .foregroundColor(dream.status.color)
                }
                
                Spacer()
            }
            
            if let comment = dream.outcomeComment, !comment.isEmpty {
                Text(comment)
                    .font(AppFonts.regular(13))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
            
            if !dream.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(dream.tags, id: \.self) { tag in
                            Text(tag)
                                .font(AppFonts.regular(10))
                                .foregroundColor(AppColors.backgroundBlue)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(AppColors.yellow.opacity(0.8))
                                )
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct SummaryFiltersView: View {
    @Binding var selectedTags: Set<String>
    @Binding var dateFilterType: SummaryView.DateFilterType
    @Binding var dateRange: SummaryView.DateRange
    @Binding var customStartDate: Date
    @Binding var customEndDate: Date
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Button("Reset") {
                        selectedTags = []
                        dateRange = .all
                        dateFilterType = .dreamDate
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Summary Filters")
                        .font(AppFonts.callout.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FilterSection(title: "Date Filter Type") {
                            VStack(spacing: 12) {
                                ForEach(SummaryView.DateFilterType.allCases, id: \.self) { type in
                                    FilterRadioButton(
                                        title: type.rawValue,
                                        isSelected: dateFilterType == type
                                    ) {
                                        dateFilterType = type
                                    }
                                }
                            }
                        }
                        
                        FilterSection(title: "Date Range") {
                            VStack(spacing: 12) {
                                ForEach(SummaryView.DateRange.allCases, id: \.self) { range in
                                    FilterRadioButton(
                                        title: range.rawValue,
                                        isSelected: dateRange == range
                                    ) {
                                        dateRange = range
                                    }
                                }
                                
                                if dateRange == .custom {
                                    VStack(spacing: 12) {
                                        HStack {
                                            Text("From")
                                                .font(AppFonts.callout)
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            DatePicker("", selection: $customStartDate, displayedComponents: .date)
                                                .datePickerStyle(CompactDatePickerStyle())
                                                .colorInvert()
                                        }
                                        
                                        HStack {
                                            Text("To")
                                                .font(AppFonts.callout)
                                                .foregroundColor(AppColors.primaryText)
                                            
                                            DatePicker("", selection: $customEndDate, displayedComponents: .date)
                                                .datePickerStyle(CompactDatePickerStyle())
                                                .colorInvert()
                                        }
                                    }
                                    .padding(.top, 8)
                                }
                            }
                        }
                        
                        FilterSection(title: "Tags") {
                            VStack(spacing: 12) {
                                let availableTags = dataManager.tags.map { $0.name }
                                
                                if availableTags.isEmpty {
                                    Text("No tags available")
                                        .font(AppFonts.regular(14))
                                        .foregroundColor(AppColors.secondaryText)
                                } else {
                                    ForEach(availableTags, id: \.self) { tag in
                                        FilterCheckbox(
                                            title: tag,
                                            isSelected: selectedTags.contains(tag),
                                            color: AppColors.teal
                                        ) {
                                            if selectedTags.contains(tag) {
                                                selectedTags.remove(tag)
                                            } else {
                                                selectedTags.insert(tag)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}
