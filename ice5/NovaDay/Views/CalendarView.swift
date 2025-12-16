import SwiftUI

struct MemoryDetailItem: Identifiable {
    let id: UUID
}

struct CalendarView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var selectedDate = Date()
    @State private var showingAddMemory = false
    @State private var selectedMemoryItem: MemoryDetailItem?
    
    private var selectedMemory: Memory? {
        memoryStore.memoryForDate(selectedDate)
    }
    
    private var monthMemories: [Memory] {
        memoryStore.memoriesForMonth(selectedDate)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Calendar")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        calendarSection
                        
                        selectedDateSection
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddMemory) {
            AddMemoryView(memoryStore: memoryStore)
        }
        .sheet(item: $selectedMemoryItem) { item in
            MemoryDetailView(memoryID: item.id, memoryStore: memoryStore)
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Spacer()
                
                Text(DateFormatter.monthYear.string(from: selectedDate))
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
            .padding(.horizontal, 16)
            
            CalendarGridView(
                selectedDate: $selectedDate,
                memories: monthMemories
            )
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private var selectedDateSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text(DateFormatter.fullDate.string(from: selectedDate))
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            if let memory = selectedMemory {
                VStack(spacing: 12) {
                    HStack {
                        Text(memory.mood)
                            .font(.system(size: 32))
                        
                        VStack(alignment: .leading) {
                            Text(memory.title)
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(memory.description.prefix(100) + (memory.description.count > 100 ? "..." : ""))
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        selectedMemoryItem = MemoryDetailItem(id: memory.id)
                    }) {
                        Text("Open")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(20)
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Text("No memory for this day")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Button(action: { showingAddMemory = true }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Memory")
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(20)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private func previousMonth() {
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
    }
    
    private func nextMonth() {
        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    let memories: [Memory]
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var monthDays: [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: selectedDate),
              let monthStart = calendar.dateInterval(of: .month, for: selectedDate)?.start else {
            return []
        }
        
        return monthRange.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }
    
    private var weekdays: [String] {
        calendar.shortWeekdaySymbols
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(monthDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        selectedDate: $selectedDate,
                        hasMemory: hasMemory(for: date)
                    )
                }
            }
        }
    }
    
    private func hasMemory(for date: Date) -> Bool {
        memories.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

struct CalendarDayView: View {
    let date: Date
    @Binding var selectedDate: Date
    let hasMemory: Bool
    
    private let calendar = Calendar.current
    
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    private var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        Button(action: { selectedDate = date }) {
            ZStack {
                Circle()
                    .fill(
                        isSelected ? AppColors.primaryBlue :
                        isToday ? AppColors.primaryYellow.opacity(0.3) :
                        Color.clear
                    )
                    .frame(width: 36, height: 36)
                
                Text(dayNumber)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? AppColors.textPrimary :
                        AppColors.textPrimary
                    )
                
                if hasMemory && !isSelected {
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 6, height: 6)
                        .offset(x: 12, y: -12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension DateFormatter {
    static let monthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

#Preview {
    CalendarView(memoryStore: MemoryStore())
}
