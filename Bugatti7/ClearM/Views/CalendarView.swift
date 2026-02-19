import SwiftUI

struct CalendarView: View {
    @ObservedObject var eventStore: EventStore
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date?
    @State private var selectedEventDetail: EventDetailSheetItem?
    
    private let calendar = Calendar.current
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    private var daysInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func events(on date: Date) -> [Event] {
        eventStore.events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Calendar")
                            .font(AppFonts.title(32))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    monthNavigation
                    
                    weekdaysHeader
                    
                    daysGrid
                    
                    if let date = selectedDate {
                        eventsSection(for: date)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(item: $selectedEventDetail) { item in
            EventDetailView(eventId: item.eventId, eventStore: eventStore)
        }
    }
    
    private var monthNavigation: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(monthTitle)
                .font(AppFonts.headline(18))
                .foregroundColor(AppColors.primaryWhite)
            
            Spacer()
            
            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var weekdaysHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(AppFonts.caption(11))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
    
    private var daysGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, day in
                if let date = day {
                    DayCellView(
                        date: date,
                        isSelected: selectedDate.map { calendar.isDate(date, inSameDayAs: $0) } ?? false,
                        isToday: calendar.isDateInToday(date),
                        hasEvents: !events(on: date).isEmpty,
                        eventCount: events(on: date).count
                    ) {
                        selectedDate = date
                    }
                } else {
                    Color.clear
                        .frame(height: 44)
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    private func eventsSection(for date: Date) -> some View {
        let dayEvents = events(on: date)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(formattedDay(date))
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            if dayEvents.isEmpty {
                Text("No events on this day")
                    .font(AppFonts.body(14))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(dayEvents) { event in
                    Button(action: {
                        selectedEventDetail = EventDetailSheetItem(eventId: event.id)
                    }) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(AppColors.primaryYellow)
                                .frame(width: 8, height: 8)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(AppFonts.headline(14))
                                    .foregroundColor(AppColors.primaryWhite)
                                    .lineLimit(1)
                                
                                Text(event.shortFormattedDate)
                                    .font(AppFonts.caption(12))
                                    .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.primaryWhite.opacity(0.5))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                                .fill(AppColors.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                                        .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newMonth
            selectedDate = nil
        }
    }
    
    private func formattedDay(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

struct DayCellView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvents: Bool
    let eventCount: Int
    let action: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppColors.primaryYellow : (isToday ? AppColors.primaryWhite.opacity(0.2) : Color.clear))
                
                Text(dayNumber)
                    .font(AppFonts.body(14))
                    .foregroundColor(isSelected ? AppColors.primaryBlack : AppColors.primaryWhite)
                
                if hasEvents && !isSelected {
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 5, height: 5)
                        .offset(x: 14, y: -10)
                }
            }
            .frame(height: 44)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
