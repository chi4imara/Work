import SwiftUI

struct CalendarView: View {
    @ObservedObject private var viewModel = MedicationViewModel.shared
    @State private var selectedDate = Date()
    @State private var showingDayDetail = false
    @State private var showingAddMedication = false
    @State private var showingReference = false
    @State private var showingMenu = false
    @State private var calendarPeriod: CalendarPeriod = .month
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        
                        calendarView
                        
                        todaySummaryView
                        
                        upcomingDosesView
                        
                        if viewModel.medications.isEmpty {
                            emptyStateView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingDayDetail) {
            DayDetailSheet(
                date: selectedDate,
                doses: viewModel.getDosesForDay(selectedDate),
                medications: viewModel.medications,
                onStatusChange: { dose, status in
                    viewModel.updateDoseStatus(dose, status: status)
                }
            )
        }
        .sheet(isPresented: $showingAddMedication) {
            AddMedicationView { medication in
                viewModel.addMedication(medication)
            }
        }
        .sheet(isPresented: $showingReference) {
            ReferenceView()
        }
        .onAppear {
            viewModel.loadData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .dataCleared)) { _ in
            viewModel.loadData()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Calendar")
                .font(AppFonts.largeTitle())
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddMedication = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.top, 10)
    }
    
    private var calendarView: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.cardText)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(AppFonts.title2())
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardText)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.cardText)
                }
            }
            .padding(.horizontal, 20)
            
            if calendarPeriod == .month {
                monthCalendarGrid
            } else {
                weekCalendarGrid
            }
        }
        .frame(maxWidth: .infinity)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var monthCalendarGrid: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(AppFonts.caption())
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.cardSecondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        isToday: Calendar.current.isDateInToday(date),
                        status: viewModel.getDayStatus(for: date)
                    ) {
                        selectedDate = date
                        showingDayDetail = true
                    }
                }
            }
        }
        .padding(15)
    }
    
    private var weekCalendarGrid: some View {
        HStack(spacing: 8) {
            ForEach(weekDays, id: \.self) { date in
                VStack(spacing: 4) {
                    Text(dayOfWeekString(date))
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    CalendarDayView(
                        date: date,
                        isCurrentMonth: true,
                        isToday: Calendar.current.isDateInToday(date),
                        status: viewModel.getDayStatus(for: date)
                    ) {
                        selectedDate = date
                        showingDayDetail = true
                    }
                }
            }
        }
        .padding(15)
    }
    
    private var todaySummaryView: some View {
        let summary = viewModel.getTodaySummary()
        
        return VStack(spacing: 15) {
            HStack {
                Text("Today")
                    .font(AppFonts.title2())
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardText)
                
                Spacer()
            }
            
            Text("Scheduled: \(summary.scheduled) • Taken: \(summary.taken) • Missed: \(summary.missed) • Unmarked: \(summary.unmarked)")
                .font(AppFonts.callout())
                .foregroundColor(AppColors.cardSecondaryText)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 15) {
                Button {
                    viewModel.markAllDosesForDay(Date(), status: .taken)
                } label: {
                    Text("Mark All as Taken")
                        .font(AppFonts.callout())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(AppColors.successGreen)
                        .cornerRadius(12)
                }
                
                Button {
                    viewModel.resetDosesForDay(Date())
                } label: {
                    Text("Reset Day")
                        .font(AppFonts.callout())
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(AppColors.secondaryButton)
                        .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var upcomingDosesView: some View {
        let upcomingDoses = viewModel.getUpcomingDoses()
        
        return VStack(spacing: 15) {
            HStack {
                Text("Upcoming Doses (24h)")
                    .font(AppFonts.title3())
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardText)
                
                Spacer()
            }
            
            if upcomingDoses.isEmpty {
                Text("No upcoming doses")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.cardSecondaryText)
                    .padding(.vertical, 20)
            } else {
                ForEach(upcomingDoses) { dose in
                    UpcomingDoseRow(
                        dose: dose,
                        medication: viewModel.medications.first { $0.id == dose.medicationId }
                    ) { status in
                        viewModel.updateDoseStatus(dose, status: status)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "pills")
                .font(.system(size: 60))
                .foregroundColor(Color.gray)
            
            Text("No medications added")
                .font(AppFonts.title2())
                .foregroundColor(Color.gray)
            
            Button {
                showingAddMedication = true
            } label: {
                Text("Add First Medication")
                    .font(AppFonts.callout())
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryButton)
                    .cornerRadius(12)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    private var calendarDays: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let startOfCalendar = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        var currentDate = startOfCalendar
        
        for _ in 0..<42 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        
        var days: [Date] = []
        var currentDate = startOfWeek
        
        for _ in 0..<7 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func dayOfWeekString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
    }
    
    private func nextMonth() {
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
    }
}

struct CalendarDayView: View {
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    let status: DayStatus
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
                    .fill(status.color.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(status.color, lineWidth: status == .noDoses ? 0 : 2)
                    )
                
                if isToday {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.accentBlue, lineWidth: 2)
                }
                
                Text(dayNumber)
                    .font(AppFonts.callout())
                    .fontWeight(isToday ? .bold : .regular)
                    .foregroundColor(isCurrentMonth ? AppColors.cardText : AppColors.cardSecondaryText.opacity(0.5))
            }
        }
        .frame(height: 40)
    }
}

struct UpcomingDoseRow: View {
    let dose: Dose
    let medication: Medication?
    let onStatusChange: (Dose.DoseStatus) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dose.time)
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.cardText)
                
                if let medication = medication {
                    Text("\(medication.name) - \(medication.dosage)")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardSecondaryText)
                }
            }
            
            Spacer()
            
            Button(dose.status.displayName) {
                let nextStatus: Dose.DoseStatus
                switch dose.status {
                case .notMarked: nextStatus = .taken
                case .taken: nextStatus = .missed
                case .missed: nextStatus = .notMarked
                }
                onStatusChange(nextStatus)
            }
            .font(AppFonts.callout())
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(dose.status.color)
            .clipShape(Capsule())
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    CalendarView()
}
