import SwiftUI

struct HistoryView: View {
    @ObservedObject var appState: AppState
    @State private var selectedDate: Date = Date()
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private var currentMonth: Date {
        calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
    }
    
    private var cookedRecipesForSelectedDate: [CookedRecipe] {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        return appState.cookedRecipes.filter { cookedRecipe in
            cookedRecipe.dateCook >= startOfDay && cookedRecipe.dateCook < endOfDay
        }
    }
    
    private var weeklyProgress: [Date: Int] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        var progress: [Date: Int] = [:]
        
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                let startOfDay = calendar.startOfDay(for: day)
                let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
                
                let count = appState.cookedRecipes.filter { cookedRecipe in
                    cookedRecipe.dateCook >= startOfDay && cookedRecipe.dateCook < endOfDay
                }.count
                
                progress[day] = count
            }
        }
        
        return progress
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.appTitle)
                        .foregroundColor(.appWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        CalendarView(
                            selectedDate: $selectedDate,
                            cookedRecipes: appState.cookedRecipes
                        )
                        
                        WeeklyProgressView(progress: weeklyProgress)
                        
                        SelectedDateDetailsView(
                            selectedDate: selectedDate,
                            cookedRecipes: cookedRecipesForSelectedDate,
                            appState: appState
                        )
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let cookedRecipes: [CookedRecipe]
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var currentMonth: Date {
        calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
    }
    
    private var monthDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let monthStart = monthInterval.start
        let monthEnd = monthInterval.end
        
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysFromPreviousMonth = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date] = []
        
        for i in (1...daysFromPreviousMonth).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: monthStart) {
                days.append(date)
            }
        }
        
        var currentDate = monthStart
        while currentDate < monthEnd {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        let totalCells = 42
        let remainingCells = totalCells - days.count
        
        for i in 0..<remainingCells {
            if let date = calendar.date(byAdding: .day, value: i, to: monthEnd) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasCookedRecipes(for date: Date) -> Bool {
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        return cookedRecipes.contains { cookedRecipe in
            cookedRecipe.dateCook >= startOfDay && cookedRecipe.dateCook < endOfDay
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.left")
                        .font(.appCallout)
                        .foregroundColor(.appOrange)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(.appHeadline)
                    .foregroundColor(.appWhite)
                
                Spacer()
                
                Button(action: {
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.right")
                        .font(.appCallout)
                        .foregroundColor(.appOrange)
                }
            }
            .padding(.horizontal, 20)
            
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.appCaption)
                        .foregroundColor(.appWhite.opacity(0.6))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(monthDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        selectedDate: selectedDate,
                        currentMonth: currentMonth,
                        hasCookedRecipes: hasCookedRecipes(for: date),
                        onTap: {
                            selectedDate = date
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let selectedDate: Date
    let currentMonth: Date
    let hasCookedRecipes: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    private var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(Color.appOrange)
                } else if isToday {
                    Circle()
                        .stroke(Color.appOrange, lineWidth: 2)
                }
                
                Text(dayNumber)
                    .font(.appCallout)
                    .foregroundColor(
                        isSelected ? .appWhite :
                        isCurrentMonth ? .appWhite :
                        .appWhite.opacity(0.3)
                    )
                
                if hasCookedRecipes && !isSelected {
                    VStack {
                        Spacer()
                        Circle()
                            .fill(Color.appGreen)
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .frame(width: 40, height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WeeklyProgressView: View {
    let progress: [Date: Int]
    
    private let calendar = Calendar.current
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    private var sortedDays: [Date] {
        progress.keys.sorted()
    }
    
    private var maxProgress: Int {
        progress.values.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly Progress")
                    .font(.appTitle3)
                    .foregroundColor(.appWhite)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(sortedDays, id: \.self) { date in
                    VStack(spacing: 8) {
                        let dayProgress = progress[date] ?? 0
                        let height = maxProgress > 0 ? CGFloat(dayProgress) / CGFloat(maxProgress) * 60 : 0
                        
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(dayProgress > 0 ? Color.appGreen : Color.appWhite.opacity(0.2))
                                .frame(height: max(height, 4))
                                .cornerRadius(2)
                        }
                        .frame(height: 60)
                        
                        Text("\(dayProgress)")
                            .font(.appCaption2)
                            .foregroundColor(.appWhite.opacity(0.8))
                        
                        Text(dayFormatter.string(from: date))
                            .font(.appCaption2)
                            .foregroundColor(.appWhite.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}

struct SelectedDateDetailsView: View {
    let selectedDate: Date
    let cookedRecipes: [CookedRecipe]
    @ObservedObject var appState: AppState
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.appTitle3)
                    .foregroundColor(.appWhite)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if cookedRecipes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 40))
                        .foregroundColor(.appWhite.opacity(0.3))
                    
                    Text("No breakfast cooked on this day")
                        .font(.appBody)
                        .foregroundColor(.appWhite.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(cookedRecipes) { cookedRecipe in
                        CookedRecipeCard(
                            cookedRecipe: cookedRecipe,
                            recipe: appState.recipes.first { $0.id == cookedRecipe.recipeId }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct CookedRecipeCard: View {
    let cookedRecipe: CookedRecipe
    let recipe: Recipe?
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.appGreen)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cookedRecipe.recipeName)
                    .font(.appHeadline)
                    .foregroundColor(.appWhite)
                
                HStack {
                    Text("Cooked at \(timeFormatter.string(from: cookedRecipe.dateCook))")
                        .font(.appCaption)
                        .foregroundColor(.appWhite.opacity(0.7))
                    
                    if let recipe = recipe {
                        Spacer()
                        
                        Text(recipe.category.displayName)
                            .font(.appCaption2)
                            .foregroundColor(.appOrange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.appOrange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct FullCalendarView: View {
    @Binding var selectedDate: Date
    let cookedRecipes: [CookedRecipe]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    CalendarView(
                        selectedDate: $selectedDate,
                        cookedRecipes: cookedRecipes
                    )
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.appOrange)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    HistoryView(appState: AppState())
}
