import SwiftUI

struct OutfitDetailItem: Identifiable {
    let id: UUID
}

struct CalendarView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var selectedOutfitItem: OutfitDetailItem?
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Calendar")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        monthHeader
                        
                        calendarGrid
                        
                        selectedDateOutfits
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .sheet(item: $selectedOutfitItem) { item in
            OutfitDetailView(outfitId: item.id, viewModel: viewModel)
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(8)
                    .background(ColorManager.cardBackground)
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.playfairDisplay(22, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(8)
                    .background(ColorManager.cardBackground)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(ColorManager.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        isToday: calendar.isDateInToday(date),
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        hasOutfit: hasOutfit(for: date),
                        outfitCount: outfitCount(for: date),
                        onTap: {
                            selectedDate = date
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var selectedDateOutfits: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Outfits for \(selectedDateString)")
                    .font(.playfairDisplay(20, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                if !outfitsForSelectedDate.isEmpty {
                    Text("\(outfitsForSelectedDate.count) \(outfitsForSelectedDate.count == 1 ? "outfit" : "outfits")")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if outfitsForSelectedDate.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Text("No outfits for this date")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(outfitsForSelectedDate) { outfit in
                        Button(action: {
                            selectedOutfitItem = OutfitDetailItem(id: outfit.id)
                        }) {
                            CalendarOutfitCard(outfit: outfit)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
        
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        var symbols = Array(formatter.shortWeekdaySymbols)
        let sunday = symbols.removeFirst()
        symbols.append(sunday)
        return symbols
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let firstDayOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysToSubtract = (firstDayWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstDayOfMonth) else {
            return []
        }
        
        var days: [Date] = []
        var currentDate = startDate
        
        for _ in 0..<42 {
            days.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return days
    }
    
    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }
    
    private var outfitsForSelectedDate: [OutfitEntry] {
        viewModel.outfits.filter { outfit in
            calendar.isDate(outfit.date, inSameDayAs: selectedDate)
        }.sorted { $0.date > $1.date }
    }
        
    private func hasOutfit(for date: Date) -> Bool {
        viewModel.outfits.contains { outfit in
            calendar.isDate(outfit.date, inSameDayAs: date)
        }
    }
    
    private func outfitCount(for date: Date) -> Int {
        viewModel.outfits.filter { outfit in
            calendar.isDate(outfit.date, inSameDayAs: date)
        }.count
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
}

struct CalendarDayView: View {
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    let isSelected: Bool
    let hasOutfit: Bool
    let outfitCount: Int
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.playfairDisplay(16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(dayTextColor)
                
                if hasOutfit {
                    HStack(spacing: 2) {
                        ForEach(0..<min(outfitCount, 3), id: \.self) { _ in
                            Circle()
                                .fill(hasOutfit ? ColorManager.accentYellow : Color.clear)
                                .frame(width: 4, height: 4)
                        }
                        
                        if outfitCount > 3 {
                            Text("+\(outfitCount - 3)")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(ColorManager.accentYellow)
                        }
                    }
                    .frame(height: 8)
                } else {
                    Spacer()
                        .frame(height: 8)
                }
            }
            .frame(width: 44, height: 60)
            .background(dayBackgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? ColorManager.primaryText : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dayTextColor: Color {
        if !isCurrentMonth {
            return ColorManager.neutralGray.opacity(0.4)
        } else if isToday {
            return .white
        } else if isSelected {
            return ColorManager.primaryText
        } else {
            return ColorManager.primaryText
        }
    }
    
    private var dayBackgroundColor: Color {
        if isToday {
            return ColorManager.primaryText
        } else if isSelected {
            return ColorManager.accentYellow.opacity(0.2)
        } else if hasOutfit {
            return ColorManager.cardBackground
        } else {
            return Color.clear
        }
    }
}

struct CalendarOutfitCard: View {
    let outfit: OutfitEntry
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                Text(timeString)
                    .font(.playfairDisplay(12, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(outfit.comfort)/10")
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(ColorManager.accentYellow)
            }
            .frame(width: 50)
            .padding(.vertical, 8)
            .background(ColorManager.accentYellow.opacity(0.15))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(outfit.shortDescription)
                    .font(.playfairDisplay(15, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: outfit.mood.icon)
                            .font(.system(size: 12))
                            .foregroundColor(outfit.mood.color)
                        Text(outfit.mood.rawValue)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(outfit.mood.color)
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(outfit.reaction.color)
                            .frame(width: 6, height: 6)
                        Text(outfit.reaction.rawValue)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(12)
        .background(ColorManager.cardGradient)
        .cornerRadius(12)
        .shadow(color: ColorManager.purpleDark.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: outfit.date)
    }
}

#Preview {
    CalendarView(viewModel: OutfitViewModel())
}
