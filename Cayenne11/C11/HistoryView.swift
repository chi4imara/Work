import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var selectedRecord: WorkoutRecord?
    
    var body: some View {
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
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("History")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Your workout records")
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if viewModel.records.isEmpty {
                    EmptyStateView(
                        icon: "clock",
                        title: "No Records Yet",
                        message: "You haven't recorded any workouts yet."
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.getSortedRecords()) { record in
                                WorkoutRecordCard(
                                    record: record,
                                    onTap: {
                                        selectedRecord = record
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedRecord) { record in
            RecordDetailView(recordId: record.id, viewModel: viewModel)
        }
    }
}

struct WorkoutRecordCard: View {
    let record: WorkoutRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(record.formattedDate)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(record.exercise)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 8) {
                            Text("\(Int(record.weight)) kg")
                                .font(.playfairDisplay(16, weight: .bold))
                                .foregroundColor(AppColors.lightBlue)
                            
                            Text("×")
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text("\(record.repetitions)")
                                .font(.playfairDisplay(16, weight: .bold))
                                .foregroundColor(AppColors.orange)
                        }
                        
                        Text("Open")
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.lightBlue)
                    }
                }
                
                if record.hasComment {
                    HStack {
                        Text(record.comment)
                            .font(.playfairDisplay(14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.border, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 64, weight: .light))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(message)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    HistoryView(viewModel: WorkoutViewModel())
}
