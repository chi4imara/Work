import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case dayDetails
        case addEntry(plant: PlantModel, selectedDate: Date)
        case noPlants
        
        var id: String {
            switch self {
            case .dayDetails: return "dayDetails"
            case .addEntry: return "addEntry"
            case .noPlants: return "noPlants"
            }
        }
    }
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthEntries: [EntryModel] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let endOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.end ?? currentMonth
        
        return dataManager.entries.filter { entry in
            entry.date >= startOfMonth && entry.date < endOfMonth
        }
    }
    
    private var monthSummary: (daysWithEntries: Int, totalEntries: Int, frequency: Double) {
        let entries = monthEntries
        let uniqueDays = Set(entries.map { calendar.startOfDay(for: $0.date) })
        let frequency = uniqueDays.isEmpty ? 0 : Double(entries.count) / Double(uniqueDays.count)
        
        return (uniqueDays.count, entries.count, frequency)
    }
    
    private var entriesForSelectedDate: [EntryModel] {
        return dataManager.getEntriesForDate(selectedDate)
    }
    
    private func entriesForDate(_ date: Date) -> [EntryModel] {
        return dataManager.getEntriesForDate(date)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Calendar")
                            .font(.playfair(.bold, size: 28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    
                    monthNavigationView
                    
                    calendarGridView
                    
                    monthSummaryView
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .dayDetails:
                dayDetailsSheet(for: selectedDate)
            case .addEntry(let plant, let selectedDate):
                AddPlantEntryView(mode: .newEntry(plant: plant, selectedDate: selectedDate))
            case .noPlants:
                noPlantsSheet
            }
        }
    }
    
    private var monthNavigationView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.playfair(.semiBold, size: 20))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.playfair(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isToday: calendar.isDateInToday(date),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                            entriesCount: entriesCount(for: date),
                        onTap: {
                            selectedDate = date
                            activeSheet = .dayDetails
                        }
                        )
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 50)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var monthSummaryView: some View {
        let summary = monthSummary
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Month Summary")
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Days with entries")
                        .font(.playfair(.regular, size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("\(summary.daysWithEntries)")
                        .font(.playfair(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total entries")
                        .font(.playfair(.regular, size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("\(summary.totalEntries)")
                        .font(.playfair(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Avg. frequency")
                        .font(.playfair(.regular, size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(String(format: "%.1f", summary.frequency))
                        .font(.playfair(.semiBold, size: 18))
                        .foregroundColor(AppColors.softGreen)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
        .padding(.top, 16)
    }
    
    private func dayDetailsSheet(for date: Date) -> some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    if entriesForDate(date).isEmpty {
                        emptyDayView(for: date)
                    } else {
                        dayEntriesView(for: date)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .navigationTitle(formatDate(date))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        activeSheet = nil
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Entry") {
                        if !dataManager.plants.isEmpty {
                            activeSheet = .addEntry(plant: dataManager.plants.first!, selectedDate: date)
                        } else {
                            activeSheet = .noPlants
                        }
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
    
    private var noPlantsSheet: some View {
        VStack(spacing: 20) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.softGreen)
            
            Text("No Plants Available")
                .font(.playfair(.bold, size: 24))
                .foregroundColor(AppColors.primaryText)
            
            Text("You need to add a plant first before creating entries.")
                .font(.playfair(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button("Close") {
                activeSheet = nil
            }
            .font(.playfair(.semiBold, size: 16))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.primaryBlue)
            .cornerRadius(20)
        }
        .padding(40)
    }
    
    private func emptyDayView(for date: Date) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 8) {
                Text("No entries for this day")
                    .font(.playfair(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first entry for \(formatDate(date))")
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if !dataManager.plants.isEmpty {
                    activeSheet = .addEntry(plant: dataManager.plants.first!, selectedDate: date)
                } else {
                    activeSheet = .noPlants
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Entry")
                }
                .font(.playfair(.semiBold, size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryBlue)
                .cornerRadius(20)
            }
        }
        .padding(40)
    }
    
    private func dayEntriesView(for date: Date) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Entries: \(entriesForDate(date).count)")
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(entriesForDate(date), id: \.id) { entry in
                    DayEntryCardView(
                        entry: entry,
                        plantName: dataManager.getPlant(by: entry.plantId)?.name ?? "Unknown Plant"
                    )
                }
            }
        }
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func entriesCount(for date: Date) -> Int {
        let dayStart = calendar.startOfDay(for: date)
        return monthEntries.filter { calendar.startOfDay(for: $0.date) == dayStart }.count
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
    
    private func formatSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: selectedDate)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isToday: Bool
    let isCurrentMonth: Bool
    let entriesCount: Int
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.playfair(.medium, size: 16))
                    .foregroundColor(textColor)
                
                if entriesCount > 0 {
                    Text("\(entriesCount)")
                        .font(.playfair(.regular, size: 10))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isToday ? 2 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return AppColors.secondaryText.opacity(0.5)
        }
        return isToday ? .white : AppColors.primaryText
    }
    
    private var backgroundColor: Color {
        if !isCurrentMonth {
            return Color.clear
        }
        
        if isToday {
            return AppColors.primaryBlue
        }
        
        if entriesCount > 0 {
            return AppColors.softGreen.opacity(0.3)
        }
        
        return AppColors.lightGray.opacity(0.5)
    }
    
    private var borderColor: Color {
        return isToday ? AppColors.primaryYellow : Color.clear
    }
}

struct DayEntryCardView: View {
    let entry: EntryModel
    let plantName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(plantName)
                    .font(.playfair(.semiBold, size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text(formatTime(entry.date))
                    .font(.playfair(.regular, size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !entry.shortSummary.isEmpty {
                Text(entry.shortSummary)
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
            
            if let note = entry.note, !note.isEmpty {
                Text(note)
                    .font(.playfair(.regular, size: 13))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(3)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.2), radius: 2, x: 0, y: 1)
        )
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
        .environmentObject(DataManager.shared)
}
