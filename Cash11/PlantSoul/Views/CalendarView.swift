import SwiftUI
import Foundation

struct CalendarView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var showingFilterMenu = false
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    @State private var currentDate = Date()
    
    private let calendar = Calendar.current
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    
                    calendarSection
                    
                    tasksSection
                }
                .padding(.bottom, 100)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    addTaskButton
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(taskViewModel: taskViewModel)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(task: task, taskViewModel: taskViewModel)
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.lightText)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(ColorScheme.cardGradient.opacity(0.3))
                        )
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(monthFormatter.string(from: currentDate))
                        .font(Font.custom("Poppins-Bold", size: 24))
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text("Tap a date to view tasks")
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .foregroundColor(ColorScheme.lightText.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.lightText)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(ColorScheme.cardGradient.opacity(0.3))
                        )
                }
            }
            .padding(.horizontal, DesignConstants.largePadding)
            .padding(.top, DesignConstants.mediumPadding)
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday.uppercased())
                        .font(Font.custom("Poppins-Medium", size: 11))
                        .foregroundColor(ColorScheme.lightText.opacity(0.6))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, DesignConstants.largePadding)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 12) {
                ForEach(calendarDays, id: \.self) { date in
                    ModernCalendarDayView(
                        date: date,
                        tasks: taskViewModel.tasksForDate(date),
                        isSelected: calendar.isDate(date, inSameDayAs: taskViewModel.selectedDate),
                        isToday: calendar.isDateInToday(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            taskViewModel.selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal, DesignConstants.largePadding)
        }
        .padding(.vertical, DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.largeCornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.2))
        )
        .padding(.horizontal, DesignConstants.largePadding)
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tasks")
                        .font(Font.custom("Poppins-Bold", size: 20))
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(dayFormatter.string(from: taskViewModel.selectedDate))
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(ColorScheme.lightText.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(ColorScheme.lightText)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(ColorScheme.cardGradient.opacity(0.3))
                        )
                }
            }
            .padding(.horizontal, DesignConstants.largePadding)
            .padding(.top, DesignConstants.largePadding)
            
            if taskViewModel.tasksForSelectedDate.isEmpty {
                emptyTasksView
            } else {
                taskListContent
            }
        }
    }
    
    private var emptyTasksView: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 48))
                .foregroundColor(ColorScheme.accent.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No tasks today")
                    .font(Font.custom("Poppins-Medium", size: 18))
                    .foregroundColor(ColorScheme.lightText)
                
                Text("Tap the + button to add a new task")
                    .font(Font.custom("Poppins-Regular", size: 14))
                    .foregroundColor(ColorScheme.lightText.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.largeCornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.2))
        )
        .padding(.horizontal, DesignConstants.largePadding)
    }
    
    private var taskListContent: some View {
        LazyVStack(spacing: DesignConstants.smallPadding) {
            ForEach(taskViewModel.tasksForSelectedDate) { task in
                TaskRowView(task: task, taskViewModel: taskViewModel) {
                    selectedTask = task
                }
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                        .fill(ColorScheme.cardGradient.opacity(0.2))
                )
            }
        }
        .padding(.horizontal, DesignConstants.largePadding)
    }
    
    private var addTaskButton: some View {
        Button(action: { 
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showingAddTask = true 
            }
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorScheme.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorScheme.accent, ColorScheme.accent.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: ColorScheme.accent.opacity(0.4),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                )
        }
        .scaleEffect(showingAddTask ? 0.95 : 1.0)
        .padding(.trailing, DesignConstants.largePadding)
        .padding(.bottom, 100)
    }
    

    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else {
            return []
        }
        
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let daysToSubtract = monthFirstWeekday - calendar.firstWeekday
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: monthInterval.start) else {
            return []
        }
        
        var days: [Date] = []
        for i in 0..<42 {
            if let day = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(day)
            }
        }
        
        return days
    }
    
    private var filterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Options"),
            buttons: [
                .default(Text("Clear Completed")) {
                    taskViewModel.clearCompletedTasksForMonth()
                },
                .cancel()
            ]
        )
    }
    
    private func previousMonth() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        }
    }
    
    private func nextMonth() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }
    }
}

struct ModernCalendarDayView: View {
    let date: Date
    let tasks: [Task]
    let isSelected: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text("\(calendar.component(.day, from: date))")
                    .font(Font.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(textColor)
                
                HStack(spacing: 3) {
                    ForEach(Array(Set(tasks.prefix(2).map { $0.type })), id: \.self) { taskType in
                        Circle()
                            .fill(colorForTaskType(taskType))
                            .frame(width: 6, height: 6)
                    }
                    
                    if tasks.count > 2 {
                        Circle()
                            .fill(ColorScheme.lightText.opacity(0.4))
                            .frame(width: 4, height: 4)
                    }
                }
                .frame(height: 8)
            }
            .frame(width: 34, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return ColorScheme.lightText.opacity(0.3)
        }
        if isSelected {
            return ColorScheme.white
        }
        if isToday {
            return ColorScheme.accent
        }
        return ColorScheme.lightText
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return ColorScheme.accent
        }
        if isToday {
            return ColorScheme.accent.opacity(0.15)
        }
        if !tasks.isEmpty && isCurrentMonth {
            return ColorScheme.lightBlue.opacity(0.4)
        }
        return Color.clear
    }
    
    private var borderColor: Color {
        if isSelected {
            return ColorScheme.accent.opacity(0.3)
        }
        if isToday {
            return ColorScheme.accent.opacity(0.5)
        }
        return Color.clear
    }
    
    private var borderWidth: CGFloat {
        if isSelected || isToday {
            return 1
        }
        return 0
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.lightBlue
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.lightBlue
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
}



#Preview {
    CalendarView(taskViewModel: TaskViewModel())
}

