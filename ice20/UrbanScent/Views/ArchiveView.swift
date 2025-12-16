import SwiftUI

struct ArchiveView: View {
    @ObservedObject var viewModel: ScentViewModel
    @ObservedObject var appViewModel: AppStateViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                calendarSection
                
                if let entry = viewModel.getEntry(for: selectedDate) {
                    selectedEntrySection(entry: entry)
                }
                
                searchSection
                
                if viewModel.entries.isEmpty {
                    emptyStateSection
                } else if !searchText.isEmpty {
                    searchResultsSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
        .onAppear {
            viewModel.searchText = searchText
        }
        .onChange(of: searchText) { newValue in
            viewModel.searchText = newValue
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Archive")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("Your scent diary")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appPrimaryYellow)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Spacer()
                
                Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.appPrimaryYellow)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            
            CalendarGridView(
                currentMonth: currentMonth,
                selectedDate: $selectedDate,
                datesWithEntries: viewModel.getDatesWithEntries()
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appCardBorder, lineWidth: 1)
                )
        )
    }
    
    private func selectedEntrySection(entry: ScentEntry) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Entry for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            ScentEntryCard(entry: entry)
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search by words")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.appTextPrimary)
            
            TextField("Search scents, locations...", text: $searchText)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextPrimary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.appCardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.appCardBorder, lineWidth: 1)
                        )
                )
        }
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search Results")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.searchEntries()) { entry in
                    ScentEntryCard(entry: entry) 
                }
            }
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "book")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appTextTertiary)
            
            Text("No entries yet. Today is a great day to start your scent diary.")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            CustomButton(title: "Return to Today", action: {
                withAnimation {
                    appViewModel.selectedTab = 0
                }
            }, style: .secondary)
        }
        .padding(40)
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

struct CalendarDayItem: Identifiable {
    let id: UUID
    let date: Date?
    
    init(date: Date?) {
        self.id = UUID()
        self.date = date
    }
}

struct CalendarGridView: View {
    let currentMonth: Date
    @Binding var selectedDate: Date
    let datesWithEntries: Set<Date>
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private var dayItems: [CalendarDayItem] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var items: [CalendarDayItem] = []
        
        for _ in 1..<monthFirstWeekday {
            items.append(CalendarDayItem(date: nil))
        }
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                items.append(CalendarDayItem(date: date))
            }
        }
        
        return items
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(.appTextTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(dayItems) { item in
                    if let date = item.date {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasEntry: datesWithEntries.contains(calendar.startOfDay(for: date)),
                            isToday: calendar.isDate(date, inSameDayAs: Date())
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEntry: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isToday ? 2 : 0)
                    )
                
                Text(dateFormatter.string(from: date))
                    .font(.ubuntu(14, weight: isSelected ? .bold : .medium))
                    .foregroundColor(textColor)
                
                if hasEntry {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.appPrimaryYellow)
                                .frame(width: 6, height: 6)
                                .offset(x: -2, y: -2)
                        }
                    }
                }
            }
            .frame(height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.appPrimaryYellow.opacity(0.3)
        } else if hasEntry {
            return Color.appAccentGreen.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        return isToday ? Color.appPrimaryYellow : Color.clear
    }
    
    private var textColor: Color {
        if isSelected {
            return Color.appTextPrimary
        } else {
            return Color.appTextSecondary
        }
    }
}


