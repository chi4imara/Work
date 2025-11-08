import SwiftUI

struct MedicationDetailView: View {
    let medication: Medication
    let onUpdate: (Medication) -> Void
    let onDelete: () -> Void
    
    @ObservedObject private var viewModel = MedicationViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var selectedHistoryPeriod = 30
    
    private let historyPeriods = [7, 14, 30, 60]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        medicationInfoCard
                        
                        quickActionsCard
                        
                        historyPeriodSelector
                        
                        historyCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(medication.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            showingEditSheet = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditMedicationView(medication: medication) { updatedMedication in
                onUpdate(updatedMedication)
            }
        }
        .alert("Delete Medication", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \(medication.name)? This will remove all associated doses and cannot be undone.")
        }
    }
    
    private var medicationInfoCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(medication.name)
                    .font(AppFonts.title1())
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.cardText)
                
                Text(medication.dosage)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.cardSecondaryText)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppColors.accentBlue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Treatment Period")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text(periodString)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardText)
                }
            }
            
            HStack {
                Image(systemName: "repeat")
                    .foregroundColor(AppColors.accentBlue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Days")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text(daysString)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardText)
                }
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(AppColors.accentBlue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Times")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text(medication.times.joined(separator: ", "))
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardText)
                }
            }
            
            if let comment = medication.comment, !comment.isEmpty {
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(AppColors.accentBlue)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Comment")
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.cardSecondaryText)
                        
                        Text(comment)
                            .font(AppFonts.callout())
                            .foregroundColor(AppColors.cardText)
                    }
                }
            }
        }
        .padding(20)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var quickActionsCard: some View {
        VStack(spacing: 15) {
            Text("Quick Actions")
                .font(AppFonts.title3())
                .fontWeight(.semibold)
                .foregroundColor(AppColors.cardText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                Button("Mark all doses for today as taken") {
                    markTodayDoses(as: .taken)
                }
                .buttonStyle(ActionButtonStyle(color: AppColors.successGreen))
                
                Button("Mark all doses for today as missed") {
                    markTodayDoses(as: .missed)
                }
                .buttonStyle(ActionButtonStyle(color: AppColors.errorRed))
                
                Button("Reset today's doses") {
                    markTodayDoses(as: .notMarked)
                }
                .buttonStyle(ActionButtonStyle(color: AppColors.secondaryButton))
            }
        }
        .padding(20)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var historyPeriodSelector: some View {
        HStack {
            Text("History Period:")
                .font(AppFonts.callout())
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Menu {
                ForEach(historyPeriods, id: \.self) { period in
                    Button("\(period) days") {
                        selectedHistoryPeriod = period
                    }
                }
            } label: {
                HStack {
                    Text("\(selectedHistoryPeriod) days")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.primaryText)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.primaryText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.secondaryButton)
                .clipShape(Capsule())
            }
        }
    }
    
    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("History (Last \(selectedHistoryPeriod) days)")
                .font(AppFonts.title3())
                .fontWeight(.semibold)
                .foregroundColor(AppColors.cardText)
            
            let historyDoses = getHistoryDoses()
            
            if historyDoses.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text("No history available")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardSecondaryText)
                    
                    Text("Start marking doses to see your history here")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(historyDoses) { dose in
                        HistoryDoseRow(
                            dose: dose,
                            onStatusChange: { status in
                                viewModel.updateDoseStatus(dose, status: status)
                            }
                        )
                    }
                }
            }
        }
        .padding(20)
        .concaveCard(color: AppColors.cardBackground)
    }
    
    private var periodString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let startString = formatter.string(from: medication.startDate)
        
        if let endDate = medication.endDate {
            let endString = formatter.string(from: endDate)
            return "\(startString) - \(endString)"
        } else {
            return "From \(startString) (Ongoing)"
        }
    }
    
    private var daysString: String {
        let sortedDays = medication.days.sorted { $0.dayNumber < $1.dayNumber }
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
    }
    
    private func markTodayDoses(as status: Dose.DoseStatus) {
        viewModel.markAllDosesForDay(Date(), status: status)
    }
    
    private func getHistoryDoses() -> [Dose] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -selectedHistoryPeriod, to: endDate) ?? endDate
        
        return viewModel.doses
            .filter { dose in
                dose.medicationId == medication.id &&
                dose.date >= startDate &&
                dose.date <= endDate
            }
            .sorted { $0.date > $1.date || ($0.date == $1.date && $0.time > $1.time) }
    }
}

struct HistoryDoseRow: View {
    let dose: Dose
    let onStatusChange: (Dose.DoseStatus) -> Void
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dose.date)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateString)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.cardText)
                
                Text(dose.time)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.cardSecondaryText)
            }
            
            Spacer()
            
            Button(action: cycleStatus) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(dose.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text(dose.status.displayName)
                        .font(AppFonts.callout())
                        .fontWeight(.medium)
                }
                .foregroundColor(dose.status.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(dose.status.color.opacity(0.1))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(dose.status.color, lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 4)
    }
    
    private func cycleStatus() {
        let nextStatus: Dose.DoseStatus
        switch dose.status {
        case .notMarked: nextStatus = .taken
        case .taken: nextStatus = .missed
        case .missed: nextStatus = .notMarked
        }
        onStatusChange(nextStatus)
    }
}

struct ActionButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.callout())
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(color)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct EditMedicationView: View {
    let medication: Medication
    let onSave: (Medication) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var dosage: String
    @State private var selectedDaySchedule: DayScheduleType = .custom
    @State private var customDays: Set<Medication.WeekDay>
    @State private var times: [String]
    @State private var startDate: Date
    @State private var hasEndDate: Bool
    @State private var endDate: Date
    @State private var comment: String
    
    @State private var showingTimePickerIndex: Int? = nil
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(medication: Medication, onSave: @escaping (Medication) -> Void) {
        self.medication = medication
        self.onSave = onSave
        
        _name = State(initialValue: medication.name)
        _dosage = State(initialValue: medication.dosage)
        _customDays = State(initialValue: Set(medication.days))
        _times = State(initialValue: medication.times)
        _startDate = State(initialValue: medication.startDate)
        _hasEndDate = State(initialValue: medication.endDate != nil)
        _endDate = State(initialValue: medication.endDate ?? Date())
        _comment = State(initialValue: medication.comment ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Edit functionality would be implemented here")
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.primaryText)
                            .padding(40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Edit Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

