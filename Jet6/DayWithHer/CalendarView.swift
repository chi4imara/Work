import SwiftUI

struct DateDetailsItem: Identifiable {
    let id = UUID()
    let date: Date
}

struct CalendarView: View {
    @StateObject private var viewModel = IdeaViewModel()
    @State private var selectedDate = Date()
    @State private var selectedFilter: FilterType = .all
    @State private var selectedDateItem: DateDetailsItem?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                filtersView
                
                ScrollView(showsIndicators: false) {
                    calendarView
                    
                    upcomingEventsView
                }
            }
        }
        .sheet(item: $selectedDateItem) { item in
            DateDetailsView(date: item.date, viewModel: viewModel, selectedFilter: selectedFilter)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Meeting Calendar")
                    .font(.playfair(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Plan your special moments")
                    .font(.playfair(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var filtersView: some View {
        HStack(spacing: 12) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                Button(action: {
                    selectedFilter = filter
                }) {
                    Text(filter.rawValue)
                        .font(.playfair(size: 14, weight: .medium))
                        .foregroundColor(selectedFilter == filter ? .white : AppColors.blueText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedFilter == filter ?
                            AppColors.blueText : AppColors.cardBackground
                        )
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var calendarView: some View {
        VStack(spacing: 16) {
            CalendarGridView(
                selectedDate: $selectedDate,
                viewModel: viewModel,
                selectedFilter: selectedFilter,
                onDateTapped: { date in
                    selectedDate = date
                    let filteredIdeas = viewModel.ideasForDate(date).filter { idea in
                        switch selectedFilter {
                        case .all:
                            return true
                        case .planned:
                            return idea.status == .planned
                        case .completed:
                            return idea.status == .completed
                        }
                    }
                    if !filteredIdeas.isEmpty {
                        selectedDateItem = DateDetailsItem(date: date)
                    }
                }
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var upcomingEventsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Events")
                .font(.playfair(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            if filteredUpcomingIdeas.isEmpty {
                emptyUpcomingView
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(filteredUpcomingIdeas) { idea in
                        UpcomingEventCard(idea: idea, viewModel: viewModel)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var emptyUpcomingView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(AppColors.lightText)
            
            Text("No scheduled meetings")
                .font(.playfair(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Text("Add a date to any idea to see it in the calendar.")
                .font(.playfair(size: 14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
    }
    
    private var filteredUpcomingIdeas: [Idea] {
        let upcoming = viewModel.upcomingIdeas
        switch selectedFilter {
        case .all:
            return upcoming
        case .planned:
            return upcoming.filter { $0.status == .planned }
        case .completed:
            return upcoming.filter { $0.status == .completed }
        }
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let viewModel: IdeaViewModel
    let selectedFilter: FilterType
    let onDateTapped: (Date) -> Void
    
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.blueText)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(.playfair(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.blueText)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.playfair(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(height: 30)
                }
                
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        hasIdeas: hasIdeasForDate(date),
                        ideaCount: ideaCountForDate(date),
                        onTap: {
                            onDateTapped(date)
                        }
                    )
                }
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end) else {
            return []
        }
        
        var days: [Date] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    private func hasIdeasForDate(_ date: Date) -> Bool {
        let ideas = viewModel.ideasForDate(date)
        switch selectedFilter {
        case .all:
            return !ideas.isEmpty
        case .planned:
            return ideas.contains { $0.status == .planned }
        case .completed:
            return ideas.contains { $0.status == .completed }
        }
    }
    
    private func ideaCountForDate(_ date: Date) -> Int {
        let ideas = viewModel.ideasForDate(date)
        switch selectedFilter {
        case .all:
            return ideas.count
        case .planned:
            return ideas.filter { $0.status == .planned }.count
        case .completed:
            return ideas.filter { $0.status == .completed }.count
        }
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
    let hasIdeas: Bool
    let ideaCount: Int
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.playfair(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(
                        isSelected ? .white :
                        isCurrentMonth ? AppColors.primaryText : AppColors.lightText
                    )
                
                if hasIdeas {
                    Circle()
                        .fill(isSelected ? .white : AppColors.yellowAccent)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                isSelected ? AppColors.blueText :
                hasIdeas ? AppColors.yellowAccent.opacity(0.2) : Color.clear
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct UpcomingEventCard: View {
    let idea: Idea
    let viewModel: IdeaViewModel
    @State private var selectedIdeaId: UUID?
    
    var body: some View {
        Button(action: {
            selectedIdeaId = idea.id
        }) {
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    Text(idea.shortDateString)
                        .font(.playfair(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.blueText)
                    
                    Circle()
                        .fill(idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                        .frame(width: 8, height: 8)
                }
                .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(idea.title)
                        .font(.playfair(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 8) {
                        Image(systemName: idea.category.icon)
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.blueText)
                        
                        Text(idea.category.rawValue)
                            .font(.playfair(size: 12, weight: .medium))
                            .foregroundColor(AppColors.blueText)
                        
                        Spacer()
                        
                        Text(idea.status.rawValue)
                            .font(.playfair(size: 12, weight: .medium))
                            .foregroundColor(idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    selectedIdeaId = idea.id
                }) {
                    Text("Open")
                        .font(.playfair(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.blueText)
                        .cornerRadius(15)
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(item: Binding(
            get: { selectedIdeaId.map { IdeaDetailItem(id: $0) } },
            set: { selectedIdeaId = $0?.id }
        )) { item in
            IdeaDetailView(ideaId: item.id, viewModel: viewModel)
        }
    }
}

struct DateDetailsView: View {
    let date: Date
    @ObservedObject var viewModel: IdeaViewModel
    let selectedFilter: FilterType
    @Environment(\.presentationMode) var presentationMode
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    private var filteredIdeas: [Idea] {
        let ideas = viewModel.ideasForDate(date)
        return ideas.filter { idea in
            switch selectedFilter {
            case .all:
                return true
            case .planned:
                return idea.status == .planned
            case .completed:
                return idea.status == .completed
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredIdeas) { idea in
                            IdeaCardView(ideaId: idea.id, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(dateFormatter.string(from: date))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    CalendarView()
}
