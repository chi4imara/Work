import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var proceduresForSelectedDate: [Procedure] {
        let calendar = Calendar.current
        return dataManager.procedures.filter { procedure in
            calendar.isDate(procedure.date, inSameDayAs: selectedDate)
        }
    }
    
    private var proceduresByDate: [Date: [Procedure]] {
        Dictionary(grouping: dataManager.procedures) { procedure in
            calendar.startOfDay(for: procedure.date)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Calendar")
                            .font(.custom("PlayfairDisplay-Bold", size: 32))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            MonthHeaderView(currentMonth: $currentMonth)
                            
                            CalendarGridView(
                                currentMonth: currentMonth,
                                selectedDate: $selectedDate,
                                proceduresByDate: proceduresByDate
                            )
                            
                            if !proceduresForSelectedDate.isEmpty {
                                SelectedDateProceduresView(procedures: proceduresForSelectedDate)
                            } else {
                                Text("No procedures on this date")
                                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding()
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MonthHeaderView: View {
    @Binding var currentMonth: Date
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        HStack {
            Button(action: {
                changeMonth(-1)
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.primaryText)
                    .font(.title3)
            }
            
            Spacer()
            
            Text(monthYearFormatter.string(from: currentMonth))
                .font(.custom("PlayfairDisplay-Bold", size: 20))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                changeMonth(1)
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.primaryText)
                    .font(.title3)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func changeMonth(_ direction: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: direction, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

struct CalendarGridView: View {
    let currentMonth: Date
    @Binding var selectedDate: Date
    let proceduresByDate: [Date: [Procedure]]
    
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth) - 1
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.custom("PlayfairDisplay-SemiBold", size: 12))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(0..<daysInMonth.count, id: \.self) { index in
                    if let date = daysInMonth[index] {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasProcedures: proceduresByDate[calendar.startOfDay(for: date)] != nil,
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
    }
    
    private var calendar: Calendar {
        Calendar.current
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasProcedures: Bool
    let isCurrentMonth: Bool
    let action: () -> Void
    
    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isSelected ? AnyShapeStyle(AppColors.purpleGradient) : AnyShapeStyle(Color.clear))
                    .frame(width: 36, height: 36)
                
                VStack(spacing: 2) {
                    Text("\(dayNumber)")
                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                        .foregroundColor(isSelected ? .white : (isCurrentMonth ? AppColors.primaryText : AppColors.secondaryText))
                    
                    if hasProcedures {
                        Circle()
                            .fill(isSelected ? .white : AppColors.accentYellow)
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .frame(height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SelectedDateProceduresView: View {
    let procedures: [Procedure]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Procedures on \(DateFormatter.shortDate.string(from: procedures.first?.date ?? Date()))")
                .font(.custom("PlayfairDisplay-Bold", size: 18))
                .foregroundColor(AppColors.primaryText)
            
            ForEach(procedures) { procedure in
                NavigationLink(destination: ProcedureDetailView(procedure: procedure)) {
                    HStack {
                        Image(systemName: procedure.category.icon)
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(procedure.name)
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            if !procedure.products.isEmpty {
                                Text(procedure.products)
                                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CalendarView()
        .environmentObject(DataManager())
}

