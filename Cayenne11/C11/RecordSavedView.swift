import SwiftUI

struct RecordSavedView: View {
    let record: WorkoutRecord
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimated = false
    
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
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.success.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimated ? 1.0 : 0.5)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(AppColors.success)
                        .scaleEffect(isAnimated ? 1.0 : 0.5)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isAnimated)
                
                Text("Record Saved")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimated)
                
                VStack(spacing: 16) {
                    RecordDetailRow(title: "Date", value: record.formattedDate)
                    RecordDetailRow(title: "Exercise", value: record.exercise)
                    RecordDetailRow(title: "Weight", value: "\(Int(record.weight)) kg")
                    RecordDetailRow(title: "Repetitions", value: "\(record.repetitions)")
                    RecordDetailRow(
                        title: "Comment",
                        value: record.hasComment ? record.comment : "No comment added."
                    )
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
                .opacity(isAnimated ? 1.0 : 0.0)
                .offset(y: isAnimated ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimated)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.lightBlue)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
                .opacity(isAnimated ? 1.0 : 0.0)
                .offset(y: isAnimated ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimated)
            }
        }
        .onAppear {
            isAnimated = true
        }
        .interactiveDismissDisabled()
    }
}

struct RecordDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(14, weight: .semibold))
                .foregroundColor(AppColors.secondaryText)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    RecordSavedView(
        record: WorkoutRecord(
            date: Date(),
            exercise: "Bench Press",
            weight: 80,
            repetitions: 8,
            comment: "Felt strong today!"
        ),
        viewModel: WorkoutViewModel()
    )
}
