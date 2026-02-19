import SwiftUI

struct CalendarView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    
    private let calendar = Calendar.current
    private let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]
    
    private var ideasForSelectedDate: [GiftIdea] {
        dataManager.getIdeas(for: selectedDate)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }
    
    private var daysInGrid: [CalendarDay] {
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        let range = calendar.range(of: .day, in: .month, for: start)!
        let firstWeekday = calendar.component(.weekday, from: start) - 1
        let daysInMonth = range.count
        
        var days: [CalendarDay] = []
        
        for _ in 0..<firstWeekday {
            days.append(CalendarDay(date: nil, isCurrentMonth: false, hasIdeas: false))
        }
        
        for day in 1...daysInMonth {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: start) else { continue }
            days.append(CalendarDay(
                date: date,
                isCurrentMonth: true,
                hasIdeas: dataManager.hasIdeas(on: date)
            ))
        }
        
        let remainder = 42 - days.count
        for _ in 0..<remainder {
            days.append(CalendarDay(date: nil, isCurrentMonth: false, hasIdeas: false))
        }
        
        return days
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: previousMonth) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.appAccent)
                                        .frame(width: 44, height: 44)
                                }
                                
                                Spacer()
                                
                                Text(monthYearString)
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(.appTextPrimary)
                                
                                Spacer()
                                
                                Button(action: nextMonth) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.appAccent)
                                        .frame(width: 44, height: 44)
                                }
                            }
                            .padding(.horizontal, 8)
                            
                            Button(action: {
                                selectedDate = Date()
                                displayedMonth = Date()
                            }) {
                                Text("Today")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(.appAccent)
                            }
                            .padding(.vertical, 4)
                            
                            HStack(spacing: 0) {
                                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                                    Text(symbol)
                                        .font(.ubuntu(12, weight: .medium))
                                        .foregroundColor(.appTextSecondary)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
                                ForEach(Array(daysInGrid.enumerated()), id: \.offset) { _, day in
                                    DayCell(
                                        day: day,
                                        selectedDate: $selectedDate,
                                        displayedMonth: displayedMonth
                                    )
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appCard)
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(formattedSelectedDate)
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(.appTextPrimary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            if ideasForSelectedDate.isEmpty {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 12) {
                                        Image(systemName: "lightbulb")
                                            .font(.system(size: 40))
                                            .foregroundColor(.appTextSecondary)
                                        Text("No ideas added on this date.")
                                            .font(.ubuntu(14))
                                            .foregroundColor(.appTextSecondary)
                                    }
                                    .padding(.vertical, 32)
                                    Spacer()
                                }
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(ideasForSelectedDate) { idea in
                                        NavigationLink(destination: ViewIdeaView(ideaId: idea.id, personId: idea.personId)) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(idea.text)
                                                        .font(.ubuntu(16))
                                                        .foregroundColor(.appTextPrimary)
                                                        .multilineTextAlignment(.leading)
                                                        .lineLimit(2)
                                                    Text("for \(dataManager.getPersonName(for: idea.personId))")
                                                        .font(.ubuntu(12))
                                                        .foregroundColor(.appTextSecondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.appTextSecondary)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.appCard)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }
    
    private func previousMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
    
    private func nextMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
}

struct CalendarDay {
    let date: Date?
    let isCurrentMonth: Bool
    let hasIdeas: Bool
}

struct DayCell: View {
    let day: CalendarDay
    @Binding var selectedDate: Date
    let displayedMonth: Date
    
    private let calendar = Calendar.current
    
    private var dayNumber: String {
        guard let date = day.date else { return "" }
        let comp = calendar.component(.day, from: date)
        return "\(comp)"
    }
    
    private var isSelected: Bool {
        guard let date = day.date else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isToday: Bool {
        guard let date = day.date else { return false }
        return calendar.isDateInToday(date)
    }
    
    var body: some View {
        Group {
            if let date = day.date {
                Button(action: {
                    selectedDate = date
                }) {
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(Color.appAccent)
                        }
                        if isToday && !isSelected {
                            Circle()
                                .stroke(Color.appAccent, lineWidth: 2)
                        }
                        
                        Text(dayNumber)
                            .font(.ubuntu(14, weight: isSelected ? .bold : .medium))
                            .foregroundColor(foregroundColor)
                        
                        if day.hasIdeas && !isSelected {
                            VStack {
                                Spacer()
                                Circle()
                                    .fill(Color.appAccent)
                                    .frame(width: 4, height: 4)
                                    .padding(.bottom, 4)
                            }
                            .frame(height: 36)
                        }
                    }
                    .frame(height: 36)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!day.isCurrentMonth)
            } else {
                Text("")
                    .frame(height: 36)
            }
        }
        .frame(maxWidth: .infinity)
        .opacity(day.isCurrentMonth ? 1 : 0.35)
    }
    
    private var foregroundColor: Color {
        if isSelected {
            return .appTextPrimary
        }
        return day.isCurrentMonth ? .appTextPrimary : .appTextSecondary
    }
}

#Preview {
    CalendarView()
}
