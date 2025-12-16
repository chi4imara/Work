import SwiftUI

struct CalendarView: View {
    @StateObject private var contentIdeasViewModel = ContentIdeasViewModel()
    @StateObject private var calendarViewModel: CalendarViewModel
    @State private var selectedIdeaID: IdeaID?
    @State private var selectedDate: Date?
    
    init() {
        let contentVM = ContentIdeasViewModel()
        _calendarViewModel = StateObject(wrappedValue: CalendarViewModel(contentIdeasViewModel: contentVM))
        _contentIdeasViewModel = StateObject(wrappedValue: contentVM)
    }
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                viewModeToggle
                
                if calendarViewModel.ideasByDate.isEmpty {
                    emptyStateView
                } else {
                    if calendarViewModel.viewMode == .calendar {
                        calendarModeView
                    } else {
                        listModeView
                    }
                }
            }
        }
        .sheet(item: $selectedIdeaID) { ideaID in
            IdeaDetailsView(ideaID: ideaID.id, viewModel: contentIdeasViewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Publication Plan")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("Scheduled content by dates")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private var viewModeToggle: some View {
        HStack(spacing: 0) {
            ForEach(CalendarViewMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        calendarViewModel.viewMode = mode
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text(mode.displayName)
                            .font(.playfairDisplay(14, weight: .medium))
                    }
                    .foregroundColor(calendarViewModel.viewMode == mode ? .white : Color.theme.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(calendarViewModel.viewMode == mode ? AnyShapeStyle(Color.theme.purpleGradient) : AnyShapeStyle(Color.clear))
                    )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.primaryWhite)
                .shadow(color: Color.theme.shadowColor, radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No scheduled publications")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add dates to your ideas to see the plan.")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var calendarModeView: some View {
        ScrollView {
            VStack(spacing: 20) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(.playfairDisplay(12, weight: .semibold))
                            .foregroundColor(Color.theme.secondaryText)
                            .frame(height: 30)
                    }
                    
                    ForEach(calendarDays, id: \.self) { date in
                        CalendarDayView(
                            date: date,
                            hasIdeas: calendarViewModel.hasIdeas(for: date),
                            isSelected: isDateSelected(date)
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if selectedDate == date {
                                    selectedDate = nil
                                } else {
                                    selectedDate = date
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                if let selectedDate = selectedDate {
                    selectedDateIdeasList(for: selectedDate)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private func selectedDateIdeasList(for date: Date) -> some View {
        let ideas = calendarViewModel.ideas(for: date)
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(date, style: .date)
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(ideas.count) \(ideas.count == 1 ? "idea" : "ideas")")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            VStack(spacing: 12) {
                ForEach(ideas) { idea in
                    Button(action: {
                        selectedIdeaID = IdeaID(id: idea.id)
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: idea.contentType.icon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(Color.theme.primaryBlue)
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(Color.theme.lightBlue.opacity(0.3))
                                )
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(idea.title)
                                        .font(.playfairDisplay(18, weight: .semibold))
                                        .foregroundColor(Color.theme.primaryText)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(idea.status.color)
                                        .frame(width: 12, height: 12)
                                }
                                
                                Text(idea.contentType.displayName)
                                    .font(.playfairDisplay(14, weight: .medium))
                                    .foregroundColor(Color.theme.accentText)
                                
                                Text(idea.status.displayName)
                                    .font(.playfairDisplay(12, weight: .medium))
                                    .foregroundColor(idea.status.color)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.theme.cardGradient)
                                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    private func isDateSelected(_ date: Date) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var listModeView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(calendarViewModel.sortedDates, id: \.self) { date in
                    DateGroupView(
                        date: date,
                        ideas: calendarViewModel.ideas(for: date)
                    ) { idea in
                        selectedIdeaID = IdeaID(id: idea.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: today)?.start ?? today
        let endOfMonth = calendar.dateInterval(of: .month, for: today)?.end ?? today
        
        var days: [Date] = []
        var currentDate = startOfMonth
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysFromPreviousMonth = firstWeekday - 1
        
        for i in 0..<daysFromPreviousMonth {
            if let date = calendar.date(byAdding: .day, value: -daysFromPreviousMonth + i, to: startOfMonth) {
                days.append(date)
            }
        }
        
        while currentDate < endOfMonth {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        let remainingDays = 42 - days.count
        for i in 0..<remainingDays {
            if let date = calendar.date(byAdding: .day, value: i, to: currentDate) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct CalendarDayView: View {
    let date: Date
    let hasIdeas: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(isCurrentMonth ? (isSelected ? .white : Color.theme.primaryText) : Color.theme.secondaryText.opacity(0.5))
                
                if hasIdeas {
                    Circle()
                        .fill(isSelected ? .white : Color.theme.primaryBlue)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AnyShapeStyle(Color.theme.purpleGradient) : (hasIdeas ? AnyShapeStyle(Color.theme.lightBlue.opacity(0.3)) : AnyShapeStyle(Color.clear)))
            )
        }
    }
    
    private var isCurrentMonth: Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
    }
}

struct DateGroupView: View {
    let date: Date
    let ideas: [ContentIdea]
    let onIdeaTap: (ContentIdea) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(date, style: .date)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Text("\(ideas.count) \(ideas.count == 1 ? "record" : "records")")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            VStack(spacing: 8) {
                ForEach(ideas) { idea in
                    Button(action: {
                        onIdeaTap(idea)
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: idea.contentType.icon)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.theme.primaryBlue)
                                .frame(width: 30, height: 30)
                                .background(
                                    Circle()
                                        .fill(Color.theme.lightBlue.opacity(0.3))
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(idea.title)
                                    .font(.playfairDisplay(16, weight: .medium))
                                    .foregroundColor(Color.theme.primaryText)
                                    .lineLimit(1)
                                
                                Text(idea.status.displayName)
                                    .font(.playfairDisplay(12, weight: .regular))
                                    .foregroundColor(idea.status.color)
                            }
                            
                            Spacer()
                            
                            Circle()
                                .fill(idea.status.color)
                                .frame(width: 8, height: 8)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.primaryWhite.opacity(0.8))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
}


#Preview {
    CalendarView()
}
