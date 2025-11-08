import SwiftUI

struct CalendarView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var tripsForSelectedDate: [Trip] {
        dataManager.getTripsForDate(selectedDate)
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                calendarGrid
                
                selectedDateSection
                
                Spacer()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(FontManager.small)
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            let days = getDaysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(days, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        tripCount: dataManager.getTripsForDate(date).count,
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var selectedDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(formatSelectedDate())
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if tripsForSelectedDate.isEmpty {
                VStack(spacing: 12) {
                    Text("No trips on this date")
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tripsForSelectedDate) { trip in
                            NavigationLink(destination: TripDetailView(trip: trip)) {
                                CalendarTripCardView(trip: trip)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(
            ColorTheme.cardBackground
                .cornerRadius(20, corners: [.topLeft, .topRight])
        )
    }
    
    private func getDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1) else {
            return []
        }
        
        var days: [Date] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
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
    
    private func formatSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: selectedDate)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let tripCount: Int
    let isCurrentMonth: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(FontManager.body)
                    .foregroundColor(textColor)
                
                if tripCount > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "suitcase.fill")
                            .font(.system(size: 8))
                            .foregroundColor(ColorTheme.accent)
                        
                        if tripCount > 1 {
                            Text("+\(tripCount - 1)")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(ColorTheme.accent)
                        }
                    }
                } else {
                    Spacer()
                        .frame(height: 12)
                }
            }
            .frame(width: 40, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? ColorTheme.primaryText : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isSelected {
            return ColorTheme.background
        } else if isCurrentMonth {
            return ColorTheme.secondaryText
        } else {
            return ColorTheme.secondaryText.opacity(0.3)
        }
    }
}

struct CalendarTripCardView: View {
    let trip: Trip
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(trip.locationString)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(trip.dateString)
                    .font(FontManager.small)
                    .foregroundColor(ColorTheme.accent)
                
                if !trip.notes.isEmpty {
                    Text(trip.shortNotes)
                        .font(FontManager.small)
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    CalendarView()
}
