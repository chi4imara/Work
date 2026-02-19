import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var selectedDate = Date()
    @State private var showingCalendar = true
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showingCalendar.toggle() }) {
                        Image(systemName: showingCalendar ? "list.bullet" : "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    if showingCalendar {
                        CalendarView(selectedDate: $selectedDate, viewModel: viewModel)
                    } else {
                        HistoryListView(viewModel: viewModel)
                    }
                }
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let viewModel: WardrobeViewModel
    
    @State private var currentMonth = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
                
                Spacer()
                
                Text(currentMonth, formatter: monthFormatter)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { offset, day in
                    Text(day)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(height: 30)
                }
                
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        hasOutfits: !viewModel.outfitsForDate(date).isEmpty,
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Outfits for \(selectedDate, formatter: dayFormatter)")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, 20)
                
                let outfitsForDay = viewModel.outfitsForDate(selectedDate)
                
                if outfitsForDay.isEmpty {
                    Text("No outfits created on this day")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, 20)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(outfitsForDay) { outfit in
                                HistoryOutfitCard(outfit: outfit)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private var weekdaySymbols: [String] {
        ["S", "M", "T", "W", "T", "F", "S"]
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let range = calendar.range(of: .day, in: .month, for: currentMonth) ?? 1..<32
        
        var days: [Date] = []
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let prevMonthStart = 2 - firstWeekday
        if prevMonthStart < 0 {
            for i in prevMonthStart..<0 {
                if let date = calendar.date(byAdding: .day, value: i, to: startOfMonth) {
                    days.append(date)
                }
            }
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        let remainingDays = 42 - days.count
        let lastDay = days.last ?? currentMonth
        if remainingDays > 0 {
            for i in 1...remainingDays {
                if let date = calendar.date(byAdding: .day, value: i, to: lastDay) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasOutfits: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.ubuntu(14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? .white :
                        isCurrentMonth ? AppColors.textPrimary : AppColors.textSecondary.opacity(0.5)
                    )
                
                if hasOutfits {
                    Circle()
                        .fill(isSelected ? .white : AppColors.accent)
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(isSelected ? AppColors.primary : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HistoryListView: View {
    let viewModel: WardrobeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(groupedOutfits.keys.sorted(by: >), id: \.self) { date in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(date, formatter: sectionDateFormatter)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, 20)
                        
                        ForEach(groupedOutfits[date] ?? []) { outfit in
                            HistoryOutfitCard(outfit: outfit)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var groupedOutfits: [Date: [Outfit]] {
        let calendar = Calendar.current
        return Dictionary(grouping: viewModel.outfits) { outfit in
            calendar.startOfDay(for: outfit.dateCreated)
        }
    }
    
    private var sectionDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

struct HistoryOutfitCard: View {
    let outfit: Outfit
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.primary.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    OutfitPhotoView(imageName: outfit.imageName, placeholderSize: 20, cornerRadius: 12)
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(outfit.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                if let category = outfit.category {
                    Text(category)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text("\(outfit.items.count) items")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(outfit.dateCreated, formatter: timeFormatter)
                .font(.ubuntu(12))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadow, radius: 6, x: 0, y: 2)
        )
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    HistoryView()
        .environmentObject(WardrobeViewModel())
}
