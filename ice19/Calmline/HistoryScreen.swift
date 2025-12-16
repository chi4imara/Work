import SwiftUI

struct HistoryScreen: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedTab: Int
    
    @State private var selectedDate: Date?
    @State private var currentMonth = Date()
    @Environment(\.presentationMode) var presentationMode
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                headerSection
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        calendarSection
                        
                        if let selectedDate = selectedDate {
                            dayDetailsSection(for: selectedDate)
                        } else {
                            streakSection
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.shared.primaryPurple)
            }
            .disabled(true)
            .opacity(0)
            
            Spacer()
            
            Text("History")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorManager.shared.primaryBlue)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(ColorManager.shared.primaryPurple)
            }
            .disabled(true)
            .opacity(0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var calendarSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                }
                
                Spacer()
                
                Text(DateFormatter.monthYearFormatter.string(from: currentMonth))
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(day)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorManager.shared.darkGray.opacity(0.6))
                        .frame(height: 30)
                }
                
                ForEach(Array(calendarDays.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            hasEntry: hasEntryForDate(date),
                            isSelected: selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                        ) {
                            selectDate(date)
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(16)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func dayDetailsSection(for date: Date) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let entry = dataManager.getEntryForDate(date) {
                Text(DateFormatter.fullDateFormatter.string(from: date))
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !entry.checkedHabits.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(entry.checkedHabits).sorted(), id: \.self) { habit in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(ColorManager.shared.softGreen)
                                    .font(.system(size: 14))
                                Text(habit)
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(ColorManager.shared.darkGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    Text("\(entry.checkedHabitsCount) mindful steps today")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.shared.primaryPurple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                    
                    if !entry.note.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note:")
                                .font(.ubuntu(14, weight: .bold))
                                .foregroundColor(ColorManager.shared.primaryBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(entry.note)
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(ColorManager.shared.darkGray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineSpacing(2)
                        }
                        .padding(.top, 8)
                    }
                } else {
                    Text("No entries for this day")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.shared.darkGray.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text(DateFormatter.fullDateFormatter.string(from: date))
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("No entries for this day")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.shared.darkGray.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var streakSection: some View {
        VStack(spacing: 16) {
            let stats = dataManager.getStatistics()
            
            if stats.totalDays > 0 {
                VStack(spacing: 12) {
                    if stats.currentStreak > 0 {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(ColorManager.shared.softGreen)
                            Text("Calmness streak: \(stats.currentStreak) days in a row")
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(ColorManager.shared.primaryBlue)
                        }
                    } else {
                        Text("Yesterday was a break. Start a new streak today.")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.shared.primaryPurple)
                    }
                    
                    Text("Total mindful days: \(stats.totalDays)")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.shared.darkGray)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(ColorManager.shared.primaryPurple.opacity(0.6))
                    
                    VStack(spacing: 8) {
                        Text("You haven't marked any day yet.")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorManager.shared.primaryBlue)
                        
                        Text("Start with today — and you'll see how your inner balance grows.")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorManager.shared.darkGray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        withAnimation {
                            selectedTab = 0
                        }
                    } label: {
                        Text("Go to Today")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(ColorManager.shared.primaryYellow)
                            .cornerRadius(16)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(ColorManager.shared.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    
    private var calendarDays: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start ?? monthStart
        
        var days: [Date?] = []
        var currentDate = startOfWeek
        
        while currentDate < monthEnd || days.count % 7 != 0 {
            if currentDate < monthStart || currentDate >= monthEnd {
                days.append(nil)
            } else {
                days.append(currentDate)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func hasEntryForDate(_ date: Date) -> Bool {
        return dataManager.getEntryForDate(date)?.hasAnyChecked ?? false
    }
    
    private func selectDate(_ date: Date) {
        if selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!) {
            selectedDate = nil
        } else {
            selectedDate = date
        }
    }
    
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        selectedDate = nil
    }
    
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        selectedDate = nil
    }
}

struct CalendarDayView: View {
    let date: Date
    let hasEntry: Bool
    let isSelected: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 36, height: 36)
                
                Text("\(calendar.component(.day, from: date))")
                    .font(.ubuntu(14, weight: isSelected ? .bold : .medium))
                    .foregroundColor(textColor)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return ColorManager.shared.primaryPurple
        } else if hasEntry {
            return ColorManager.shared.softGreen
        } else {
            return Color.clear
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if hasEntry {
            return .white
        } else {
            return ColorManager.shared.darkGray
        }
    }
}

extension DateFormatter {
    static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
}


