import SwiftUI

struct MainView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingAddEvent = false
    @State private var showingDayDetails = false
    @State private var showingFilterMenu = false
    @State private var showingPeriodMenu = false
    @State private var selectedDate = Date()
    @State private var selectedEventType: EventType? = nil
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Pet Care")
                        .font(.ubuntu(30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button(action: { showingAddEvent = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Menu {
                            Button("Period...") { showingPeriodMenu = true }
                            Button("Filter...") { showingFilterMenu = true }
                            Button("Reset Filters") { dataManager.resetFilters() }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 25) {
                        todaySection
                        
                        weekChartSection
                        
                        eventsJournalSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView(eventType: selectedEventType)
        }
        .sheet(isPresented: $showingDayDetails) {
            DayDetailsView(date: selectedDate)
        }
        .confirmationDialog("Select Period", isPresented: $showingPeriodMenu, titleVisibility: .visible) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(period.displayName) {
                    var newFilter = dataManager.filter
                    newFilter.period = period
                    dataManager.updateFilter(newFilter)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Filter Events", isPresented: $showingFilterMenu, titleVisibility: .visible) {
            ForEach(EventType.allCases, id: \.self) { eventType in
                Button(dataManager.filter.selectedTypes.contains(eventType) ? 
                       "✓ \(eventType.displayName)" : eventType.displayName) {
                    var newFilter = dataManager.filter
                    if newFilter.selectedTypes.contains(eventType) {
                        newFilter.selectedTypes.remove(eventType)
                    } else {
                        newFilter.selectedTypes.insert(eventType)
                    }
                    dataManager.updateFilter(newFilter)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select event types to show")
        }
    }
    
    private var todaySection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(DateFormatter.dayMonth.string(from: Date()))
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(EventType.allCases, id: \.self) { eventType in
                    TodayEventCard(
                        eventType: eventType,
                        count: getTodayCount(for: eventType),
                        onAddTapped: {
                            selectedEventType = eventType
                            showingAddEvent = true
                        }
                    )
                }
            }
            
            HStack {
                Text("Total actions today: \(dataManager.todayEvents().count)")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var weekChartSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Week Overview")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            WeekChartView { date in
                selectedDate = date
                showingDayDetails = true
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var eventsJournalSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Events Journal")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(dataManager.filter.period.displayName)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            
            if dataManager.filteredEvents().isEmpty {
                EmptyStateView(selectedTab: $selectedTab)
            } else {
                EventsListView(
                    events: dataManager.filteredEvents(),
                    onEventTapped: { event in
                        selectedDate = event.date
                        showingDayDetails = true
                    }
                )
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private func getTodayCount(for eventType: EventType) -> Int {
        let todayEvents = dataManager.todayEvents()
        switch eventType {
        case .feeding, .walk:
            return todayEvents.filter { $0.type == eventType }.count
        case .vitamins, .veterinarian:
            return todayEvents.contains { $0.type == eventType } ? 1 : 0
        }
    }
}

struct TodayEventCard: View {
    let eventType: EventType
    let count: Int
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: eventType.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(eventColor)
                
                Spacer()
                
                Text(displayText)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
            }
            
            HStack {
                Text(eventType.displayName)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Button {
                    onAddTapped()
                } label: {
                    Text("Add")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.theme.primaryPurple)
                        .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var displayText: String {
        switch eventType {
        case .feeding, .walk:
            return "\(count)"
        case .vitamins, .veterinarian:
            return count > 0 ? "Yes" : "No"
        }
    }
    
    private var eventColor: Color {
        switch eventType {
        case .feeding:
            return Color.theme.accentOrange
        case .walk:
            return Color.theme.accentGreen
        case .vitamins:
            return Color.theme.accentYellow
        case .veterinarian:
            return Color.theme.accentRed
        }
    }
}

struct WeekChartView: View {
    let onDayTapped: (Date) -> Void
    @ObservedObject var dataManager = DataManager.shared
    
    var body: some View {
        let weekData = dataManager.getWeekAnalytics()
        
        HStack(spacing: 8) {
            ForEach(weekData, id: \.date) { dayData in
                VStack(spacing: 8) {
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.secondaryPurple]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 30, height: CGFloat(dayData.totalEvents * 8))
                            .cornerRadius(4)
                    }
                    .frame(height: 80)
                    
                    HStack(spacing: 2) {
                        ForEach(Array(dayData.eventTypes), id: \.self) { eventType in
                            Image(systemName: eventType.iconName)
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .frame(height: 12)
                    
                    Text(DateFormatter.dayShort.string(from: dayData.date))
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .onTapGesture {
                    onDayTapped(dayData.date)
                }
            }
        }
    }
}

struct EventsListView: View {
    let events: [PetEvent]
    let onEventTapped: (PetEvent) -> Void
    
    var body: some View {
        let groupedEvents = Dictionary(grouping: events.sorted { $0.dateTime > $1.dateTime }) { event in
            Calendar.current.startOfDay(for: event.date)
        }
        
        LazyVStack(spacing: 15) {
            ForEach(groupedEvents.keys.sorted(by: >), id: \.self) { date in
                VStack(spacing: 10) {
                    HStack {
                        Text(DateFormatter.dayMonthYear.string(from: date))
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(groupedEvents[date]?.count ?? 0) events")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    ForEach(groupedEvents[date]?.sorted { $0.dateTime > $1.dateTime } ?? [], id: \.id) { event in
                        EventRowView(event: event) {
                            onEventTapped(event)
                        }
                    }
                }
            }
        }
    }
}

struct EventRowView: View {
    let event: PetEvent
    let onTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Text(DateFormatter.timeOnly.string(from: event.time))
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 50, alignment: .leading)
            
            HStack(spacing: 8) {
                Image(systemName: event.type.iconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(eventColor)
                    .frame(width: 20)
                
                Text(event.type.displayName)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            if !event.comment.isEmpty {
                Text(event.comment)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .onTapGesture {
            onTapped()
        }
    }
    
    private var eventColor: Color {
        switch event.type {
        case .feeding:
            return Color.theme.accentOrange
        case .walk:
            return Color.theme.accentGreen
        case .vitamins:
            return Color.theme.accentYellow
        case .veterinarian:
            return Color.theme.accentRed
        }
    }
}

struct EmptyStateView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No events recorded yet")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.white)
                
                Text("Start tracking your pet's care routine")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation {
                    selectedTab = 2
                }
            } label: {
                Text("Add First Event")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.theme.primaryPurple)
                    .cornerRadius(20)
            }
        }
        .padding(40)
    }
}

extension DateFormatter {
    static let dayMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    static let dayShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}


