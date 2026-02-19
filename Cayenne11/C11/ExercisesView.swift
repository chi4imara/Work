import SwiftUI

struct ExercisesView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var selectedExercise: ExerciseGroup?
    
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
                    Text("Exercises")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Your exercise statistics")
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if viewModel.records.isEmpty {
                    EmptyStateView(
                        icon: "dumbbell",
                        title: "No Exercise Data",
                        message: "No information about exercises."
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.getExerciseGroups()) { exerciseGroup in
                                ExerciseCard(
                                    exerciseGroup: exerciseGroup,
                                    onTap: {
                                        selectedExercise = exerciseGroup
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
        .sheet(item: $selectedExercise) { exercise in
            ExerciseRecordsView(
                exerciseName: exercise.name,
                records: viewModel.getRecordsForExercise(exercise.name),
                viewModel: viewModel
            )
        }
    }
}

struct ExerciseCard: View {
    let exerciseGroup: ExerciseGroup
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exerciseGroup.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(exerciseGroup.recordCount) record\(exerciseGroup.recordCount == 1 ? "" : "s")")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Open")
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
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

struct ExerciseRecordsView: View {
    let exerciseName: String
    let records: [WorkoutRecord]
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRecord: WorkoutRecord?
    
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
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text(exerciseName)
                            .font(.playfairDisplay(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("\(records.count) workout\(records.count == 1 ? "" : "s")")
                            .font(.playfairDisplay(16, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(records) { record in
                                ExerciseRecordCard(
                                    record: record,
                                    onTap: {
                                        selectedRecord = record
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
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
        .sheet(item: $selectedRecord) { record in
            RecordDetailView(recordId: record.id, viewModel: viewModel)
        }
    }
}

struct ExerciseRecordCard: View {
    let record: WorkoutRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.formattedDate)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Text("\(Int(record.weight))")
                                .font(.playfairDisplay(14, weight: .bold))
                                .foregroundColor(AppColors.lightBlue)
                            Text("kg")
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        HStack(spacing: 4) {
                            Text("\(record.repetitions)")
                                .font(.playfairDisplay(14, weight: .bold))
                                .foregroundColor(AppColors.orange)
                            Text("reps")
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Open")
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
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

#Preview {
    ExercisesView(viewModel: WorkoutViewModel())
}
