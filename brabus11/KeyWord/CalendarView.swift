import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: DictionaryViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var presentedSheet: SheetType?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 25) {
                        calendarSection
                        wordsForSelectedDate
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: Binding(
            get: { presentedSheet ?? viewModel.presentedSheet },
            set: { newValue in
                guard let sheetType = newValue else {
                    presentedSheet = nil
                    viewModel.presentedSheet = nil
                    return
                }
                
                switch sheetType {
                case .wordDetail:
                    presentedSheet = sheetType
                    viewModel.presentedSheet = nil
                case .editWord:
                    viewModel.presentedSheet = sheetType
                    presentedSheet = nil
                case .addWord:
                    viewModel.presentedSheet = sheetType
                    presentedSheet = nil
                }
            }
        )) { sheetType in
            sheetContent(for: sheetType)
        }
    }
    
    @ViewBuilder
    private func sheetContent(for sheetType: SheetType) -> some View {
        switch sheetType {
        case .addWord:
            WordFormView(
                viewModel: WordFormViewModel(),
                onSave: { word in
                    viewModel.addWord(word)
                    presentedSheet = nil
                    viewModel.presentedSheet = nil
                },
                onCancel: {
                    presentedSheet = nil
                    viewModel.presentedSheet = nil
                }
            )
        case .editWord(let wordId):
            if let word = viewModel.getWordById(wordId) {
                WordFormView(
                    viewModel: WordFormViewModel(editingWord: word),
                    editingWord: word,
                    onSave: { updatedWord in
                        viewModel.updateWord(updatedWord)
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    },
                    onCancel: {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
                )
            } else {
                EmptyView()
                    .onAppear {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
            }
        case .wordDetail(let wordId):
            if let word = viewModel.getWordById(wordId) {
                WordDetailView(
                    word: word,
                    onEdit: {
                        presentedSheet = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.showEditWordSheet(word)
                        }
                    },
                    onDelete: {
                        viewModel.confirmDelete(word)
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    },
                    onDismiss: {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
                )
            } else {
                EmptyView()
                    .onAppear {
                        presentedSheet = nil
                        viewModel.presentedSheet = nil
                    }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Calendar")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var calendarSection: some View {
        VStack(spacing: 0) {
            monthNavigation
            
            calendarGrid
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.bottom, 10)
    }
    
    private var monthNavigation: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryBlue)
            }
            
            Spacer()
            
            Text(monthYearString)
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.textBlue)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryBlue)
            }
        }
        .padding(20)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 10) {
            weekdaysHeader
            
            calendarDaysGrid
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var weekdaysHeader: some View {
        HStack(spacing: 10) {
            ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var calendarDaysGrid: some View {
        let rows = (0..<Int(ceil(Double(calendarDays.count) / 7.0))).map { rowIndex in
            Array(calendarDays.enumerated().filter { $0.offset >= rowIndex * 7 && $0.offset < (rowIndex + 1) * 7 })
        }
        
        return VStack(spacing: 10) {
            ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                HStack(spacing: 10) {
                    ForEach(Array(row.enumerated()), id: \.offset) { colIndex, item in
                        Group {
                            if let date = item.element {
                                CalendarDayView(
                                    date: date,
                                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                    isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
                                    hasWords: hasWordsOnDate(date),
                                    wordCount: wordsCountOnDate(date)
                                ) {
                                    selectedDate = date
                                }
                            } else {
                                Color.clear
                                    .frame(height: 40)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    if row.count < 7 {
                        ForEach(0..<(7 - row.count), id: \.self) { _ in
                            Color.clear
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
    
    private var wordsForSelectedDate: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Words on \(formatDate(selectedDate))")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.textBlue)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            let wordsOnDate = wordsForDate(selectedDate)
            
            if wordsOnDate.isEmpty {
                emptyStateView
            } else {
                VStack(spacing: 0) {
                    ForEach(wordsOnDate) { word in
                        CalendarWordRow(word: word) {
                            presentedSheet = .wordDetail(word.id)
                        }
                        if word.id != wordsOnDate.last?.id {
                            Divider().padding(.horizontal, 20)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Text("No words added on this date")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorManager.darkGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: ColorManager.primaryBlue.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var calendarDays: [Date?] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func hasWordsOnDate(_ date: Date) -> Bool {
        return !wordsForDate(date).isEmpty
    }
    
    private func wordsCountOnDate(_ date: Date) -> Int {
        return wordsForDate(date).count
    }
    
    private func wordsForDate(_ date: Date) -> [WordEntry] {
        let calendar = Calendar.current
        return viewModel.words.filter { word in
            calendar.isDate(word.dateCreated, inSameDayAs: date)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasWords: Bool
    let wordCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(ColorManager.primaryBlue)
                        .frame(width: 40, height: 40)
                }
                
                VStack(spacing: 4) {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.playfairDisplay(16, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? .white : (isToday ? ColorManager.primaryBlue : ColorManager.textBlue))
                    
                    if hasWords {
                        Circle()
                            .fill(isSelected ? Color.white.opacity(0.8) : ColorManager.primaryBlue)
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarWordRow: View {
    let word: WordEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.selection()
            onTap()
        }) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(word.word)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(ColorManager.textBlue)
                    
                    if !word.association.isEmpty {
                        Text(word.association)
                            .font(.playfairDisplay(13, weight: .regular))
                            .foregroundColor(ColorManager.darkGray.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            }
            .padding(20)
        }
    }
}
