import SwiftUI
import Combine

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedDate: Date = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HistoryHeaderView(
                    selectedDate: $selectedDate,
                    onDateTapped: {
                        showingDatePicker = true
                    }
                )
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        CalendarView(
                            selectedDate: $selectedDate,
                            entries: viewModel.entries,
                            onDateSelected: { date in
                                selectedDate = date
                                viewModel.loadEntryForDate(date)
                            }
                        )
                        
                        if let entry = viewModel.selectedEntry {
                            DayDetailsView(entry: entry)
                        } else {
                            EmptyDayView(date: selectedDate)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .onAppear {
            viewModel.loadEntries()
            viewModel.loadEntryForDate(selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            viewModel.loadEntryForDate(newDate)
        }
    }
}

class HistoryViewModel: ObservableObject {
    @Published var entries: [DailyEntry] = []
    @Published var selectedEntry: DailyEntry?
    
    private let dataManager = DataManager.shared
    
    func loadEntries() {
        entries = dataManager.getAllEntries()
    }
    
    func loadEntryForDate(_ date: Date) {
        selectedEntry = entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

struct HistoryHeaderView: View {
    @Binding var selectedDate: Date
    let onDateTapped: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("History")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Track your journey")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(AppColors.cardBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let entries: [DailyEntry]
    let onDateSelected: (Date) -> Void
    
    @State private var displayedMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                }
            }
            
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isToday: calendar.isDateInToday(date),
                        hasEntry: hasEntryForDate(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month),
                        onTap: {
                            selectedDate = date
                            onDateSelected(date)
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    private var monthYearString: String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: displayedMonth)
    }
    
    private var calendarDays: [Date] {
        let startOfMonth = calendar.dateInterval(of: .month, for: displayedMonth)?.start ?? displayedMonth
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        var currentDate = startOfWeek
        
        for _ in 0..<42 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func hasEntryForDate(_ date: Date) -> Bool {
        entries.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEntry: Bool
    let isCurrentMonth: Bool
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
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                
                Text(dayNumber)
                    .font(.ubuntu(14, weight: isSelected || isToday ? .bold : .medium))
                    .foregroundColor(textColor)
                
                if hasEntry && !isSelected {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(AppColors.secondary)
                                .frame(width: 4, height: 4)
                                .offset(x: -2, y: -2)
                        }
                    }
                }
            }
            .frame(height: 40)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.secondary
        } else if isToday {
            return AppColors.accent.opacity(0.3)
        } else if hasEntry {
            return AppColors.success.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return AppColors.secondary
        } else if isToday {
            return AppColors.accent
        } else {
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        (isSelected || isToday) ? 1 : 0
    }
    
    private var textColor: Color {
        if isSelected {
            return AppColors.primary
        } else if isToday {
            return AppColors.accent
        } else {
            return AppColors.textPrimary
        }
    }
}

struct DayDetailsView: View {
    let entry: DailyEntry
    
    var body: some View {
        VStack(spacing: 16) {
            if !entry.moods.isEmpty {
                MoodHistorySection(moods: entry.moods)
            }
            
            if !entry.completedGoals.isEmpty {
                CompletedGoalsSection(completedGoalIds: entry.completedGoals)
            }
            
            if let question = entry.dailyQuestion {
                DailyQuestionHistorySection(question: question, answer: entry.dailyAnswer)
            }
            
            ProgressHistorySection(progress: entry.progressPercentage)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct EmptyDayView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No data for this day")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Start tracking your mood and goals to see your progress here.")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 40)
    }
}

struct MoodHistorySection: View {
    let moods: [Mood]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Moods")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack {
                ForEach(moods, id: \.id) { mood in
                    VStack(spacing: 4) {
                        Text(mood.type.rawValue)
                            .font(.system(size: 24))
                        
                        Text(mood.type.name)
                            .font(.ubuntu(10))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(8)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(AppGradients.primaryCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct CompletedGoalsSection: View {
    let completedGoalIds: [UUID]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Goals")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("\(completedGoalIds.count) goals completed")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.success)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppGradients.primaryCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct DailyQuestionHistorySection: View {
    let question: String
    let answer: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Question")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(question)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.textSecondary)
                .italic()
            
            if let answer = answer, !answer.isEmpty {
                Text("Your answer:")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(answer)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
            } else {
                Text("No answer provided")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.textSecondary)
                    .italic()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppGradients.primaryCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ProgressHistorySection: View {
    let progress: Double
    
    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Progress")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            HStack {
                Text("\(Int(clampedProgress * 100))% completed")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                ProgressView(value: clampedProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.success))
                    .frame(width: 100)
            }
        }
        .padding(16)
        .background(AppGradients.primaryCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(AppGradients.primaryCard)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.secondary)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
