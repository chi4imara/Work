import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var workoutStore: WorkoutStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Calendar")
                            .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack {
                                Button(action: previousMonth) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(ColorManager.accentBlue)
                                }
                                
                                Spacer()
                                
                                Text(dateFormatter.string(from: currentMonth))
                                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Spacer()
                                
                                Button(action: nextMonth) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(ColorManager.accentBlue)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            CalendarGridView(
                                currentMonth: currentMonth,
                                selectedDate: $selectedDate,
                                completedDates: workoutStore.completedDates
                            )
                            .padding(.horizontal, 20)
                            
                            if !workoutStore.sessionsForDate(selectedDate).isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("Workouts on \(selectedDate, formatter: dayFormatter)")
                                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                    }
                                    
                                    ForEach(workoutStore.sessionsForDate(selectedDate)) { session in
                                        if let workout = workoutStore.workouts.first(where: { $0.id == session.workoutId }) {
                                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                                CalendarWorkoutCard(session: session)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            } else if workoutStore.completedDates.contains(calendar.startOfDay(for: selectedDate)) {
                                VStack(spacing: 12) {
                                    Text("No workouts found for this date")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(ColorManager.secondaryText)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
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

struct CalendarGridView: View {
    let currentMonth: Date
    @Binding var selectedDate: Date
    let completedDates: Set<Date>
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { weekday in
                    Text(weekday)
                        .font(FontManager.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCompleted: completedDates.contains(calendar.startOfDay(for: date)),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        onTap: {
                            selectedDate = date
                        }
                    )
                }
            }
        }
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1)
        else { return [] }
        
        var dates: [Date] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return dates
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCompleted: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(ColorManager.accentBlue)
                } else if isCompleted {
                    Circle()
                        .fill(ColorManager.successGreen.opacity(0.3))
                        .overlay(
                            Circle()
                                .stroke(ColorManager.successGreen, lineWidth: 2)
                        )
                }
                
                Text("\(calendar.component(.day, from: date))")
                    .font(FontManager.playfairDisplay(size: 16, weight: isSelected ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? ColorManager.primaryText :
                        isCurrentMonth ? ColorManager.primaryText :
                        ColorManager.secondaryText.opacity(0.5)
                    )
                
                if isCompleted && !isSelected {
                    VStack {
                        Spacer()
                        Circle()
                            .fill(ColorManager.successGreen)
                            .frame(width: 6, height: 6)
                            .offset(y: -2)
                    }
                }
            }
        }
        .frame(width: 40, height: 40)
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarWorkoutCard: View {
    let session: WorkoutSession
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(ColorManager.successGreen)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.workoutName)
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(session.exerciseCount) exercises")
                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorManager.successGreen.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    CalendarView()
        .environmentObject(WorkoutStore())
}
