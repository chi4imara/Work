import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var selectedDate: Date?
    @State private var currentMonth = Date()
    @State private var showingVictoryDetail = false
    @State private var victoryToEdit: Victory?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView(showsIndicators: false) {
                        calendarGridView
                        
                        if let selectedDate = selectedDate {
                            selectedDateCardView(for: selectedDate)
                        } else {
                            emptyStateView
                        }
                    }
                    .padding(.bottom, -200)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $victoryToEdit) { victory in
            EditVictoryView(victory: victory) {
                victoryToEdit = nil
            }
            .environmentObject(viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Victory Calendar")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
            }
            
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardGradient)
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(AppColors.primary, lineWidth: 2)
                        )
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .frame(width: 44, height: 44)
                        .background(AppColors.cardGradient)
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(AppColors.primary, lineWidth: 2)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 6)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            hasVictory: viewModel.hasVictoryForDate(date),
                            isSelected: selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!),
                            isToday: calendar.isDateInToday(date),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private func selectedDateCardView(for date: Date) -> some View {
        VStack(spacing: 0) {
            if let victory = viewModel.victoryForDate(date) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Victory")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { viewModel.toggleFavorite(victory) }) {
                            Image(systemName: victory.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(victory.isFavorite ? AppColors.accent : AppColors.textSecondary)
                        }
                    }
                    
                    Text(victory.text)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        victoryToEdit = victory
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .bold))
                            Text("Edit")
                                .font(AppFonts.pixelCaption)
                        }
                        .foregroundColor(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(AppColors.primary, lineWidth: 2)
                        )
                    }
                }
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("No victory recorded")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Add a victory for \(date.formatted(date: .abbreviated, time: .omitted)) on the main screen")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(AppColors.textSecondary.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 200)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: selectedDate)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
            
            Text("Select a date to view victory")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 40)
        .padding(.bottom, 200)
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let firstOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date?] = []
        
        for _ in 1..<firstDayWeekday {
            days.append(nil)
        }
        
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        while days.count < 42 {
            days.append(nil)
        }
        
        return days
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
            selectedDate = nil
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
            selectedDate = nil
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let hasVictory: Bool
    let isSelected: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(AppFonts.pixelCaption)
                    .foregroundColor(textColor)
                
                if hasVictory {
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
        }
        .frame(height: 40)
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.primary
        } else if isToday {
            return Color(red: 0.95, green: 0.98, blue: 1.0, opacity: 0.8)
        } else if hasVictory {
            return Color(red: 0.95, green: 0.98, blue: 1.0)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return AppColors.primary
        } else if isToday {
            return AppColors.primary
        } else if hasVictory {
            return AppColors.primary.opacity(0.3)
        } else {
            return AppColors.textSecondary.opacity(0.2)
        }
    }
    
    private var borderWidth: CGFloat {
        if isSelected || isToday {
            return 2
        } else {
            return 1
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return AppColors.textLight
        } else {
            return AppColors.textPrimary
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(VictoryViewModel())
}
