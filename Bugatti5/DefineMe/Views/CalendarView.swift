import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataManager: TermsDataManager
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var termsForSelectedDate: [Term] {
        dataManager.terms.filter { term in
            calendar.isDate(term.dateCreated, inSameDayAs: selectedDate) ||
            calendar.isDate(term.dateModified, inSameDayAs: selectedDate)
        }
    }
    
    private var datesWithTerms: Set<Date> {
        var set = Set<Date>()
        for term in dataManager.terms {
            if let day = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: term.dateCreated) {
                set.insert(day)
            }
            if let day = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: term.dateModified) {
                set.insert(day)
            }
        }
        return set
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Calendar")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        monthNavigation
                        calendarGrid
                        termsListSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private var monthNavigation: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(AppColors.accentYellow)
            }
            
            Spacer()
            
            Text(monthYearString(from: currentMonth))
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let days = daysInMonth()
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        dayCell(for: date)
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func dayCell(for date: Date) -> some View {
        let hasTerms = datesWithTerms.contains(where: { calendar.isDate($0, inSameDayAs: date) })
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isCurrentMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
        
        return Button(action: { selectedDate = date }) {
            Text("\(calendar.component(.day, from: date))")
                .font(.ubuntu(14, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? Color.black : (isCurrentMonth ? AppColors.primaryText : AppColors.secondaryText))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected ? AppColors.accentYellow : (hasTerms ? AppColors.accentYellow.opacity(0.3) : Color.clear))
                )
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
    
    private var termsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Terms on \(selectedDate, style: .date)")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.accentYellow)
            
            if termsForSelectedDate.isEmpty {
                Text("No terms on this day")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                ForEach(termsForSelectedDate.sorted(by: { $0.dateModified > $1.dateModified })) { term in
                    NavigationLink(destination: TermDetailView(termId: term.id, dataManager: dataManager)) {
                        TermRowView(term: term)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private func previousMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func nextMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func daysInMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
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
}

#Preview {
    CalendarView()
        .environmentObject(TermsDataManager())
}
