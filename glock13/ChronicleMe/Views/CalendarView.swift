import SwiftUI

struct CalendarView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var selectedDateMemories: [Memory] = []
    @State private var showingMemoryDetail: Memory?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if memoryStore.memories.isEmpty {
                    emptyStateView
                } else {
                    VStack(spacing: 0) {
                        calendarGridView
                        
                        if !selectedDateMemories.isEmpty {
                            memoriesForSelectedDate
                        } else if calendar.isDate(selectedDate, inSameDayAs: Date()) {
                            noMemoriesView
                        }
                        
                        Spacer()
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            updateSelectedDateMemories()
        }
        .onChange(of: selectedDate) { _ in
            updateSelectedDateMemories()
        }
        .sheet(item: $showingMemoryDetail) { memory in
            NavigationView {
                MemoryDetailView(memoryStore: memoryStore, memory: memory)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Memory Calendar")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "calendar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            Text("No memories in calendar yet")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            memoryCount: memoryStore.memoryCountForDate(date),
                            hasMemories: memoryStore.hasMemoriesForDate(date)
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var memoriesForSelectedDate: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Memories for \(formatSelectedDate())")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(selectedDateMemories) { memory in
                        Button(action: { showingMemoryDetail = memory }) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(memory.shortText)
                                        .font(AppFonts.callout)
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(memory.formattedTime)
                                        .font(AppFonts.caption2)
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                
                                Spacer()
                                
                                if memory.isImportant {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.importantStar)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var noMemoriesView: some View {
        VStack(spacing: 12) {
            Text("No memories for this day")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
                .padding(.top, 20)
        }
    }
    
    private var daysInMonth: [Date?] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let range = calendar.range(of: .day, in: .month, for: currentMonth) ?? 1..<2
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
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
    
    private func updateSelectedDateMemories() {
        selectedDateMemories = memoryStore.memoriesForDate(selectedDate)
    }
    
    private func formatSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let memoryCount: Int
    let hasMemories: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(AppFonts.callout)
                    .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryText)
                
                if hasMemories {
                    if memoryCount > 1 {
                        Text("\(memoryCount)")
                            .font(AppFonts.caption2)
                            .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryYellow)
                    } else {
                        Circle()
                            .fill(isSelected ? AppColors.buttonText : AppColors.primaryYellow)
                            .frame(width: 4, height: 4)
                    }
                } else {
                    Spacer()
                        .frame(height: 4)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppColors.primaryYellow : (hasMemories ? AppColors.cardBackground : Color.clear))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                hasMemories && !isSelected ? AppColors.primaryYellow.opacity(0.3) : Color.clear,
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CalendarView(memoryStore: MemoryStore())
}
