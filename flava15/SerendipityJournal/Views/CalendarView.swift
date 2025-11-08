import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var meetingStore: MeetingStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var selectedMeeting: Meeting?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Calendar")
                            .font(.theme.title1)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                    }
                    .padding()
                    
                    headerView
                    
                    ScrollView(showsIndicators: false) {
                        calendarGrid
                        
                        selectedDateSection
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedMeeting) { meeting in
                MeetingDetailView(meeting: meeting, meetingStore: meetingStore)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(Color.theme.primaryPurple)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.theme.title2)
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(Color.theme.primaryPurple)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(day)
                        .font(.theme.caption)
                        .foregroundColor(Color.theme.lightText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        meetingsCount: meetingStore.meetingsCountForDate(date)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var selectedDateSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.theme.lightText.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatSelectedDate(selectedDate))
                        .font(.theme.headline)
                        .foregroundColor(Color.theme.primaryText)
                    
                    let meetingsForDate = meetingStore.meetingsForDate(selectedDate)
                    Text("Meetings: \(meetingsForDate.count)")
                        .font(.theme.subheadline)
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            let meetingsForSelectedDate = meetingStore.meetingsForDate(selectedDate)
            
            if meetingsForSelectedDate.isEmpty {
                VStack(spacing: 12) {
                    Text("No meetings for this day")
                        .font(.theme.body)
                        .foregroundColor(Color.theme.lightText)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                    LazyVStack(spacing: 8) {
                        ForEach(meetingsForSelectedDate) { meeting in
                            CalendarMeetingCard(meeting: meeting) {
                                selectedMeeting = meeting
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
            }
        }
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let daysToSubtract = (monthFirstWeekday + 5) % 7 
        
        guard let firstDayOfCalendar = calendar.date(byAdding: .day, value: -daysToSubtract, to: monthInterval.start) else {
            return []
        }
        
        var days: [Date] = []
        for i in 0..<42 {
            if let day = calendar.date(byAdding: .day, value: i, to: firstDayOfCalendar) {
                days.append(day)
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func formatSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isCurrentMonth: Bool
    let isSelected: Bool
    let meetingsCount: Int
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.theme.subheadline)
                    .foregroundColor(textColor)
                
                if meetingsCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.theme.primaryBlue)
                            .frame(width: 16, height: 16)
                        
                        Text("\(meetingsCount)")
                            .font(.theme.caption2)
                            .foregroundColor(.white)
                    }
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 16, height: 16)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
                    }
            )
        }
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return Color.theme.lightText.opacity(0.5)
        } else if isSelected {
            return Color.theme.primaryText
        } else {
            return Color.theme.primaryText
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.theme.primaryBlue.opacity(0.1)
        } else if meetingsCount > 0 {
            return Color.theme.accentTeal.opacity(0.1)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        isSelected ? Color.theme.primaryBlue : Color.clear
    }
}

struct CalendarMeetingCard: View {
    let meeting: Meeting
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meeting.title)
                        .font(.theme.subheadline)
                        .foregroundColor(Color.theme.primaryText)
                        .lineLimit(1)
                    
                    Text(meeting.shortDescription)
                        .font(.theme.caption)
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(meeting.formattedTime)
                        .font(.theme.caption)
                        .foregroundColor(Color.theme.primaryBlue)
                    
                    if let location = meeting.location, !location.isEmpty {
                        Text(location)
                            .font(.theme.caption2)
                            .foregroundColor(Color.theme.accentTeal)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.8))
                    .shadow(color: Color.theme.shadowColor, radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CalendarView()
        .environmentObject(MeetingStore())
}
