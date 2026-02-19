import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var reactionsViewModel: ReactionsViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private var calendar = Calendar.current
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var reactionsForSelectedDate: [Reaction] {
        reactionsViewModel.reactions.filter { reaction in
            calendar.isDate(reaction.createdAt, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                calendarContent
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Calendar")
                .font(.ibmPlexMono(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var calendarContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                monthNavigationView
                
                calendarGridView
                
                if !reactionsForSelectedDate.isEmpty {
                    selectedDateReactions
                } else {
                    emptyDateView
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var monthNavigationView: some View {
        HStack {
            Button(action: { changeMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.ibmPlexMono(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: { changeMonth(1) }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 40, height: 40)
                    .background(AppColors.primaryBlue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { index, day in
                    Text(day)
                        .font(.ibmPlexMono(12, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let days = generateDaysForMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        hasReactions: hasReactions(for: date),
                        action: { selectedDate = date }
                    )
                }
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private var selectedDateReactions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reactions on \(formatDate(selectedDate))")
                .font(.ibmPlexMono(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            ForEach(reactionsForSelectedDate) { reaction in
                NavigationLink(destination: ReactionDetailView(reaction: reaction).environmentObject(reactionsViewModel)) {
                    ReactionCard(reaction: reaction)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var emptyDateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50, weight: .medium))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text("No reactions on this day")
                .font(.ibmPlexMono(16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
        
    private func changeMonth(_ direction: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: direction, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func generateDaysForMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstDayOfMonth = monthInterval.start
        let lastDayOfMonth = monthInterval.end - 1
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        let daysInMonth = calendar.dateComponents([.day], from: firstDayOfMonth, to: lastDayOfMonth).day ?? 0
        
        var days: [Date] = []
        
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth),
           let previousMonthInterval = calendar.dateInterval(of: .month, for: previousMonth) {
            let previousMonthLastDay = previousMonthInterval.end - 1
            let daysToAdd = firstWeekday
            
            for i in (0..<daysToAdd).reversed() {
                if let date = calendar.date(byAdding: .day, value: -i, to: firstDayOfMonth) {
                    days.append(date)
                }
            }
        }
        
        for day in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        let remainingDays = 42 - days.count
        for day in 1...remainingDays {
            if let date = calendar.date(byAdding: .day, value: day, to: lastDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasReactions(for date: Date) -> Bool {
        reactionsViewModel.reactions.contains { reaction in
            calendar.isDate(reaction.createdAt, inSameDayAs: date)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
