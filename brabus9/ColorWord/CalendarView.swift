import SwiftUI

struct CalendarView: View {
    @ObservedObject var catalogViewModel: CatalogViewModel
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    
    private var itemsForSelectedDate: [CatalogItem] {
        let calendar = Calendar.current
        return catalogViewModel.items.filter { item in
            calendar.isDate(item.dateCreated, inSameDayAs: selectedDate)
        }
    }
    
    private var itemsByMonth: [Date: [CatalogItem]] {
        let calendar = Calendar.current
        var grouped: [Date: [CatalogItem]] = [:]
        
        for item in catalogViewModel.items {
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: item.dateCreated)) ?? item.dateCreated
            grouped[monthStart, default: []].append(item)
        }
        
        return grouped
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
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
                        MonthCalendarView(
                            currentMonth: $currentMonth,
                            selectedDate: $selectedDate,
                            items: catalogViewModel.items
                        )
                        .padding(.horizontal, 20)
                        
                        if !itemsForSelectedDate.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Items on \(selectedDate, formatter: dateFormatter)")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 20)
                                
                                ForEach(itemsForSelectedDate) { item in
                                    NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: catalogViewModel)) {
                                        CalendarItemRow(item: item)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppColors.accent)
                                
                                Text("No items on this date")
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.vertical, 40)
                        }
                        
                        MonthStatsView(itemsByMonth: itemsByMonth)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

struct MonthCalendarView: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    let items: [CatalogItem]
    
    private let calendar = Calendar.current
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var monthDays: [Date?] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)!.count
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasItems(for date: Date) -> Bool {
        return items.contains { item in
            calendar.isDate(item.dateCreated, inSameDayAs: date)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.accent)
                }
                
                Spacer()
                
                Text(currentMonth, formatter: monthYearFormatter)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<monthDays.count, id: \.self) { index in
                    if let date = monthDays[index] {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasItems: hasItems(for: date),
                            onTap: {
                                withAnimation {
                                    selectedDate = date
                                }
                            }
                        )
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasItems: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.ubuntu(14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryText)
                
                if hasItems {
                    Circle()
                        .fill(isSelected ? AppColors.buttonText : AppColors.accent)
                        .frame(width: 4, height: 4)
                } else {
                    Color.clear
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppColors.accent : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarItemRow: View {
    let item: CatalogItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
                Text(item.dateCreated, style: .time)
                    .font(.ubuntu(12, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct MonthStatsView: View {
    let itemsByMonth: [Date: [CatalogItem]]
    
    private var sortedMonths: [Date] {
        itemsByMonth.keys.sorted(by: >)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Activity")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            if sortedMonths.isEmpty {
                Text("No activity yet")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.vertical, 20)
            } else {
                ForEach(sortedMonths.prefix(6), id: \.self) { month in
                    HStack {
                        Text(month, formatter: monthFormatter)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("\(itemsByMonth[month]?.count ?? 0) items")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.accent)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.cardBackground.opacity(0.5))
                    )
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

#Preview {
    NavigationView {
        CalendarView(catalogViewModel: CatalogViewModel())
    }
}
