import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    @State private var currentMonth = Date()
    @State private var selectedDate: Date?
    @State private var selectedEntry: BeautyEntry?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerView
                        
                        calendarGridView
                        
                        if let selectedDate = selectedDate {
                            entriesForSelectedDateView(selectedDate)
                        } else {
                            monthSummaryView
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(viewModel: viewModel, entry: entry)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation {
                        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.theme.primaryBlue)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.theme.primaryBlue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if selectedDate == nil {
                Button(action: {
                    withAnimation {
                        currentMonth = Date()
                        selectedDate = Date()
                    }
                }) {
                    Text("Today")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(Color.theme.secondaryButtonText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.theme.secondaryButtonBackground)
                        .cornerRadius(16)
                }
            } else {
                Button(action: {
                    withAnimation {
                        selectedDate = nil
                    }
                }) {
                    Text("Show Month")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(Color.theme.primaryBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.theme.primaryBlue.opacity(0.1))
                        .cornerRadius(16)
                }
            }
        }
        .padding(.bottom, 16)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(day)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayButtonView(
                        date: date,
                        isSelected: selectedDate != nil && Calendar.current.isDate(date, inSameDayAs: selectedDate!),
                        hasEntries: viewModel.hasEntriesForDate(date),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        isToday: Calendar.current.isDate(date, inSameDayAs: Date())
                    ) {
                        withAnimation {
                            if selectedDate == date {
                                selectedDate = nil
                            } else {
                                selectedDate = date
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    private func entriesForSelectedDateView(_ date: Date) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(date.formatted(style: .long))
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(viewModel.entriesForDate(date).count) entries")
                    .font(.playfairDisplay(14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.entriesForDate(date)) { entry in
                        CalendarEntryCardView(entry: entry) {
                            selectedEntry = entry
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var monthSummaryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Month Summary")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(viewModel.entriesForMonth(currentMonth).count) entries")
                    .font(.playfairDisplay(14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if viewModel.entriesForMonth(currentMonth).isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 50))
                        .foregroundColor(Color.theme.lightGray)
                    
                    Text("No entries this month")
                        .font(.playfairDisplay(18, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("Select a date to view entries or add a new entry in the Diary tab")
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
            } else {
                    LazyVStack(spacing: 12) {
                        ForEach(groupedEntriesByDate, id: \.key) { group in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(group.key)
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(Color.theme.primaryText)
                                    .padding(.horizontal, 16)
                                
                                ForEach(group.value) { entry in
                                    CalendarEntryCardView(entry: entry) {
                                        selectedEntry = entry
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
            }
        }
    }
    
    private var groupedEntriesByDate: [(key: String, value: [BeautyEntry])] {
        let grouped = Dictionary(grouping: viewModel.entriesForMonth(currentMonth)) { entry in
            entry.formattedDate
        }
        return grouped.sorted { entry1, entry2 in
            if let date1 = viewModel.entriesForMonth(currentMonth).first(where: { $0.formattedDate == entry1.key })?.date,
               let date2 = viewModel.entriesForMonth(currentMonth).first(where: { $0.formattedDate == entry2.key })?.date {
                return date1 > date2
            }
            return false
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        for i in 0..<42 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(day)
            }
        }
        return days
    }
}

struct CalendarDayButtonView: View {
    let date: Date
    let isSelected: Bool
    let hasEntries: Bool
    let isCurrentMonth: Bool
    let isToday: Bool
    let action: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isToday && !isSelected {
                    Circle()
                        .stroke(Color.theme.primaryBlue, lineWidth: 2)
                        .frame(width: 38, height: 38)
                } else if isSelected {
                    Circle()
                        .fill(Color.theme.primaryBlue)
                        .frame(width: 38, height: 38)
                }
                
                Text(dayNumber)
                    .font(.playfairDisplay(14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(
                        isSelected ? Color.white :
                        isCurrentMonth ? Color.theme.primaryText : Color.theme.lightGray
                    )
                
                if hasEntries && !isSelected {
                    Circle()
                        .fill(isToday ? Color.theme.primaryBlue : Color.theme.primaryYellow)
                        .frame(width: 6, height: 6)
                        .offset(x: 14, y: -14)
                }
            }
        }
        .frame(height: 44)
    }
}

struct CalendarEntryCardView: View {
    let entry: BeautyEntry
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.procedureName)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(entry.products)
                        .font(.playfairDisplay(13))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(1)
                    
                    if entry.hasNotes {
                        HStack(spacing: 4) {
                            Image(systemName: "note.text")
                                .font(.system(size: 10))
                                .foregroundColor(Color.theme.accentText)
                            
                            Text("Has notes")
                                .font(.playfairDisplay(11))
                                .foregroundColor(Color.theme.accentText)
                        }
                    }
                }
                
                Spacer()
                
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color.theme.accentPink)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(14)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CalendarView(viewModel: BeautyDiaryViewModel())
}
