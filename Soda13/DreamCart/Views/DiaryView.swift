import SwiftUI

struct DiaryView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    @State private var showingNewEntry = false
    @State private var selectedEntry: BeautyEntry?
    @State private var showingEntryDetail = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
    
                entriesListView
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView(viewModel: viewModel)
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(viewModel: viewModel, entry: entry)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Beauty Diary")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Button(action: {
                    showingNewEntry = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color.theme.primaryBlue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
    
    private var calendarView: some View {
        VStack(spacing: 12) {
            HStack {
                Text(monthYearString)
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(height: 30)
                }
                
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                        hasEntries: hasEntries(for: date),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: viewModel.selectedDate, toGranularity: .month)
                    ) {
                        viewModel.selectDate(date)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    private var entriesListView: some View {
        VStack(spacing: 16) {
            if !viewModel.entries.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.entries) { entry in
                            EntryCardView(entry: entry, viewModel: viewModel) {
                                selectedEntry = entry
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 84)
                }
            } else {
                emptyStateView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.lightGray)
            
            Text("No entries for selected day")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("Add your first procedure to start your beauty diary!")
                .font(.playfairDisplay(14))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingNewEntry = true
            }) {
                Text("Add Entry")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryButtonText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.theme.secondaryButtonBackground)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: viewModel.selectedDate)
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: viewModel.selectedDate)?.start ?? Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        for i in 0..<42 { 
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(day)
            }
        }
        return days
    }
    
    private func hasEntries(for date: Date) -> Bool {
        let calendar = Calendar.current
        return viewModel.entries.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEntries: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.theme.primaryBlue : Color.clear)
                    .frame(width: 36, height: 36)
                
                Text(dayNumber)
                    .font(.playfairDisplay(14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(
                        isSelected ? Color.white :
                        isCurrentMonth ? Color.theme.primaryText : Color.theme.lightGray
                    )
                
                if hasEntries && !isSelected {
                    Circle()
                        .fill(Color.theme.primaryYellow)
                        .frame(width: 6, height: 6)
                        .offset(x: 12, y: -12)
                }
            }
        }
        .frame(height: 40)
    }
}

struct EntryCardView: View {
    let entry: BeautyEntry
    @ObservedObject var viewModel: BeautyDiaryViewModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.procedureName)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: entry)
                    }) {
                        Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(entry.isFavorite ? Color.theme.accentPink : Color.theme.lightGray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Text(entry.products)
                    .font(.playfairDisplay(14))
                    .foregroundColor(Color.theme.secondaryText)
                    .lineLimit(2)
                
                if entry.hasNotes {
                    Text(entry.notes)
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.accentText)
                        .lineLimit(1)
                }
            }
            .padding(16)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DiaryView(viewModel: BeautyDiaryViewModel())
}
