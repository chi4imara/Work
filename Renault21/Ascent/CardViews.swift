import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout
    let onToggle: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: workout.category.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 40, height: 40)
                .background(ColorTheme.primaryAccent.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                    .strikethrough(workout.isCompleted)
                
                HStack(spacing: 12) {
                    Label("\(workout.duration) min", systemImage: "clock")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    if let reps = workout.repetitions {
                        Label("\(reps) reps", systemImage: "repeat")
                            .font(FontManager.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAnimating = true
                    onToggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                Image(systemName: workout.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(workout.isCompleted ? ColorTheme.success : ColorTheme.primaryAccent.opacity(0.6))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(workout.isCompleted ? ColorTheme.success.opacity(0.1) : ColorTheme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(workout.isCompleted ? ColorTheme.success.opacity(0.3) : ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct NutritionCardView: View {
    let nutrition: Nutrition
    let onToggle: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: nutrition.mealType.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 40, height: 40)
                .background(ColorTheme.primaryAccent.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nutrition.name)
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                    .strikethrough(nutrition.isCompleted)
                
                HStack(spacing: 12) {
                    Label("\(nutrition.calories) cal", systemImage: "flame")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Text(nutrition.mealType.rawValue)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(ColorTheme.primaryAccent.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAnimating = true
                    onToggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                Image(systemName: nutrition.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(nutrition.isCompleted ? ColorTheme.success : ColorTheme.primaryAccent.opacity(0.6))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(nutrition.isCompleted ? ColorTheme.success.opacity(0.1) : ColorTheme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(nutrition.isCompleted ? ColorTheme.success.opacity(0.3) : ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct TaskCardView: View {
    let task: ProductivityTask
    let onToggle: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.category.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 40, height: 40)
                .background(ColorTheme.primaryAccent.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                    .strikethrough(task.isCompleted)
                
                HStack(spacing: 12) {
                    Text(task.category.rawValue)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Circle()
                        .fill(priorityColor(for: task.priority))
                        .frame(width: 8, height: 8)
                    
                    Text(task.priority.rawValue)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAnimating = true
                    onToggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(task.isCompleted ? ColorTheme.success : ColorTheme.primaryAccent.opacity(0.6))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(task.isCompleted ? ColorTheme.success.opacity(0.1) : ColorTheme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(task.isCompleted ? ColorTheme.success.opacity(0.3) : ColorTheme.cardBorder, lineWidth: 1)
        )
    }
    
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .low: return ColorTheme.success
        case .medium: return ColorTheme.warning
        case .high: return ColorTheme.error
        }
    }
}

struct ChallengeCardView: View {
    let challenge: Challenge
    let onComplete: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.name)
                        .font(FontManager.playfairSemiBold(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(challenge.description)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 24))
                    .foregroundColor(ColorTheme.primaryAccent)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(challenge.isCompleted ? challenge.targetValue : challenge.currentValue) / \(challenge.targetValue) \(challenge.unit)")
                        .font(FontManager.playfairMedium(size: 14))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text("\(Int(challenge.progress * 100))%")
                        .font(FontManager.playfairMedium(size: 14))
                        .foregroundColor(ColorTheme.primaryAccent)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(ColorTheme.primaryAccent.opacity(0.2))
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(ColorTheme.accentGradient)
                            .frame(width: geometry.size.width * challenge.progress, height: 8)
                            .cornerRadius(4)
                            .animation(.easeInOut(duration: 0.5), value: challenge.progress)
                    }
                }
                .frame(height: 8)
            }
            
            if !challenge.isCompleted {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isAnimating = true
                        onComplete()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isAnimating = false
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("I Did It!")
                            .font(FontManager.playfairSemiBold(size: 16))
                    }
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(ColorTheme.accentGradient)
                    .cornerRadius(12)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorTheme.success)
                    
                    Text("Challenge Completed!")
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.success)
                    
                    Spacer()
                }
                .padding(.vertical, 12)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(challenge.isCompleted ? ColorTheme.success.opacity(0.1) : ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(challenge.isCompleted ? ColorTheme.success.opacity(0.3) : ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct WaterIntakeCardView: View {
    let waterIntake: WaterIntake
    let onAddWater: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Water Goal")
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("\(waterIntake.currentAmount) / \(waterIntake.targetAmount) ml")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryAccent.opacity(0.2), lineWidth: 6)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: waterIntake.progress)
                        .stroke(ColorTheme.accentGradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: waterIntake.progress)
                    
                    Image(systemName: "drop.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorTheme.primaryAccent)
                }
            }
            
            HStack(spacing: 12) {
                ForEach([250, 500, 750], id: \.self) { amount in
                    Button(action: { onAddWater(amount) }) {
                        VStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .semibold))
                            
                            Text("\(amount)ml")
                                .font(FontManager.playfairRegular(size: 12))
                        }
                        .foregroundColor(ColorTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(ColorTheme.primaryAccent.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(16)
    }
}
