import SwiftUI

struct DayDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataManager = DataManager.shared
    
    let date: Date
    @State private var showingAddEvent = false
    @State private var showingEditEvent = false
    @State private var selectedEvent: PetEvent?
    @State private var showingDeleteAlert = false
    @State private var eventToDelete: PetEvent?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        daySummarySection
                        
                        if let previousDayAnalytics = getPreviousDayAnalytics() {
                            comparisonSection(previousDay: previousDayAnalytics)
                        }
                        
                        eventsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Day - \(DateFormatter.dayMonthYear.string(from: date))")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAddEvent = true
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView(eventType: nil, editingEvent: nil)
        }
        .sheet(isPresented: $showingEditEvent) {
            if let event = selectedEvent {
                AddEventView(eventType: nil, editingEvent: event)
            }
        }
        .alert("Delete Event", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let event = eventToDelete {
                    dataManager.deleteEvent(event)
                }
            }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
    }
    
    private var daySummarySection: some View {
        let dayAnalytics = dataManager.getDayAnalytics(for: date)
        
        return VStack(spacing: 20) {
            HStack {
                Text("Day Summary")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(dayAnalytics.totalEvents) total events")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                DaySummaryCard(
                    title: "Feedings",
                    value: "\(dayAnalytics.feedingCount)",
                    icon: "fork.knife",
                    color: Color.theme.accentOrange
                )
                
                DaySummaryCard(
                    title: "Walks",
                    value: "\(dayAnalytics.walkCount)",
                    icon: "figure.walk",
                    color: Color.theme.accentGreen
                )
                
                DaySummaryCard(
                    title: "Vitamins",
                    value: dayAnalytics.hasVitamins ? "Yes" : "No",
                    icon: "pills",
                    color: Color.theme.accentYellow
                )
                
                DaySummaryCard(
                    title: "Veterinarian",
                    value: dayAnalytics.hasVeterinarian ? "Yes" : "No",
                    icon: "cross.case",
                    color: Color.theme.accentRed
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
    
    private func comparisonSection(previousDay: DayAnalytics) -> some View {
        let currentDay = dataManager.getDayAnalytics(for: date)
        
        return VStack(spacing: 15) {
            HStack {
                Text("Comparison with Previous Day")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ComparisonRow(
                    title: "Feedings",
                    current: currentDay.feedingCount,
                    previous: previousDay.feedingCount
                )
                
                ComparisonRow(
                    title: "Walks",
                    current: currentDay.walkCount,
                    previous: previousDay.walkCount
                )
                
                ComparisonBooleanRow(
                    title: "Vitamins",
                    current: currentDay.hasVitamins,
                    previous: previousDay.hasVitamins
                )
                
                ComparisonBooleanRow(
                    title: "Veterinarian",
                    current: currentDay.hasVeterinarian,
                    previous: previousDay.hasVeterinarian
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
    
    private var eventsSection: some View {
        let dayEvents = dataManager.eventsForDate(date).sorted { $0.dateTime > $1.dateTime }
        
        return VStack(spacing: 15) {
            HStack {
                Text("Events")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if !dayEvents.isEmpty {
                    Text("\(dayEvents.count) events")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            if dayEvents.isEmpty {
                EmptyDayView {
                    showingAddEvent = true
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(dayEvents, id: \.id) { event in
                        DayEventRow(
                            event: event,
                            onEdit: {
                                selectedEvent = event
                                showingEditEvent = true
                            },
                            onDelete: {
                                eventToDelete = event
                                showingDeleteAlert = true
                            }
                        )
                    }
                }
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
    
    private func getPreviousDayAnalytics() -> DayAnalytics? {
        guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
            return nil
        }
        
        let previousDayEvents = dataManager.eventsForDate(previousDay)
        if previousDayEvents.isEmpty {
            return nil
        }
        
        return dataManager.getDayAnalytics(for: previousDay)
    }
}

struct DaySummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            HStack {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct ComparisonRow: View {
    let title: String
    let current: Int
    let previous: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(current)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                
                if current > previous {
                    Text("+\(current - previous)")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.accentGreen)
                } else if current < previous {
                    Text("-\(previous - current)")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.accentRed)
                } else {
                    Text("no change")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ComparisonBooleanRow: View {
    let title: String
    let current: Bool
    let previous: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(current ? "Yes" : "No")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                
                if current && !previous {
                    Text("new")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.accentGreen)
                } else if !current && previous {
                    Text("missing")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(Color.theme.accentRed)
                } else {
                    Text("no change")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct DayEventRow: View {
    let event: PetEvent
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingActionSheet = false
    
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
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.type.displayName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white)
                    
                    if !event.comment.isEmpty {
                        Text(event.comment)
                            .font(.ubuntu(12, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                    }
                }
            }
            
            Spacer()
            
            Button(action: { showingActionSheet = true }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Event Actions"),
                buttons: [
                    .default(Text("Edit")) { onEdit() },
                    .destructive(Text("Delete")) { onDelete() },
                    .cancel()
                ]
            )
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

struct EmptyDayView: View {
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No events for this day")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("Add your first event for this day")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Button("Add Event") {
                onAddTapped()
            }
            .font(.ubuntu(14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.theme.primaryPurple)
            .cornerRadius(16)
        }
        .padding(30)
    }
}

#Preview {
    DayDetailsView(date: Date())
}
