import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: DrinkViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        monthHeader
                        
                        calendarGrid
                        
                        drinksForSelectedDate
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(ColorTheme.primaryYellow)
            }
            
            Spacer()
            
            Text(monthYearString)
                .font(.playfair(22, weight: .semibold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(ColorTheme.primaryYellow)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            weekdaysHeader
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    DayCell(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
                        hasDrinks: hasDrinksOnDate(date),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var weekdaysHeader: some View {
        HStack(spacing: 0) {
            ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                Text(day)
                    .font(.playfair(14, weight: .semibold))
                    .foregroundColor(ColorTheme.textTertiary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private var drinksForSelectedDate: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedDateString)
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(.horizontal, 20)
            
            let drinks = drinksOnDate(selectedDate)
            
            if drinks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 50))
                        .foregroundColor(ColorTheme.textTertiary.opacity(0.6))
                    
                    Text("No drinks added on this date")
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(drinks) { drink in
                            NavigationLink(destination: DrinkDetailView(drinkId: drink.id, viewModel: viewModel)) {
                                DrinkCardView(drink: drink)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let firstDayOfMonth = monthInterval.start.dayStart,
              let lastDayOfMonth = monthInterval.end.dayStart else {
            return []
        }
        
        let firstDayWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        let daysToAdd = (firstDayWeekday - 1) % 7
        
        var days: [Date] = []
        
        if let startDate = Calendar.current.date(byAdding: .day, value: -daysToAdd, to: firstDayOfMonth) {
            var currentDate = startDate
            while currentDate < lastDayOfMonth || Calendar.current.isDate(currentDate, equalTo: lastDayOfMonth, toGranularity: .month) {
                days.append(currentDate)
                if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = nextDate
                } else {
                    break
                }
            }
        }
        
        return days
    }
    
    private func hasDrinksOnDate(_ date: Date) -> Bool {
        viewModel.drinks.contains { drink in
            Calendar.current.isDate(drink.dateAdded, inSameDayAs: date)
        }
    }
    
    private func drinksOnDate(_ date: Date) -> [Drink] {
        viewModel.drinks.filter { drink in
            Calendar.current.isDate(drink.dateAdded, inSameDayAs: date)
        }
    }
    
    private func previousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasDrinks: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(.playfair(16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(textColor)
                
                if hasDrinks {
                    Circle()
                        .fill(ColorTheme.primaryPink)
                        .frame(width: 6, height: 6)
                } else {
                    Spacer()
                        .frame(height: 6)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? ColorTheme.primaryYellow : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return ColorTheme.textTertiary.opacity(0.4)
        } else if isSelected {
            return ColorTheme.buttonText
        } else if isToday {
            return ColorTheme.primaryYellow
        } else {
            return ColorTheme.textSecondary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return ColorTheme.buttonBackground
        } else if isToday {
            return ColorTheme.primaryYellow.opacity(0.2)
        } else {
            return Color.clear
        }
    }
}

extension Date {
    var dayStart: Date? {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
}

#Preview {
    CalendarView(viewModel: DrinkViewModel())
}
