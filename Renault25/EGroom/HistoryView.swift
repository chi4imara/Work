import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var selectedDate = Date()
    @State private var showCalendar = false
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(FontManager.playfairDisplay(.bold, size: 28))
                        .foregroundColor(.primaryWhite)
                    
                    Spacer()
                    
                    Button(action: { showCalendar.toggle() }) {
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryOrange)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                DateSelectorView(selectedDate: $selectedDate)
                
                if viewModel.dailyProgress.isEmpty {
                    EmptyHistoryView()
                    
                    Spacer()
                } else {
                    HistoryContentView(selectedDate: selectedDate)
                }
            }
        }
        .sheet(isPresented: $showCalendar) {
            CalendarView(selectedDate: $selectedDate)
        }
    }
}

struct DateSelectorView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(dateRange, id: \.self) { date in
                    DateButton(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var dateRange: [Date] {
        let calendar = Calendar.current
        let today = Date()
        var dates: [Date] = []
        
        for i in -7...0 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        
        return dates.reversed()
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayName)
                    .font(FontManager.playfairDisplay(.medium, size: 12))
                    .foregroundColor(isSelected ? .primaryWhite : .primaryWhite.opacity(0.6))
                
                Text(dayNumber)
                    .font(FontManager.playfairDisplay(.semibold, size: 16))
                    .foregroundColor(isSelected ? .primaryWhite : .primaryWhite.opacity(0.8))
            }
            .frame(width: 50, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AnyShapeStyle(Color.primaryOrange) : AnyShapeStyle(Color.cardGradient))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.primaryWhite.opacity(0.3))
                
                VStack(spacing: 8) {
                    Text("No History Yet")
                        .font(FontManager.playfairDisplay(.semibold, size: 24))
                        .foregroundColor(.primaryWhite)
                    
                    Text("Complete your first procedure and start tracking your progress")
                        .font(FontManager.playfairDisplay(.regular, size: 16))
                        .foregroundColor(.primaryWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
    }
}

struct HistoryContentView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    let selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let progress = viewModel.getProgressForDate(selectedDate) {
                    ProgressOverviewCard(progress: progress)
                    
                    if !progress.completedProcedures.isEmpty {
                        CompletedProceduresCard(procedureIds: progress.completedProcedures)
                    }
                    
                    if !progress.healthMetrics.isEmpty {
                        HealthMetricsCard(metrics: progress.healthMetrics)
                    }
                    
                    if let challenge = progress.completedChallenge {
                        CompletedChallengeCard(challenge: challenge)
                    }
                } else {
                    NoDataForDateView(date: selectedDate)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ProgressOverviewCard: View {
    let progress: DailyProgress
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Daily Progress")
                    .font(FontManager.playfairDisplay(.semibold, size: 20))
                    .foregroundColor(.primaryWhite)
                
                Spacer()
                
                Text("\(Int(progress.progressPercentage * 100))%")
                    .font(FontManager.playfairDisplay(.bold, size: 24))
                    .foregroundColor(.primaryOrange)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primaryWhite.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primaryOrange)
                        .frame(width: geometry.size.width * progress.progressPercentage, height: 8)
                        .animation(.easeInOut(duration: 1), value: progress.progressPercentage)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
}

struct CompletedProceduresCard: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    let procedureIds: [UUID]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.successGreen)
                
                Text("Completed Procedures")
                    .font(FontManager.playfairDisplay(.semibold, size: 18))
                    .foregroundColor(.primaryWhite)
                
                Spacer()
                
                Text("\(procedureIds.count)")
                    .font(FontManager.playfairDisplay(.medium, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.6))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.primaryWhite.opacity(0.1))
                    )
            }
            
            LazyVStack(spacing: 8) {
                ForEach(completedProcedures, id: \.id) { procedure in
                    HStack {
                        Image(systemName: procedure.category.icon)
                            .font(.system(size: 14))
                            .foregroundColor(.primaryOrange)
                            .frame(width: 20)
                        
                        Text(procedure.name)
                            .font(FontManager.playfairDisplay(.regular, size: 14))
                            .foregroundColor(.primaryWhite)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
    
    private var completedProcedures: [Procedure] {
        viewModel.procedures.filter { procedureIds.contains($0.id) }
    }
}

struct HealthMetricsCard: View {
    let metrics: [HealthMetric]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryOrange)
                
                Text("Health Metrics")
                    .font(FontManager.playfairDisplay(.semibold, size: 18))
                    .foregroundColor(.primaryWhite)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(metrics, id: \.id) { metric in
                    VStack(spacing: 4) {
                        Text(metric.name)
                            .font(FontManager.playfairDisplay(.medium, size: 12))
                            .foregroundColor(.primaryWhite.opacity(0.7))
                        
                        Text("\(metric.value) \(metric.unit)")
                            .font(FontManager.playfairDisplay(.semibold, size: 14))
                            .foregroundColor(.primaryWhite)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primaryWhite.opacity(0.1))
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
}

struct CompletedChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.successGreen)
                
                Text("Daily Challenge")
                    .font(FontManager.playfairDisplay(.semibold, size: 18))
                    .foregroundColor(.primaryWhite)
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.successGreen)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(challenge.title)
                    .font(FontManager.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryWhite)
                
                Text(challenge.description)
                    .font(FontManager.playfairDisplay(.regular, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.8))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
}

struct NoDataForDateView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.primaryWhite.opacity(0.3))
            
            VStack(spacing: 8) {
                Text("No Data")
                    .font(FontManager.playfairDisplay(.semibold, size: 20))
                    .foregroundColor(.primaryWhite)
                
                Text("No activities recorded for \(formatDate(date))")
                    .font(FontManager.playfairDisplay(.regular, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardGradient)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        DatePicker(
                            "Select Date",
                            selection: $selectedDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(.primaryOrange)
                        .padding()
                    }
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .preferredColorScheme(.dark)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(GroomingViewModel())
    }
}
