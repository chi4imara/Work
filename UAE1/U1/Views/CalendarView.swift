import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var selectedDate = Date()
    @State private var selectedProcedure: Procedure?
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    init(viewModel: ProcedureViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                ScrollView {
                    LazyVStack(spacing: 20) {
                        calendarView
                        
                        selectedDateProceduresView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: $selectedProcedure) { procedure in
            ProcedureDetailView(viewModel: viewModel, procedureId: procedure.id)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Calendar")
                .font(FontManager.ubuntu(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var calendarView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.accent)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.accent)
                }
            }
            .padding(.horizontal, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(FontManager.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                        .frame(height: 30)
                }
                
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        hasProcedures: !viewModel.proceduresFor(date: date).isEmpty
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(16)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
    }
    
    private var selectedDateProceduresView: some View {
        let procedures = viewModel.proceduresFor(date: selectedDate)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Procedures for \(selectedDate, formatter: shortDateFormatter)")
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
            }
            
            if procedures.isEmpty {
                Text("No procedures on this date")
                    .font(FontManager.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(ColorManager.cardBackground)
                    .cornerRadius(12)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(procedures) { procedure in
                        ProcedureRowView(procedure: procedure) {
                            selectedProcedure = procedure
                        }
                    }
                }
            }
        }
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstDayWeekday = calendar.component(.weekday, from: firstOfMonth)
        let daysFromPreviousMonth = firstDayWeekday - 1
        
        var days: [Date] = []
        
        for i in (1...daysFromPreviousMonth).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
        for i in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: i, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        let totalCells = 42
        let remainingCells = totalCells - days.count
        let lastDayOfMonth = days.last ?? currentMonth
        
        for i in 1...remainingCells {
            if let date = calendar.date(byAdding: .day, value: i, to: lastDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
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
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasProcedures: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(ColorManager.accentGradient)
                } else {
                    Circle()
                        .fill(Color.clear)
                }
                
                Text("\(calendar.component(.day, from: date))")
                    .font(FontManager.ubuntu(14, weight: isSelected ? .medium : .regular))
                    .foregroundColor(dayTextColor)
                
                if hasProcedures && !isSelected {
                    VStack {
                        Spacer()
                        Circle()
                            .fill(ColorManager.accent)
                            .frame(width: 4, height: 4)
                            .offset(y: -2)
                    }
                }
            }
            .frame(width: 36, height: 36)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dayTextColor: Color {
        if isSelected {
            return ColorManager.primaryText
        } else if isCurrentMonth {
            return ColorManager.primaryText
        } else {
            return ColorManager.tertiaryText
        }
    }
}

#Preview {
    CalendarView(viewModel: ProcedureViewModel())
}
