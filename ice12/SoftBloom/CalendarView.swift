import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var activeSheet: SheetIdentifier?
    @State private var showingClearAlert = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(.primaryPurple)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        headerView
                        
                        calendarGrid
                        
                        todaySection
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            if case .menu = sheet {
                menuSheet
            }
        }
        .alert("Clear Month", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearMonth(viewModel.currentMonth)
            }
        } message: {
            Text("Are you sure you want to delete all entries for \(dateFormatter.string(from: viewModel.currentMonth))?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.accentBlue)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: viewModel.currentMonth))
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(.primaryPurple)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.accentBlue)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .overlay(
            HStack {
                Spacer()
                Button(action: { activeSheet = .menu }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.accentBlue)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .offset(x: 60)
            }
        )
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(day)
                        .font(.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(.darkGray)
                        .frame(width: 40, height: 40)
                        .multilineTextAlignment(.center)
                }
            }
            
            let days = getDaysInMonth()
            let weeks = days.chunked(into: 7)
            
            ForEach(0..<weeks.count, id: \.self) { weekIndex in
                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { dayIndex in
                        if weekIndex * 7 + dayIndex < days.count {
                            let date = days[weekIndex * 7 + dayIndex]
                            CalendarDayView(
                                date: date,
                                hasEntry: viewModel.hasEntry(for: date),
                                isToday: calendar.isDateInToday(date),
                                isCurrentMonth: calendar.isDate(date, equalTo: viewModel.currentMonth, toGranularity: .month)
                            ) {
                                dayTapped(date)
                            }
                        } else {
                            Color.clear
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var todaySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today")
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(.primaryPurple)
                Spacer()
            }
            
            if let todayEntry = viewModel.getEntry(for: Date()) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(todayEntry.shortText)
                            .font(.playfairDisplay(size: 16))
                            .foregroundColor(.darkGray)
                            .lineLimit(2)
                        
                        Text("Tap to view full entry")
                            .font(.playfairDisplay(size: 12))
                            .foregroundColor(.accentBlue)
                    }
                    
                    Spacer()
                    
                    Button("Open") {
                        NotificationCenter.default.post(name: .showGratitudeDetail, object: Date())
                    }
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.accentBlue)
                    .cornerRadius(8)
                }
            } else {
                VStack(spacing: 12) {
                    Text(hasEntriesThisMonth() ? "Today there is no gratitude yet" : "This month is still empty. Start with today")
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(.darkGray)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        NotificationCenter.default.post(name: .showGratitudeEntry, object: Date())
                    } label: {
                        Text("Write")
                            .font(.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.accentYellow)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var menuSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("History") {
                    activeSheet = nil
                    NotificationCenter.default.post(name: .switchToHistoryTab, object: nil)
                }
                .menuButtonStyle()
                
                Button("Statistics") {
                    activeSheet = nil
                    NotificationCenter.default.post(name: .switchToStatisticsTab, object: nil)
                }
                .menuButtonStyle()
                
                Button("Clear Month...") {
                    activeSheet = nil
                    showingClearAlert = true
                }
                .menuButtonStyle(color: .red)
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { activeSheet = nil }
                }
            }
        }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.currentMonth = calendar.date(byAdding: .month, value: -1, to: viewModel.currentMonth) ?? viewModel.currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.currentMonth = calendar.date(byAdding: .month, value: 1, to: viewModel.currentMonth) ?? viewModel.currentMonth
        }
    }
    
    private func dayTapped(_ date: Date) {
        if viewModel.hasEntry(for: date) {
            NotificationCenter.default.post(name: .showGratitudeDetail, object: date)
        } else {
            NotificationCenter.default.post(name: .showGratitudeEntry, object: date)
        }
    }
    
    private func getDaysInMonth() -> [Date] {
        let startOfMonth = calendar.dateInterval(of: .month, for: viewModel.currentMonth)?.start ?? viewModel.currentMonth
        let startOfCalendar = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        var currentDate = startOfCalendar
        
        for _ in 0..<42 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func hasEntriesThisMonth() -> Bool {
        return viewModel.entries.contains { entry in
            calendar.isDate(entry.date, equalTo: viewModel.currentMonth, toGranularity: .month)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let hasEntry: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isCurrentMonth ? Color.clear : Color.clear)
                    .frame(width: 40, height: 40)
                
                if isToday {
                    Circle()
                        .stroke(Color.accentBlue, lineWidth: 2)
                        .frame(width: 40, height: 40)
                }
                
                VStack(spacing: 2) {
                    Text(dayNumber)
                        .font(.playfairDisplay(size: 16, weight: isToday ? .bold : .medium))
                        .foregroundColor(isCurrentMonth ? (isToday ? .accentBlue : .darkGray) : .lightGray)
                    
                    if hasEntry && isCurrentMonth {
                        Circle()
                            .fill(Color.accentYellow)
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .disabled(!isCurrentMonth)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension View {
    func menuButtonStyle(color: Color = .accentBlue) -> some View {
        self
            .font(.playfairDisplay(size: 18, weight: .medium))
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.lightGray.opacity(0.3))
            .cornerRadius(12)
    }
}
