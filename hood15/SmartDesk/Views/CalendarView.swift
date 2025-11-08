import SwiftUI

struct CalendarView: View {
    @ObservedObject var subjectStore: SubjectStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private var tasksForSelectedDate: [Task] {
        subjectStore.getTasksForDate(selectedDate).sorted { task1, task2 in
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted && task2.isCompleted
            }
            return task1.dueDate < task2.dueDate
        }
    }
    
    private var datesWithTasks: Set<String> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return Set(subjectStore.getAllTasks().map { task in
            formatter.string(from: task.dueDate)
        })
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Text("Calendar")
                    .font(.appTitle)
                    .foregroundColor(.appText)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.appText)
                        }
                        
                        Spacer()
                        
                        Text(monthYearString(from: currentMonth))
                            .font(.appHeadline)
                            .foregroundColor(.appText)
                        
                        Spacer()
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(.appText)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    CalendarGrid(
                        currentMonth: currentMonth,
                        selectedDate: $selectedDate,
                        datesWithTasks: datesWithTasks
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Tasks for \(dateString(from: selectedDate))")
                            .font(.appHeadline)
                            .foregroundColor(.appText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    if tasksForSelectedDate.isEmpty {
                        Text("No tasks for this date")
                            .font(.appBody)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                    } else {
                            LazyVStack(spacing: 12) {
                                ForEach(tasksForSelectedDate) { task in
                                    CalendarTaskCard(task: task, subjectStore: subjectStore)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
        }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut) {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut) {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

struct CalendarGrid: View {
    let currentMonth: Date
    @Binding var selectedDate: Date
    let datesWithTasks: Set<String>
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private var monthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthFirstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let daysToSubtract = (monthFirstWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: monthInterval.start) else {
            return []
        }
        
        var dates: [Date] = []
        var date = startDate
        
        for _ in 0..<42 {
            dates.append(date)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: date) else {
                break
            }
            date = nextDate
        }
        
        return dates
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.appCaption)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(monthDates, id: \.self) { date in
                    CalendarDateView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        isToday: calendar.isDateInToday(date),
                        hasTasks: datesWithTasks.contains(dateFormatter.string(from: date)),
                        onTap: {
                            selectedDate = date
                        }
                    )
                }
            }
        }
    }
}

struct CalendarDateView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let isToday: Bool
    let hasTasks: Bool
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isSelected ? AppColors.primaryBlue :
                        isToday ? AppColors.lightBlue :
                        Color.clear
                    )
                    .frame(height: 40)
                
                VStack(spacing: 2) {
                    Text(dayNumber)
                        .font(.appBody)
                        .foregroundColor(
                            isSelected ? .white :
                            isCurrentMonth ? .appText :
                            AppColors.textSecondary.opacity(0.5)
                        )
                    
                    if hasTasks && isCurrentMonth {
                        Circle()
                            .fill(isSelected ? .white : AppColors.primaryBlue)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarTaskCard: View {
    let task: Task
    @ObservedObject var subjectStore: SubjectStore
    
    private var subject: Subject? {
        subjectStore.subjects.first { $0.id == task.subjectId }
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(task.dueDate)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                subjectStore.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(task.isCompleted ? AppColors.success : AppColors.textSecondary)
                    .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
            }
            .buttonStyle(PlainButtonStyle())
            
            RoundedRectangle(cornerRadius: 2)
                .fill(task.type == .homework ? AppColors.primaryBlue : AppColors.accent)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.appSubheadline)
                    .foregroundColor(task.isCompleted ? AppColors.textSecondary : .appText)
                    .strikethrough(task.isCompleted)
                
                if let subject = subject {
                    Text(subject.name)
                        .font(.appCaption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text(task.type.rawValue + (isToday ? " • Today" : "") + (task.isCompleted ? " • Completed" : ""))
                    .font(.appCaption)
                    .foregroundColor(
                        task.isCompleted ? AppColors.success :
                        isToday ? AppColors.primaryBlue : AppColors.textSecondary
                    )
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(task.isCompleted ? AppColors.lightBlue.opacity(0.3) : AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            task.isCompleted ? AppColors.success.opacity(0.3) :
                            isToday ? AppColors.primaryBlue.opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .opacity(task.isCompleted ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: task.isCompleted)
    }
}
#Preview {
    CalendarView(subjectStore: SubjectStore())
}

