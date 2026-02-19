import SwiftUI

struct ExercisesView: View {
    @State private var selectedExercise: ExerciseType?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if let selectedExercise = selectedExercise {
                    ExerciseDetailView(
                        exercise: selectedExercise,
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.selectedExercise = nil
                            }
                        }
                    )
                } else {
                    exerciseListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            if selectedExercise != nil {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedExercise = nil
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
            
            Text(selectedExercise?.rawValue ?? "Exercises")
                .font(.ubuntu(.bold, size: 32))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var exerciseListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ExerciseType.allCases, id: \.self) { exercise in
                    ExerciseCard(exercise: exercise) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedExercise = exercise
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ExerciseCard: View {
    let exercise: ExerciseType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: exerciseIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.rawValue)
                        .font(.ubuntu(.bold, size: 18))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Track \(exercise.unit)")
                        .font(.ubuntu(.regular, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(exercise.description)
                        .font(.ubuntu(.regular, size: 12))
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var exerciseIcon: String {
        switch exercise {
        case .pushUps:
            return "figure.strengthtraining.traditional"
        case .abs:
            return "figure.core.training"
        case .plank:
            return "figure.strengthtraining.functional"
        case .squats:
            return "figure.squash"
        case .coreLifts:
            return "figure.core.training"
        }
    }
}

struct ExerciseDetailView: View {
    let exercise: ExerciseType
    let onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                exerciseIconView
                
                trackingInfoView
                
                techniqueView
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var exerciseIconView: some View {
        ZStack {
            Circle()
                .fill(AppColors.lightBlue.opacity(0.2))
                .frame(width: 120, height: 120)
            
            Image(systemName: exerciseIcon)
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(AppColors.lightBlue)
        }
    }
    
    private var trackingInfoView: some View {
        VStack(spacing: 16) {
            Text("What to Track")
                .font(.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "target")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.orange)
                
                Text("Record \(exercise.unit) for this exercise")
                    .font(.ubuntu(.medium, size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.orange.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.orange.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var techniqueView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Proper Technique")
                .font(.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(exercise.technique)
                .font(.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var exerciseIcon: String {
        switch exercise {
        case .pushUps:
            return "figure.strengthtraining.traditional"
        case .abs:
            return "figure.core.training"
        case .plank:
            return "figure.strengthtraining.functional"
        case .squats:
            return "figure.squash"
        case .coreLifts:
            return "figure.core.training"
        }
    }
}

#Preview {
    ExercisesView()
}
