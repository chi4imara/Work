import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingTaskForm = false
    @State private var showingFilters = false
    @State private var editingTask: Task?
    @State private var selectedTask: Task?
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeader(
                currentMonth: viewModel.currentMonth,
                onPreviousMonth: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentMonth) ?? viewModel.currentMonth
                    }
                },
                onNextMonth: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentMonth) ?? viewModel.currentMonth
                    }
                },
                onAddTask: {
                    editingTask = nil
                    showingTaskForm = true
                },
                onShowFilters: {
                    showingFilters = true
                }
            )
            
            ScrollView(showsIndicators: false) {
                CalendarGrid(
                    currentMonth: viewModel.currentMonth,
                    selectedDate: $viewModel.selectedDate,
                    viewModel: viewModel
                )
                .padding(.horizontal, 16)
                
                TasksForDateView(
                    selectedDate: viewModel.selectedDate,
                    tasks: viewModel.tasksForDate(viewModel.selectedDate),
                    onTaskTap: { task in
                        selectedTask = task
                    },
                    onEditTask: { task in
                        editingTask = task
                        showingTaskForm = true
                    },
                    onDeleteTask: { task in
                        viewModel.deleteTask(task)
                    }
                )
            }
        }
        .sheet(isPresented: $showingTaskForm) {
            TaskFormView(
                viewModel: viewModel,
                editingTask: $editingTask
            )
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(selectedFilters: $viewModel.selectedFilters)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(
                task: task,
                viewModel: viewModel,
                onEdit: {
                    selectedTask = nil
                    editingTask = task
                    showingTaskForm = true
                },
                onDelete: {
                    viewModel.deleteTask(task)
                    selectedTask = nil
                }
            )
        }
    }
}

struct CalendarHeader: View {
    let currentMonth: Date
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onAddTask: () -> Void
    let onShowFilters: () -> Void
    
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                }
                .padding(.leading, 20)
                .opacity(0)
                .disabled(true)
                
                Text("Calendar")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: onShowFilters) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(width: 32, height: 32)
                            .background(AppColors.lightBlue.opacity(0.3))
                            .cornerRadius(8)
                    }
                    
                    Button(action: onAddTask) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            HStack {
                Button(action: onPreviousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Spacer()
                
                Text(monthYearText)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: onNextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.9))
    }
}

struct CalendarGrid: View {
    let currentMonth: Date
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: TaskViewModel
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    private var days: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthFirstWeekday = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start ?? monthInterval.start
        let monthLastWeekday = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end)?.end ?? monthInterval.end
        
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeekday, end: monthLastWeekday),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(days, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        dayStatus: viewModel.dayStatus(for: date)
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let dayStatus: TaskDayStatus
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var statusColor: Color {
        switch dayStatus {
        case .none:
            return Color.clear
        case .completed:
            return AppColors.completedGreen
        case .inProgress:
            return AppColors.inProgressYellow
        case .overdue:
            return AppColors.overdueRed
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ? AppColors.primaryBlue : Color.clear)
                    .frame(width: 36, height: 36)
                
                if dayStatus != .none {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 32, height: 32)
                        .opacity(isSelected ? 0.3 : 0.8)
                }
                
                Text(dayNumber)
                    .font(AppFonts.callout)
                    .foregroundColor(
                        isSelected ? .white :
                        isCurrentMonth ? AppColors.primaryText : AppColors.lightText
                    )
            }
        }
        .frame(height: 40)
    }
}

struct TasksForDateView: View {
    let selectedDate: Date
    let tasks: [Task]
    let onTaskTap: (Task) -> Void
    let onEditTask: (Task) -> Void
    let onDeleteTask: (Task) -> Void
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tasks for \(dateString)")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if !tasks.isEmpty {
                    Text("\(tasks.count) task\(tasks.count == 1 ? "" : "s")")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            
            if tasks.isEmpty {
                EmptyTasksView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tasks) { task in
                            TaskCardView(
                                task: task,
                                onTap: { onTaskTap(task) },
                                onEdit: { onEditTask(task) },
                                onDelete: { onDeleteTask(task) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white.opacity(0.5))
    }
}

struct EmptyTasksView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.lightBlue)
            
            Text("No tasks for this day")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

#Preview {
    CalendarView(viewModel: TaskViewModel())
}
