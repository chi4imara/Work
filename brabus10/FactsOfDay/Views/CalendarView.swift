import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: EventsViewModel
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Calendar")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        CalendarGrid(
                            selectedDate: $selectedDate,
                            viewModel: viewModel
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text(formatSelectedDate(selectedDate))
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(ColorTheme.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            let eventsForDate = viewModel.eventsForDate(selectedDate)
                            
                            if eventsForDate.isEmpty {
                                VStack(spacing: 16) {
                                    Spacer()
                                    
                                    Image(systemName: "calendar.badge.exclamationmark")
                                        .font(.system(size: 40, weight: .light))
                                        .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
                                    
                                    Text("No events recorded for this day.")
                                        .font(.custom("PlayfairDisplay-Regular", size: 16))
                                        .foregroundColor(ColorTheme.textSecondary)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                }
                                .padding(.top, 40)
                                
                                Spacer()
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(eventsForDate) { event in
                                        NavigationLink(destination: EventDetailView(eventId: event.id, viewModel: viewModel)) {
                                            EventCard(event: event)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 120)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func formatSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct CalendarGrid: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: EventsViewModel
    
    @State private var currentMonth = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
                
                Spacer()
                
                Text(monthYearString(currentMonth))
                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                        .foregroundColor(ColorTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let days = generateCalendarDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(days, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        selectedDate: $selectedDate,
                        currentMonth: currentMonth,
                        hasEvents: viewModel.hasEventsForDate(date)
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func generateCalendarDays() -> [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let range = calendar.range(of: .day, in: .month, for: currentMonth) ?? 1..<32
        
        var days: [Date] = []
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth) ?? startOfMonth
        let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth) ?? 1..<32
        
        for i in (firstWeekday - 1)..<7 {
            if i < firstWeekday - 1 {
                let day = previousMonthRange.upperBound - (firstWeekday - 2 - i)
                if let date = calendar.date(byAdding: .day, value: day - 1, to: calendar.startOfDay(for: previousMonth)) {
                    days.append(date)
                }
            }
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        let totalCells = 42 
        let remainingCells = totalCells - days.count
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) ?? startOfMonth
        
        for day in 1...remainingCells {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: nextMonth) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct CalendarDayView: View {
    let date: Date
    @Binding var selectedDate: Date
    let currentMonth: Date
    let hasEvents: Bool
    
    private var isSelected: Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isCurrentMonth: Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        Button(action: { selectedDate = date }) {
            ZStack {
                Circle()
                    .fill(isSelected ? ColorTheme.primaryBlue : Color.clear)
                    .frame(width: 36, height: 36)
                
                if hasEvents && !isSelected {
                    Circle()
                        .fill(ColorTheme.accentYellow.opacity(0.3))
                        .frame(width: 36, height: 36)
                }
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.custom("PlayfairDisplay-Medium", size: 16))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? ColorTheme.primaryBlue :
                        isCurrentMonth ? ColorTheme.textPrimary :
                        ColorTheme.textSecondary.opacity(0.5)
                    )
                
                if hasEvents && !isSelected {
                    Circle()
                        .fill(ColorTheme.accentYellow)
                        .frame(width: 6, height: 6)
                        .offset(x: 12, y: -12)
                }
            }
        }
        .frame(height: 40)
    }
}
