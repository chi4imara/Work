import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: RitualViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.appTitle())
                        .foregroundColor(AppColors.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        monthHeader
                        
                        calendarGrid
                        
                        selectedDateInfo
                        
                        if !ritualsForSelectedDate.isEmpty {
                            ritualsListForDate
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Button(action: {
                withAnimation {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.textWhite)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text(currentMonth, format: .dateTime.month(.wide).year())
                .font(.appHeadline())
                .foregroundColor(AppColors.textWhite)
                .textCase(.uppercase)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.textWhite)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            weekdaysHeader
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        isToday: Calendar.current.isDateInToday(date),
                        completionCount: completionCount(for: date),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedDate = date
                        }
                    }
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var weekdaysHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.appCaption())
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 12)
    }
    
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.shortWeekdaySymbols
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstDayOfMonth = monthInterval.start
        let lastDayOfMonth = monthInterval.end
        
        let firstWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        let adjustedFirstWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1
        
        var days: [Date] = []
        
        let daysToSubtract = adjustedFirstWeekday - 1
        if let startDate = Calendar.current.date(byAdding: .day, value: -daysToSubtract, to: firstDayOfMonth) {
            let totalDays = Calendar.current.dateComponents([.day], from: firstDayOfMonth, to: lastDayOfMonth).day ?? 0
            let weeksToShow = Int(ceil(Double(totalDays + daysToSubtract) / 7.0))
            let totalCells = weeksToShow * 7
            
            for i in 0..<totalCells {
                if let date = Calendar.current.date(byAdding: .day, value: i, to: startDate) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func completionCount(for date: Date) -> Int {
        let dayStart = Calendar.current.startOfDay(for: date)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
        
        return viewModel.rituals.reduce(0) { total, ritual in
            let count = ritual.completionDates.filter { date in
                date >= dayStart && date < dayEnd
            }.count
            return total + count
        }
    }
    
    private var selectedDateInfo: some View {
        let count = completionCount(for: selectedDate)
        
        return VStack(spacing: 12) {
            Text(selectedDate, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(.appHeadline())
                .foregroundColor(AppColors.textWhite)
            
            if count > 0 {
                Text("\(count) ritual\(count == 1 ? "" : "s") completed")
                    .font(.appBody())
                    .foregroundColor(AppColors.textSecondary)
            } else {
                Text("No rituals completed")
                    .font(.appBody())
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
    
    private var ritualsForSelectedDate: [Ritual] {
        let dayStart = Calendar.current.startOfDay(for: selectedDate)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
        
        return viewModel.rituals.filter { ritual in
            ritual.completionDates.contains { date in
                date >= dayStart && date < dayEnd
            }
        }
    }
    
    private var ritualsListForDate: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Rituals")
                .font(.appHeadline())
                .foregroundColor(AppColors.textWhite)
                .padding(.horizontal, 4)
            
            ForEach(ritualsForSelectedDate) { ritual in
                HStack {
                    Circle()
                        .fill(AppColors.accentPurple)
                        .frame(width: 8, height: 8)
                    
                    Text(ritual.title)
                        .font(.appBody())
                        .foregroundColor(AppColors.textWhite)
                    
                    Spacer()
                }
                .padding()
                .background(AppColors.buttonBackground)
                .cornerRadius(10)
            }
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let completionCount: Int
    let isCurrentMonth: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.appBody())
                .foregroundColor(isCurrentMonth ? (isSelected ? AppColors.textWhite : AppColors.textWhite) : AppColors.textSecondary.opacity(0.5))
            
            if completionCount > 0 {
                HStack(spacing: 2) {
                    ForEach(0..<min(completionCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(isSelected ? AppColors.textWhite : AppColors.accentPurple)
                            .frame(width: 4, height: 4)
                    }
                    if completionCount > 3 {
                        Text("+")
                            .font(.system(size: 8))
                            .foregroundColor(isSelected ? AppColors.textWhite : AppColors.accentPurple)
                    }
                }
            }
        }
        .frame(width: 44, height: 60)
        .background(
            Group {
                if isSelected {
                    AppColors.accentPurple
                } else if isToday {
                    AppColors.accentPurple.opacity(0.3)
                } else {
                    Color.clear
                }
            }
        )
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday && !isSelected ? AppColors.accentPurple : Color.clear, lineWidth: 2)
        )
    }
}

extension Date {
    var dayOfWeek: Int? {
        let weekday = Calendar.current.component(.weekday, from: self)
        return weekday == 1 ? 7 : weekday - 1
    }
}
