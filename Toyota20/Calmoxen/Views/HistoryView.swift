import SwiftUI

struct HistoryView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel
    var onNavigateToToday: (() -> Void)? = nil
    @State private var selectedDate = Date()
    @State private var showingCalendar = false
    
    private var selectedDateEntries: [HistoryEntry] {
        practiceViewModel.getHistoryForDate(selectedDate)
    }
    
    private var daysWithEntries: Set<Date> {
        practiceViewModel.getDaysWithEntries()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.appTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                dateSelector
                
                if selectedDateEntries.isEmpty {
                    emptyStateView
                } else {
                    entriesListView
                }
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarView(
                selectedDate: $selectedDate,
                daysWithEntries: daysWithEntries,
                onDateSelected: { date in
                    selectedDate = date
                    showingCalendar = false
                }
            )
        }
    }
    
    private var dateSelector: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selected Date")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(selectedDate, style: .date)
                        .font(.cardTitle)
                        .foregroundColor(AppColors.primaryNavy)
                }
                
                Spacer()
                
                Button(action: { showingCalendar = true }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryOrange)
                        .padding(12)
                        .background(AppColors.primaryOrange.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            HStack {
                Button(action: previousDay) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryNavy)
                        .padding(8)
                        .background(AppColors.cardGradient)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button {
                    selectedDate = Date()
                } label: {
                    Text("Today")
                        .font(.buttonText)
                        .foregroundColor(AppColors.primaryOrange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.primaryOrange.opacity(0.1))
                        .cornerRadius(15)
                }
                
                Spacer()
                
                Button(action: nextDay) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryNavy)
                        .padding(8)
                        .background(AppColors.cardGradient)
                        .clipShape(Circle())
                }
            }
            
            if !selectedDateEntries.isEmpty {
                HStack(spacing: 20) {
                    StatPill(
                        title: "Sessions",
                        value: "\(selectedDateEntries.count)",
                        color: AppColors.lightBlue
                    )
                    
                    StatPill(
                        title: "Total Time",
                        value: "\(selectedDateEntries.reduce(0) { $0 + $1.duration }) min",
                        color: AppColors.softGreen
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(AppColors.primaryWhite.opacity(0.8))
        .padding(.horizontal, 20)
    }
    
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(selectedDateEntries.sorted(by: { $0.completedAt > $1.completedAt })) { entry in
                    HistoryEntryCardView(entry: entry)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            VStack(spacing: 12) {
                Text("No practices on this day")
                    .font(.cardTitle)
                    .foregroundColor(AppColors.primaryNavy)
                
                Text("Select a different date or start practicing today!")
                    .font(.bodyText)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if Calendar.current.isDateInToday(selectedDate) {
                Button {
                    onNavigateToToday?()
                } label: {
                    Text("Go to Today's Practices")
                        .font(.buttonText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryOrange)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 30)
    }
    
    private func previousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }
    
    private func nextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    }
}

struct HistoryEntryCardView: View {
    let entry: HistoryEntry
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: entry.completedAt)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: entry.practiceType.icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primaryOrange)
                .frame(width: 40, height: 40)
                .background(AppColors.primaryOrange.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(entry.practiceName)
                        .font(.cardTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Spacer()
                    
                    Text(timeString)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                HStack {
                    Text(entry.practiceType.rawValue)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(AppColors.mediumGray)
                    
                    Text("\(entry.duration) minutes")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(.smallCaption)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(3)
                        .padding(.top, 4)
                }
            }
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.softGreen)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct StatPill: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.playfairBold(size: 18))
                .foregroundColor(color)
            
            Text(title)
                .font(.smallCaption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let daysWithEntries: Set<Date>
    let onDateSelected: (Date) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthYearString: String {
        dateFormatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1)
        else { return [] }
        
        var days: [Date] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        return days
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                        
                        Spacer()
                        
                        Text(monthYearString)
                            .font(.screenTitle)
                            .foregroundColor(AppColors.primaryNavy)
                        
                        Spacer()
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryOrange)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .foregroundColor(AppColors.secondaryText)
                                .frame(height: 30)
                        }
                        
                        ForEach(daysInMonth, id: \.self) { date in
                            CalendarDayView(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                                hasEntry: daysWithEntries.contains(calendar.startOfDay(for: date)),
                                onTap: {
                                    onDateSelected(date)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .background(AppColors.backgroundGradient)
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                }
            }
        }
    }
    
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasEntry: Bool
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ? AppColors.primaryOrange : Color.clear)
                    .frame(width: 35, height: 35)
                
                Text(dayNumber)
                    .font(.bodyText)
                    .foregroundColor(
                        isSelected ? .white :
                        isCurrentMonth ? AppColors.primaryNavy : AppColors.mediumGray
                    )
                
                if hasEntry && !isSelected {
                    Circle()
                        .fill(AppColors.softGreen)
                        .frame(width: 6, height: 6)
                        .offset(x: 12, y: -12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 40)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(practiceViewModel: PracticeViewModel())
    }
}
