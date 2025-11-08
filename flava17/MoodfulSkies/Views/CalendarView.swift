import SwiftUI

struct CalendarView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appColors = AppColors.shared
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showingEntryForm = false
    @State private var showingEditEntry = false
    @State private var entryToEdit: MoodEntry?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            appColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Calendar")
                        .font(.builderSans(.bold, size: 28))
                        .foregroundColor(appColors.textPrimary)
                    
                    Spacer()
                }
                .padding()
                
                monthHeader
                
                ScrollView(showsIndicators: false) {
                    calendarGrid
                    
                    selectedDayDetails
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingEntryForm) {
            EntryFormView(prefilledDate: selectedDate)
        }
        .sheet(isPresented: $showingEditEntry) {
            if let entry = entryToEdit {
                EditEntry(entry: entry)
            }
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(appColors.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(appColors.cardGradient)
                    .cornerRadius(22)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.builderSans(.bold, size: 20))
                .foregroundColor(appColors.textPrimary)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(appColors.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(appColors.cardGradient)
                    .cornerRadius(22)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.builderSans(.medium, size: 12))
                        .foregroundColor(appColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        entry: dataManager.getEntry(for: date)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var selectedDayDetails: some View {
        VStack(spacing: 16) {
            Text(selectedDate.formatted(date: .complete, time: .omitted))
                .font(.builderSans(.semiBold, size: 18))
                .foregroundColor(appColors.textPrimary)
                .padding(.top, 20)
            
            if let entry = dataManager.getEntry(for: selectedDate) {
                entryPreviewCard(entry)
            } else {
                noEntryState
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func entryPreviewCard(_ entry: MoodEntry) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                HStack(spacing: 8) {
                    Image(systemName: entry.weather.icon)
                        .font(.system(size: 20))
                        .foregroundColor(appColors.primaryBlue)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.weather.displayName)
                            .font(.builderSans(.medium, size: 14))
                            .foregroundColor(appColors.textPrimary)
                        
                        Text("\(String(format: "%.1f", entry.temperature))°C")
                            .font(.builderSans(.regular, size: 12))
                            .foregroundColor(appColors.textSecondary)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: entry.mood.icon)
                        .font(.system(size: 20))
                        .foregroundColor(appColors.primaryOrange)
                    
                    Text(entry.mood.displayName)
                        .font(.builderSans(.medium, size: 14))
                        .foregroundColor(appColors.textPrimary)
                }
            }
            
            if let location = entry.location {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(appColors.accentGreen)
                    
                    Text(location)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                    
                    Spacer()
                }
            }
            
            if let tag = entry.tag {
                HStack {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 12))
                        .foregroundColor(appColors.accentPurple)
                    
                    Text(tag)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                    
                    Spacer()
                }
            }
            
            if let comment = entry.comment, !comment.isEmpty {
                Text(comment)
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(appColors.textSecondary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 12) {
                NavigationLink(destination: EntryDetailView(entry: entry)) {
                    Text("Open")
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(appColors.primaryGradient)
                        .cornerRadius(22)
                }
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var noEntryState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.6))
            
            Text("No entry for this day")
                .font(.builderSans(.medium, size: 16))
                .foregroundColor(appColors.textSecondary)
            
            NavigationLink(destination: EntryFormView(prefilledDate: selectedDate))
            {
                Text("Add Entry")
                    .font(.builderSans(.semiBold, size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(appColors.buttonGradient)
                    .cornerRadius(24)
            }
        }
        .padding(20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var daysInMonth: [Date] {
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
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let entry: MoodEntry?
    let onTap: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(textColor)
                
                HStack(spacing: 2) {
                    if let entry = entry {
                        Image(systemName: entry.weather.icon)
                            .font(.system(size: 8))
                            .foregroundColor(appColors.primaryBlue)
                        
                        Image(systemName: entry.mood.icon)
                            .font(.system(size: 8))
                            .foregroundColor(appColors.primaryOrange)
                    }
                }
                .frame(height: 10)
            }
            .frame(width: 40, height: 50)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.4)
        } else if isSelected {
            return .white
        } else if calendar.isDateInToday(date) {
            return appColors.primaryOrange
        } else {
            return appColors.textPrimary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return appColors.primaryBlue
        } else if calendar.isDateInToday(date) {
            return Color(red: 1.0, green: 0.6, blue: 0.2, opacity: 0.1)
        } else if entry != nil {
            return Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.8)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return appColors.primaryBlue
        } else {
            return Color.clear
        }
    }
}

#Preview {
    NavigationView {
        CalendarView()
    }
}
