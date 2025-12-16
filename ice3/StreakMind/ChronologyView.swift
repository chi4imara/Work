import SwiftUI

struct ChronologyView: View {
    @ObservedObject var habitStore: HabitStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            if habitStore.activeHabits.isEmpty {
                emptyStateView
            } else {
                mainContentView
            }
        }
        .navigationBarHidden(true)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "calendar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No History Yet")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            Text("Start marking days on the streak screen, and your chronology will appear here")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var mainContentView: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                
                calendarView
                
                selectedDayEventsView
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Chronology")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            HStack {
                Button(action: {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    private var calendarView: some View {
        VStack(spacing: 10) {
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textWhite.opacity(0.6))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        dayView(for: date)
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private func dayView(for date: Date) -> some View {
        let dayString = dateFormatter.string(from: date)
        let hasCheckedHabits = habitStore.habits.contains { $0.checkedDates.contains(dayString) }
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDate(date, inSameDayAs: Date())
        let isFuture = date > Date()
        
        return Button(action: {
            selectedDate = date
        }) {
            ZStack {
                Circle()
                    .fill(
                        isSelected ? AppColors.accentYellow :
                        hasCheckedHabits ? AppColors.successGreen.opacity(0.6) :
                        Color.clear
                    )
                    .frame(width: 40, height: 40)
                
                if isToday && !isSelected {
                    Circle()
                        .stroke(AppColors.accentYellow, lineWidth: 2)
                        .frame(width: 40, height: 40)
                }
                
                Text("\(calendar.component(.day, from: date))")
                    .font(.ubuntu(16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(
                        isSelected ? AppColors.primaryPurple :
                        isFuture ? AppColors.textWhite.opacity(0.3) :
                        hasCheckedHabits ? AppColors.textWhite :
                        AppColors.textWhite.opacity(0.7)
                    )
            }
        }
        .disabled(isFuture)
    }
    
    private var eventsForSelectedDay: [(Habit, Bool)] {
        let dayString = dateFormatter.string(from: selectedDate)
        let selectedDateOnly = calendar.startOfDay(for: selectedDate)
        
        return habitStore.habits.compactMap { habit -> (Habit, Bool)? in
            let habitStartDateOnly = calendar.startOfDay(for: habit.startDate)
            let isAfterStart = selectedDateOnly >= habitStartDateOnly
            
            guard isAfterStart else { return nil }
            
            let isChecked = habit.checkedDates.contains(dayString)
            return (habit, isChecked)
        }
    }
    
    private var selectedDayEventsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Events for \(selectedDate, formatter: dayFormatter)")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 10) {
                if eventsForSelectedDay.isEmpty {
                    Text("No events for this day")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textWhite.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } else {
                    ForEach(eventsForSelectedDay, id: \.0.id) { habit, isChecked in
                        eventRowView(habit: habit, isChecked: isChecked)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.textWhite.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private func eventRowView(habit: Habit, isChecked: Bool) -> some View {
        HStack(spacing: 15) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isChecked ? AppColors.successGreen : AppColors.warningRed)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textWhite)
                
                Text(isChecked ? "Day in streak" : "Streak broken")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(isChecked ? AppColors.successGreen : AppColors.warningRed)
            }
            
            Spacer()
            
            Image(systemName: habit.category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(habit.category.color)
        }
        .padding(15)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppColors.textWhite.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var daysInMonth: [Date?] {
        guard let firstOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDays = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
}

#Preview {
    ChronologyView(habitStore: HabitStore())
}
