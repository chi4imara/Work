import SwiftUI

struct CalendarView: View {
    @ObservedObject var eventStore: EventStore
    @State private var showingAddEvent = false
    @State private var showingFilterMenu = false
    @State private var showingSortMenu = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                CalendarHeaderView(
                    eventStore: eventStore,
                    showingAddEvent: $showingAddEvent,
                    showingFilterMenu: $showingFilterMenu,
                    showingSortMenu: $showingSortMenu
                )
                .padding(.bottom, 12)
                
                ScrollView {
                    CalendarGridView(eventStore: eventStore)
                        .padding(.bottom, -35)
                    
                    SelectedDateEventsView(eventStore: eventStore, showingAddEvent: $showingAddEvent)
                        .padding(.bottom, 100)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showingAddEvent) {
            AddEditEventView(eventStore: eventStore)
        }
        .sheet(isPresented: $showingFilterMenu) {
            FilterSheetView(eventStore: eventStore)
        }
    }
    
}

struct CalendarHeaderView: View {
    @ObservedObject var eventStore: EventStore
    @Binding var showingAddEvent: Bool
    @Binding var showingFilterMenu: Bool
    @Binding var showingSortMenu: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Holiday Calendar")
                    .font(FontManager.title)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: { showingAddEvent = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.accent)
                }
                
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.accent)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.accent)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: eventStore.selectedMonth)
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            eventStore.selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: eventStore.selectedMonth) ?? eventStore.selectedMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            eventStore.selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: eventStore.selectedMonth) ?? eventStore.selectedMonth
        }
    }
}

struct CalendarGridView: View {
    @ObservedObject var eventStore: EventStore
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(FontManager.small)
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        eventStore: eventStore,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: eventStore.selectedDate),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: eventStore.selectedMonth, toGranularity: .month)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            eventStore.selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: eventStore.selectedMonth)?.start ?? eventStore.selectedMonth
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        for i in 0..<42 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(day)
            }
        }
        return days
    }
}

struct CalendarDayView: View {
    let date: Date
    @ObservedObject var eventStore: EventStore
    let isSelected: Bool
    let isCurrentMonth: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(FontManager.small)
                .foregroundColor(textColor)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(backgroundColor)
                        .overlay(
                            Circle()
                                .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
                        )
                )
            
            HStack(spacing: 2) {
                ForEach(eventIcons.prefix(3), id: \.self) { icon in
                    Image(systemName: icon)
                        .font(.system(size: 6))
                        .foregroundColor(AppColors.accent)
                }
                
                if eventIcons.count > 3 {
                    Text("+\(eventIcons.count - 3)")
                        .font(.system(size: 6, weight: .bold))
                        .foregroundColor(AppColors.accent)
                }
            }
            .frame(height: 8)
        }
        .frame(height: 50)
    }
    
    private var textColor: Color {
        if isSelected {
            return AppColors.background
        } else if isCurrentMonth {
            return Calendar.current.isDateInToday(date) ? AppColors.accent : AppColors.secondaryText
        } else {
            return AppColors.secondaryText.opacity(0.3)
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.accent
        } else if Calendar.current.isDateInToday(date) {
            return AppColors.accent.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        isSelected ? AppColors.accent : Color.clear
    }
    
    private var eventIcons: [String] {
        let events = eventStore.eventsForDate(date)
        return events.map { $0.type.icon }
    }
}

struct SelectedDateEventsView: View {
    @ObservedObject var eventStore: EventStore
    @Binding var showingAddEvent: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Events for \(dateString)")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            if eventsForSelectedDate.isEmpty {
                EmptyEventsView(showingAddEvent: $showingAddEvent)
            } else {
                    LazyVStack(spacing: 12) {
                        ForEach(eventsForSelectedDate) { event in
                            EventCardView(event: event, eventStore: eventStore)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
        )
        .padding(.top, 20)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: eventStore.selectedDate)
    }
    
    private var eventsForSelectedDate: [Event] {
        eventStore.eventsForDate(eventStore.selectedDate)
    }
}

struct EmptyEventsView: View {
    @Binding var showingAddEvent: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(AppColors.accent.opacity(0.5))
            
            Text("No events scheduled for this date")
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("Add Event") {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                
                showingAddEvent = true
            }
            .font(FontManager.subheadline)
            .foregroundColor(AppColors.background)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.accent)
            .cornerRadius(20)
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.1), value: showingAddEvent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    CalendarView(eventStore: EventStore())
}
