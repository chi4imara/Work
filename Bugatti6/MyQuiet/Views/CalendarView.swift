import SwiftUI

private struct CalendarPrincipleDestination: Identifiable {
    var id: UUID { principleId }
    let principleId: UUID
}

struct CalendarView: View {
    @ObservedObject var viewModel: PrinciplesViewModel
    @State private var selectedMonth: Date = Date()
    @State private var selectedDate: Date?
    @State private var selectedDetailDestination: CalendarPrincipleDestination?
    @State private var animateItems = false
    
    private let calendar = Calendar.current
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: selectedMonth)
    }
    
    private var daysInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)) else {
            return []
        }
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let leadingBlanks = firstWeekday - 1
        var days: [Date?] = Array(repeating: nil, count: leadingBlanks)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        return days
    }
    
    private func principles(for date: Date) -> [Principle] {
        viewModel.principles.filter { principle in
            calendar.isDate(principle.createdAt, inSameDayAs: date) ||
            (principle.updatedAt != principle.createdAt && calendar.isDate(principle.updatedAt, inSameDayAs: date))
        }
    }
    
    private func hasPrinciples(on date: Date) -> Bool {
        !principles(for: date).isEmpty
    }
    
    private var monthPrinciples: [Principle] {
        viewModel.principles.filter {
            calendar.isDate($0.createdAt, equalTo: selectedMonth, toGranularity: .month) ||
            ($0.updatedAt != $0.createdAt && calendar.isDate($0.updatedAt, equalTo: selectedMonth, toGranularity: .month))
        }
    }
    
    private var monthActivityDaysCount: Int {
        var activityDays: Set<Date> = []
        for p in monthPrinciples {
            activityDays.insert(calendar.startOfDay(for: p.createdAt))
            if p.updatedAt != p.createdAt {
                activityDays.insert(calendar.startOfDay(for: p.updatedAt))
            }
        }
        return activityDays.count
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.15)
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        calendarGridView
                        
                        if let date = selectedDate {
                            principlesForSelectedDateView(date: date)
                        } else {
                            monthSummaryView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: $selectedDetailDestination) { destination in
            PrincipleDetailView(principleId: destination.principleId, viewModel: viewModel)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateItems = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Calendar")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.appTextBlue)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.appTextBlue)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text(monthTitle)
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.appTextBlue)
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.appTextBlue)
                        .frame(width: 44, height: 44)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.playfairDisplay(11, weight: .medium))
                        .foregroundColor(Color.appDarkGray.opacity(0.7))
                }
                
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date = date {
                        CalendarDayCell(
                            date: date,
                            isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false,
                            hasPrinciples: hasPrinciples(on: date),
                            isToday: calendar.isDateInToday(date)
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: Color.appTextBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(animateItems ? 1.0 : 0.95)
            .opacity(animateItems ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.5), value: animateItems)
        }
    }
    
    private func principlesForSelectedDateView(date: Date) -> some View {
        let items = principles(for: date)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(formatter.string(from: date))
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(Color.appTextBlue)
                Spacer()
                if items.isEmpty {
                    Text("No principles")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.appDarkGray.opacity(0.7))
                }
            }
            
            if items.isEmpty {
                Text("No principles were created or updated on this day.")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(Color.appDarkGray)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appLightGray.opacity(0.5))
                    )
            } else {
                ForEach(items) { principle in
                    Button(action: { selectedDetailDestination = CalendarPrincipleDestination(principleId: principle.id) }) {
                        HStack {
                            Text(principle.shortDisplayText)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(Color.appTextBlue)
                                .lineLimit(2)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color.appDarkGray.opacity(0.6))
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardGradient)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var monthSummaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This month")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.appTextBlue)
            
            HStack(spacing: 16) {
                StatCard(title: "Created/Updated", value: "\(monthPrinciples.count)", icon: "doc.text")
                StatCard(title: "Days with activity", value: "\(monthActivityDaysCount)", icon: "calendar")
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newMonth
            selectedDate = nil
        }
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let hasPrinciples: Bool
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
                if isSelected {
                    Circle()
                        .fill(AppColors.buttonGradient)
                } else if isToday {
                    Circle()
                        .stroke(Color.appTextBlue, lineWidth: 2)
                }
                
                Text(dayNumber)
                    .font(.playfairDisplay(14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .white : (hasPrinciples ? Color.appTextBlue : Color.appDarkGray))
                
                if hasPrinciples && !isSelected {
                    Circle()
                        .fill(Color.appAccentYellow)
                        .frame(width: 5, height: 5)
                        .offset(x: 10, y: -10)
                }
            }
            .frame(height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color.appAccentYellow)
                Text(title)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(Color.appDarkGray.opacity(0.8))
            }
            Text(value)
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(Color.appTextBlue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: Color.appTextBlue.opacity(0.08), radius: 6, x: 0, y: 2)
        )
    }
}

#Preview {
    CalendarView(viewModel: PrinciplesViewModel())
}
