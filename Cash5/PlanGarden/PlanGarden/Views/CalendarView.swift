import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showingFilters = false
    @State private var showingTaskForm = false
    @State private var selectedTaskForDetail: GardenTask?
    @State private var selectedTaskForEdit: GardenTask?
    @State private var viewMode: CalendarViewMode = .month
    
    private let calendar = Calendar.current
    
    enum CalendarViewMode: String, CaseIterable {
        case month = "Month"
        case week = "Week"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView(showsIndicators: false) {
                        if hasActiveFilters {
                            filterIndicatorView
                        }
                        
                        viewModePicker
                        
                        if viewMode == .month {
                            monthCalendarView
                        } else {
                            weekCalendarView
                        }
                        
                        selectedDateTasksView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                FilterView()
            }
            .sheet(isPresented: $showingTaskForm) {
                TaskFormView(task: selectedTaskForEdit)
            }
            .sheet(item: $selectedTaskForDetail) { task in
                TaskDetailView(task: task)
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        !taskManager.selectedCultures.isEmpty || !taskManager.selectedWorkTypes.isEmpty
    }
    
    private var selectedDateTasks: [GardenTask] {
        taskManager.tasksForDate(selectedDate)
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Calendar")
                    .font(.appLargeTitle)
                    .foregroundColor(.appPrimary)
                
                Text(monthYearString(currentMonth))
                    .font(.appSubheadline)
                    .foregroundColor(.appMediumGray)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
                
                Button(action: { showingFilters = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var filterIndicatorView: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .foregroundColor(.appAccent)
                
                Text("Filters Active")
                    .font(.appCaption1)
                    .foregroundColor(.appDarkGray)
            }
            
            Spacer()
            
            Button("Clear") {
                taskManager.clearFilters()
            }
            .font(.appCaption1)
            .foregroundColor(.appPrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(AppColors.lightGray.opacity(0.5))
    }
    
    private var viewModePicker: some View {
        HStack {
            Picker("View Mode", selection: $viewMode) {
                ForEach(CalendarViewMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var monthCalendarView: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.appCaption1)
                        .foregroundColor(.appMediumGray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        tasks: taskManager.tasksForDate(date),
                        onTap: {
                            selectedDate = date
                        },
                        onLongPress: {
                            selectedDate = date
                            selectedTaskForEdit = nil
                            showingTaskForm = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var weekCalendarView: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(daysInWeek, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: true,
                        tasks: taskManager.tasksForDate(date),
                        onTap: {
                            selectedDate = date
                        },
                        onLongPress: {
                            selectedDate = date
                            selectedTaskForEdit = nil
                            showingTaskForm = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            
            weekTasksSummary
        }
    }
    
    private var weekTasksSummary: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(daysInWeek, id: \.self) { date in
                    let dayTasks = taskManager.tasksForDate(date)
                    if !dayTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(dayString(date))
                                .font(.appHeadline)
                                .foregroundColor(.appPrimary)
                            
                            ForEach(dayTasks) { task in
                                TaskRowView(
                                    task: task,
                                    date: date,
                                    onTap: {
                                        selectedTaskForDetail = task
                                    },
                                    onToggleComplete: {
                                        toggleTaskCompletion(task, for: date)
                                    }
                                )
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var selectedDateTasksView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tasks for \(dayString(selectedDate))")
                    .font(.appTitle3)
                    .foregroundColor(.appPrimary)
                
                Spacer()
                
                if !selectedDateTasks.isEmpty {
                    Button("Add Task") {
                        selectedTaskForEdit = nil
                        showingTaskForm = true
                    }
                    .font(.appCallout)
                    .foregroundColor(.appPrimary)
                }
            }
            .padding(.horizontal, 20)
            
            if selectedDateTasks.isEmpty {
                VStack(spacing: 12) {
                    Text("No tasks for this day")
                        .font(.appBody)
                        .foregroundColor(.appMediumGray)
                    
                    Button("Add Task") {
                        selectedTaskForEdit = nil
                        showingTaskForm = true
                    }
                    .font(.appCallout)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.primary)
                    .cornerRadius(16)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(selectedDateTasks) { task in
                            TaskRowView(
                                task: task,
                                date: selectedDate,
                                onTap: {
                                    selectedTaskForDetail = task
                                },
                                onToggleComplete: {
                                    toggleTaskCompletion(task, for: selectedDate)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = firstWeekday - calendar.firstWeekday
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth) else {
            return []
        }
        
        var days: [Date] = []
        for i in 0..<42 { 
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private var daysInWeek: [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        var days: [Date] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func dayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func toggleTaskCompletion(_ task: GardenTask, for date: Date) {
        if task.isCompletedFor(date: date) {
            taskManager.markTaskNotCompleted(task, for: date)
        } else {
            taskManager.markTaskCompleted(task, for: date)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let tasks: [GardenTask]
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.appCallout)
                .foregroundColor(dayTextColor)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(isSelected ? AppColors.primary : Color.clear)
                )
            
            HStack(spacing: 2) {
                ForEach(Array(Set(tasks.map { $0.workType })).prefix(3), id: \.self) { workType in
                    Circle()
                        .fill(colorForWorkType(workType))
                        .frame(width: 4, height: 4)
                }
                
                if tasks.count > 3 {
                    Text("+\(tasks.count - 3)")
                        .font(.system(size: 8))
                        .foregroundColor(.appMediumGray)
                }
            }
            .frame(height: 8)
        }
        .frame(height: 50)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
    
    private var dayTextColor: Color {
        if isSelected {
            return .white
        } else if isCurrentMonth {
            return .appDarkGray
        } else {
            return .appMediumGray
        }
    }
    
    private func colorForWorkType(_ workType: WorkType) -> Color {
        switch workType {
        case .planting: return .green
        case .watering: return .blue
        case .fertilizing: return .orange
        case .pruning: return .red
        case .other: return .appMediumGray
        }
    }
}

struct TaskRowView: View {
    let task: GardenTask
    let date: Date
    let onTap: () -> Void
    let onToggleComplete: () -> Void
    
    private var isCompleted: Bool {
        task.isCompletedFor(date: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.workType.icon)
                .font(.callout)
                .foregroundColor(.appAccent)
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(task.culture.name)
                    .font(.appCallout)
                    .foregroundColor(isCompleted ? .appMediumGray : .appPrimary)
                    .strikethrough(isCompleted)
                
                Text(task.workType.rawValue)
                    .font(.appCaption1)
                    .foregroundColor(.appMediumGray)
                    .strikethrough(isCompleted)
            }
            
            Spacer()
            
            if let time = task.time {
                Text(DateFormatter.displayTimeFormatter.string(from: time))
                    .font(.appCaption1)
                    .foregroundColor(.appMediumGray)
            }
            
            if isToday {
                Button(action: onToggleComplete) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isCompleted ? .appSuccess : .appMediumGray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.lightGray.opacity(0.3))
        .cornerRadius(8)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(TaskManager())
    }
}
