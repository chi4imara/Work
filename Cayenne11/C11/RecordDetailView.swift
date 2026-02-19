import SwiftUI

struct RecordDetailView: View {
    let recordId: UUID
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var record: WorkoutRecord? {
        viewModel.records.first { $0.id == recordId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        AppColors.deepBlue,
                        AppColors.darkBlue
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if let record = record {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text(record.formattedDate)
                                    .font(.playfairDisplay(28, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Workout Details")
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("Exercise")
                                        .font(.playfairDisplay(14, weight: .semibold))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Text(record.exercise)
                                        .font(.playfairDisplay(24, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.center)
                                }
                                
                                HStack(spacing: 40) {
                                    StatItem(
                                        title: "Weight",
                                        value: "\(Int(record.weight)) kg",
                                        color: AppColors.lightBlue
                                    )
                                    
                                    StatItem(
                                        title: "Reps",
                                        value: "\(record.repetitions)",
                                        color: AppColors.orange
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Comment")
                                        .font(.playfairDisplay(14, weight: .semibold))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Text(record.hasComment ? record.comment : "No comment added.")
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(record.hasComment ? AppColors.primaryText : AppColors.secondaryText.opacity(0.7))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppColors.cardBackground.opacity(0.5))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.border.opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                }
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(AppColors.border, lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Edit")
                                            .font(.playfairDisplay(18, weight: .semibold))
                                    }
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.lightBlue)
                                    )
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Delete")
                                            .font(.playfairDisplay(18, weight: .semibold))
                                    }
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.destructiveButton)
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                    }
                } else {
                    VStack {
                        Text("Record not found")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
                .foregroundColor(AppColors.lightBlue)
            )
        }
        .sheet(isPresented: $showingEditView) {
            if let record = record {
                EditRecordView(record: record, viewModel: viewModel)
            }
        }
        .alert("Delete Record", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let recordToDelete = record {
                    viewModel.deleteRecord(recordToDelete)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this workout record? This action cannot be undone.")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.playfairDisplay(14, weight: .semibold))
                .foregroundColor(AppColors.secondaryText)
            
            Text(value)
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(color)
        }
    }
}

#Preview {
    let viewModel = WorkoutViewModel()
    let testRecord = WorkoutRecord(
        date: Date(),
        exercise: "Bench Press",
        weight: 80,
        repetitions: 8,
        comment: "Felt strong today! Last set was challenging but manageable."
    )
    viewModel.records.append(testRecord)
    return RecordDetailView(recordId: testRecord.id, viewModel: viewModel)
}
