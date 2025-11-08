import SwiftUI

struct DayDetailSheet: View {
    let date: Date
    let doses: [Dose]
    let medications: [Medication]
    let onStatusChange: (Dose, Dose.DoseStatus) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("Doses for")
                            .font(AppFonts.callout())
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(dateString)
                            .font(AppFonts.title2())
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    if doses.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 50))
                                .foregroundColor(Color.gray)
                            
                            Text("No doses scheduled for this day")
                                .font(AppFonts.callout())
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(40)
                        .frame(maxWidth: .infinity)
                        .concaveCard(color: AppColors.cardBackground)
                        .padding(.horizontal, 20)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(doses) { dose in
                                    DoseDetailRow(
                                        dose: dose,
                                        medication: medications.first { $0.id == dose.medicationId },
                                        onStatusChange: { status in
                                            onStatusChange(dose, status)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

struct DoseDetailRow: View {
    let dose: Dose
    let medication: Medication?
    let onStatusChange: (Dose.DoseStatus) -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(dose.time)
                    .font(AppFonts.headline())
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.cardText)
                
                Text("Time")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.cardSecondaryText)
            }
            .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                if let medication = medication {
                    Text(medication.name)
                        .font(AppFonts.callout())
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.cardText)
                    
                    Text(medication.dosage)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.cardSecondaryText)
                } else {
                    Text("Unknown medication")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.cardSecondaryText)
                }
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
                .padding(.vertical, 8)
                .background(dose.status.color.opacity(0.1))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(dose.status.color, lineWidth: 1)
                )
            }
        }
        .padding(15)
        .concaveCard(color: AppColors.cardBackground)
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

