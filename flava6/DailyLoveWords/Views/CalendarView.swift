import SwiftUI

struct CalendarDay: Identifiable {
    let id: String
    let date: Date?
}

struct CalendarView: View {
    @ObservedObject var wordStore: WordStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showingWordDetail = false
    @State private var selectedWord: Word?
    @State private var showingAddWord = false
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        monthHeader
                        
                        calendarGrid
                        
                        selectedDateInfo
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWord = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddWord) {
            AddEditWordView(wordStore: wordStore, editingWord: nil, selectedDate: selectedDate)
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(wordStore: wordStore, word: word)
        }
    }
    
    private var monthHeader: some View {
        VStack(spacing: 12) {
            PixelCard {
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Text(monthYearString)
                        .font(FontManager.title1)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
    
    private var calendarGrid: some View {
        PixelCard {
            VStack(spacing: 0) {
                HStack {
                    ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 10)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(calendarDays) { calendarDay in
                        if let date = calendarDay.date {
                            CalendarDayView(
                                date: date,
                                word: wordStore.wordForDate(date),
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isToday: calendar.isDateInToday(date),
                                isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                                onTap: {
                                    selectedDate = date
                                },
                                onLongPress: {
                                    selectedDate = date
                                    showingAddWord = true
                                }
                            )
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 40)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: currentMonth)
            }
            .padding(.vertical, 10)
        }
    }
    
    private var selectedDateInfo: some View {
        VStack(spacing: 16) {
            if let word = wordStore.wordForDate(selectedDate) {
                PixelCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(selectedDateString)
                                .font(FontManager.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button("View Details") {
                                selectedWord = word
                            }
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.primaryBlue)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Word: \(word.word)")
                                .font(FontManager.title2)
                                .foregroundColor(AppColors.primaryText)
                            
                            if let translation = word.translation, !translation.isEmpty {
                                Text("Translation: \(translation)")
                                    .font(FontManager.body)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            if let comment = word.comment, !comment.isEmpty {
                                Text("Comment: \(comment)")
                                    .font(FontManager.callout)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                }
            } else {
                PixelCard {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.lightBlue)
                        
                        VStack(spacing: 8) {
                            Text("No word for this date")
                                .font(FontManager.title2)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Add a word to start building your collection")
                                .font(FontManager.body)
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 12) {
                            if wordStore.wordForDate(selectedDate) != nil {
                                VStack(spacing: 8) {
                                    Text("⚠️ Word already exists for this date")
                                        .font(FontManager.caption)
                                        .foregroundColor(AppColors.error)
                                    
                                    PixelButton(
                                        title: "Replace Word",
                                        action: { showingAddWord = true },
                                        color: AppColors.error
                                    )
                                }
                            } else {
                                PixelButton(
                                    title: "Add Word",
                                    action: { showingAddWord = true },
                                    color: AppColors.primaryBlue
                                )
                            }
                            
                            Text("Selected date: \(selectedDateString)")
                                .font(FontManager.caption)
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
        }
    }
    
    private var calendarDays: [CalendarDay] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let range = calendar.range(of: .day, in: .month, for: currentMonth) ?? 1..<32
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        var days: [CalendarDay] = []
        
        for i in 1..<firstWeekday {
            days.append(CalendarDay(id: "empty-\(i)", date: nil))
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(CalendarDay(id: "day-\(day)", date: date))
            }
        }
        
        return days
    }
    
    private var monthYearString: String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    
    private var selectedDateString: String {
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: selectedDate)
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

struct CalendarDayView: View {
    let date: Date
    let word: Word?
    let isSelected: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(FontManager.caption)
                    .foregroundColor(textColor)
                
                if word != nil {
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .clipShape(Circle())
        }
        .disabled(!isCurrentMonth)
        .onLongPressGesture {
            if isCurrentMonth {
                onLongPress()
            }
        }
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return AppColors.secondaryText.opacity(0.3)
        } else if isSelected {
            return .white
        } else if isToday {
            return AppColors.primaryBlue
        } else {
            return AppColors.primaryText
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppColors.primaryBlue
        } else if isToday {
            return AppColors.lightBlue.opacity(0.3)
        } else {
            return Color.clear
        }
    }
}

#Preview {
    CalendarView(wordStore: WordStore())
}
