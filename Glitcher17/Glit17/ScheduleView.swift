import SwiftUI

struct ScheduleView: View {
    @ObservedObject var appState: AppState
    @State private var showingNewProcedure = false
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Schedule")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showingNewProcedure = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(ColorManager.accentYellow)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(ColorManager.cardBackground)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                DateSelectorView(selectedDate: $appState.selectedDate)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        let todaysProcedures = appState.proceduresFor(date: appState.selectedDate)
                        
                        if appState.allProceduresCompletedFor(date: appState.selectedDate) && !todaysProcedures.isEmpty {
                            CompletionBannerView()
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                        }
                        
                        if todaysProcedures.isEmpty {
                            EmptyStateView(
                                message: "No procedures for this day.",
                                icon: "calendar.badge.exclamationmark"
                            )
                            .padding(.top, 60)
                        } else {
                            ForEach(todaysProcedures) { procedure in
                                ProcedureCardView(
                                    procedure: procedure,
                                    selectedDate: appState.selectedDate,
                                    appState: appState
                                )
                                .padding(.horizontal, 20)
                            }
                            .padding(.top, 10)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingNewProcedure) {
            NewProcedureView(appState: appState)
        }
    }
}

struct DateSelectorView: View {
    @Binding var selectedDate: Date
    @State private var weekOffset = 0
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private var weekDays: [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        let adjustedStart = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: startOfWeek) ?? startOfWeek
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: adjustedStart)
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        weekOffset -= 1
                        if let newDate = calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate) {
                            selectedDate = newDate
                        }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorManager.textWhite)
                }
                
                Spacer()
                
                Text(weekRangeText)
                    .font(FontManager.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.textWhite)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        weekOffset += 1
                        if let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate) {
                            selectedDate = newDate
                        }
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorManager.textWhite)
                }
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 8) {
                ForEach(weekDays, id: \.self) { date in
                    DayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: weekDays.first ?? selectedDate)
    }
}

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
    
    private var numberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(FontManager.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.primaryPurple : ColorManager.textSecondary)
                
                Text(numberFormatter.string(from: date))
                    .font(FontManager.ubuntu(16, weight: .bold))
                    .foregroundColor(isSelected ? ColorManager.primaryPurple : ColorManager.textWhite)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? ColorManager.accentYellow : ColorManager.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProcedureCardView: View {
    let procedure: Procedure
    let selectedDate: Date
    @ObservedObject var appState: AppState
    @State private var showingDetails = false
    
    private var isCompleted: Bool {
        procedure.isCompletedOn(date: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(procedure.name)
                        .font(FontManager.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    HStack(spacing: 16) {
                        Label(procedure.category.name, systemImage: "tag")
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.textSecondary)
                        
                        Label(procedure.frequency.displayText, systemImage: "clock")
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.textSecondary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    appState.toggleProcedureCompletion(procedure, on: selectedDate)
                }) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(isCompleted ? ColorManager.successGreen : ColorManager.textSecondary)
                }
            }
            
            Button(action: {
                showingDetails = true
            }) {
                Text("More details")
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.accentYellow)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
        .sheet(isPresented: $showingDetails) {
            ProcedureDetailsView(procedureId: procedure.id, appState: appState)
        }
    }
}

struct CompletionBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(ColorManager.successGreen)
            
            Text("All procedures for today are completed.")
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.textWhite)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.successGreen.opacity(0.2))
        )
    }
}

struct EmptyStateView: View {
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(ColorManager.textSecondary)
            
            Text(message)
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

#Preview {
    ScheduleView(appState: AppState())
}
