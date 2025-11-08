import SwiftUI

struct PlannerView: View {
    @ObservedObject var viewModel: HobbyViewModel
    @State private var selectedDate = Date()
    @State private var currentWeekOffset = 0
    @State private var showingAddSession = false
    @State private var selectedHobby: Hobby?
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            WebPatternBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        
                        weekCalendarView
                        
                        selectedDaySessionsView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
        }
        .sheet(isPresented: $showingAddSession) {
            if let hobby = selectedHobby {
                AddSessionView(hobby: hobby, viewModel: viewModel)
            } else {
                PlanSessionView(viewModel: viewModel, selectedDate: selectedDate)
            }
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectedHobby = nil
                        showingAddSession = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                            Text("Plan Session")
                                .font(FontManager.body)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        )
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Planner")
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Plan and track your sessions")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    currentWeekOffset -= 1
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
                
                Button(action: {
                    currentWeekOffset += 1
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var weekCalendarView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(weekHeaderText)
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Today") {
                    currentWeekOffset = 0
                    selectedDate = Date()
                }
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryBlue)
            }
            
            HStack(spacing: 8) {
                ForEach(weekDays, id: \.self) { date in
                    WeekDayCard(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        plannedCount: viewModel.getPlannedSessions(for: date).count,
                        completedCount: viewModel.getCompletedSessions(for: date).count
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var selectedDaySessionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sessions for \(formatSelectedDate())")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            let plannedSessions = viewModel.getPlannedSessions(for: selectedDate)
            let completedSessions = viewModel.getCompletedSessions(for: selectedDate)
            
            if plannedSessions.isEmpty && completedSessions.isEmpty {
                emptyDayView
            } else {
                VStack(spacing: 16) {
                    if !plannedSessions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Planned (\(plannedSessions.count))")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            LazyVStack(spacing: 8) {
                                ForEach(plannedSessions, id: \.session.id) { plannedSession in
                                    PlannerSessionCard(
                                        plannedSession: plannedSession,
                                        viewModel: viewModel
                                    )
                                }
                            }
                        }
                    }
                    
                    if !completedSessions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Completed (\(completedSessions.count))")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                                .fontWeight(.semibold)
                            
                            LazyVStack(spacing: 8) {
                                ForEach(completedSessions, id: \.session.id) { completedSession in
                                    PlannerSessionCard(
                                        plannedSession: completedSession,
                                        viewModel: viewModel
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var emptyDayView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            Text("No sessions planned")
                .font(FontManager.subheadline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
            
            Text("Add a session to start planning your day")
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 30)
    }
    
    private var weekDays: [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let targetWeek = calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: startOfWeek) ?? startOfWeek
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: targetWeek)
        }
    }
    
    private var weekHeaderText: String {
        guard let firstDay = weekDays.first, let lastDay = weekDays.last else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        let firstDayString = formatter.string(from: firstDay)
        let lastDayString = formatter.string(from: lastDay)
        
        return "\(firstDayString) - \(lastDayString)"
    }
    
    private func formatSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: selectedDate)
    }
}

struct WeekDayCard: View {
    let date: Date
    let isSelected: Bool
    let plannedCount: Int
    let completedCount: Int
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(dayName)
                    .font(FontManager.small)
                    .foregroundColor(isSelected ? .white : ColorTheme.secondaryText)
                
                Text(dayNumber)
                    .font(FontManager.subheadline)
                    .foregroundColor(isSelected ? .white : ColorTheme.primaryText)
                    .fontWeight(.bold)
                
                VStack(spacing: 2) {
                    if plannedCount > 0 {
                        Text("P:\(plannedCount)")
                            .font(FontManager.caption)
                            .foregroundColor(isSelected ? .white.opacity(0.8) : ColorTheme.accent)
                    }
                    
                    if completedCount > 0 {
                        Text("C:\(completedCount)")
                            .font(FontManager.caption)
                            .foregroundColor(isSelected ? .white.opacity(0.8) : ColorTheme.success)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.3),
                                lineWidth: isSelected ? 0 : 1
                            )
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct PlannerSessionCard: View {
    let plannedSession: PlannedSession
    @ObservedObject var viewModel: HobbyViewModel
    @State private var showingActionSheet = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(ColorTheme.primaryBlue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: plannedSession.hobby.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(plannedSession.hobby.name)
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(formatTime(plannedSession.session.date))
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                HStack {
                    Text(plannedSession.session.durationFormatted)
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(plannedSession.session.isCompleted ? ColorTheme.success : ColorTheme.accent)
                            .frame(width: 8, height: 8)
                        
                        Text(plannedSession.session.isCompleted ? "Completed" : "Planned")
                            .font(FontManager.small)
                            .foregroundColor(plannedSession.session.isCompleted ? ColorTheme.success : ColorTheme.accent)
                    }
                }
                
                if !plannedSession.session.comment.isEmpty {
                    Text(plannedSession.session.comment)
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(1)
                }
            }
        }
        .padding(12)
        .background(ColorTheme.background)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.lightBlue.opacity(0.2), lineWidth: 1)
        )
        .onTapGesture {
            showingActionSheet = true
        }
        .confirmationDialog("Session Actions", isPresented: $showingActionSheet) {
            if plannedSession.session.isPlanned && !plannedSession.session.isCompleted {
                Button("Mark as Completed") {
                    viewModel.markSessionAsCompleted(plannedSession.session, in: plannedSession.hobby)
                }
            }
            
            Button("Delete Session", role: .destructive) {
                viewModel.deleteSession(plannedSession.session, from: plannedSession.hobby)
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
