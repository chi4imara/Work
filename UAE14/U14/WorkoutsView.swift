import SwiftUI

struct WorkoutsView: View {
    @ObservedObject var viewModel: PullUpViewModel
    @State private var selectedPlan: WorkoutPlan?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        quickStatsView
                        
                        workoutPlansView
                        
                        tipsSection
                        
                        techniqueSection
                    }
                    .padding(.bottom, 120)
                }
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $selectedPlan) { plan in
            WorkoutPlanDetailView(plan: plan, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Workouts")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private var quickStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                QuickStatCard(
                    title: "Current Streak",
                    value: "\(currentStreak)",
                    subtitle: "days",
                    icon: "flame.fill",
                    color: AppColors.orange
                )
                
                QuickStatCard(
                    title: "This Week",
                    value: "\(weeklyStats.totalEntries)",
                    subtitle: "workouts",
                    icon: "calendar",
                    color: AppColors.lightBlue
                )
            }
        }
    }
    
    private var currentStreak: Int {
        return calculateStreak()
    }
    
    private var weeklyStats: Statistics {
        return viewModel.overallStatistics
    }
    
    private var workoutPlansView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Training Plans")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(WorkoutPlan.allPlans) { plan in
                    WorkoutPlanCard(plan: plan) {
                        selectedPlan = plan
                    }
                }
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Training Tips")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                TipCard(
                    icon: "hand.raised.fill",
                    title: "Proper Form",
                    description: "Keep your body straight, engage your core, and pull until your chin clears the bar. Lower yourself slowly and controlled."
                )
                
                TipCard(
                    icon: "timer",
                    title: "Rest Days",
                    description: "Allow 48 hours of rest between intense pull-up sessions to let your muscles recover and grow stronger."
                )
                
                TipCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Progressive Overload",
                    description: "Gradually increase the number of reps or sets each week. Even adding 1-2 reps makes a difference over time."
                )
                
                TipCard(
                    icon: "heart.fill",
                    title: "Consistency",
                    description: "Training 3-4 times per week is more effective than irregular intense sessions. Build a sustainable routine."
                )
            }
        }
    }
    
    private var techniqueSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Technique Variations")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                TechniqueCard(
                    name: "Standard Grip",
                    description: "Hands shoulder-width apart, palms facing away",
                    difficulty: "Beginner"
                )
                
                TechniqueCard(
                    name: "Wide Grip",
                    description: "Hands wider than shoulders, targets lats more",
                    difficulty: "Intermediate"
                )
                
                TechniqueCard(
                    name: "Close Grip",
                    description: "Hands closer than shoulders, targets biceps more",
                    difficulty: "Intermediate"
                )
                
                TechniqueCard(
                    name: "Weighted Pull-ups",
                    description: "Add weight once you can do 10+ reps easily",
                    difficulty: "Advanced"
                )
            }
        }
    }
    
    private func calculateStreak() -> Int {
        let entries = viewModel.entries.sorted { $0.date > $1.date }
        guard !entries.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for entry in entries {
            let entryDate = Calendar.current.startOfDay(for: entry.date)
            let daysDifference = Calendar.current.dateComponents([.day], from: entryDate, to: currentDate).day ?? 0
            
            if daysDifference == streak {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if daysDifference > streak {
                break
            }
        }
        
        return streak
    }
}

struct WorkoutPlan: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let duration: String
    let difficulty: String
    let weeks: Int
    let sessions: [WorkoutSession]
    let icon: String
    
    static let allPlans: [WorkoutPlan] = [
        WorkoutPlan(
            name: "Beginner Program",
            description: "Perfect for starting your pull-up journey",
            duration: "4 weeks",
            difficulty: "Beginner",
            weeks: 4,
            sessions: [
                WorkoutSession(week: 1, day: 1, sets: 3, reps: "3-5", rest: "2 min"),
                WorkoutSession(week: 1, day: 2, sets: 3, reps: "3-5", rest: "2 min"),
                WorkoutSession(week: 2, day: 1, sets: 3, reps: "5-7", rest: "2 min"),
                WorkoutSession(week: 2, day: 2, sets: 3, reps: "5-7", rest: "2 min"),
                WorkoutSession(week: 3, day: 1, sets: 3, reps: "7-10", rest: "2 min"),
                WorkoutSession(week: 3, day: 2, sets: 3, reps: "7-10", rest: "2 min"),
                WorkoutSession(week: 4, day: 1, sets: 4, reps: "10+", rest: "2 min"),
                WorkoutSession(week: 4, day: 2, sets: 4, reps: "10+", rest: "2 min")
            ],
            icon: "figure.walk"
        ),
        WorkoutPlan(
            name: "Intermediate Program",
            description: "Build strength and increase your max reps",
            duration: "6 weeks",
            difficulty: "Intermediate",
            weeks: 6,
            sessions: [
                WorkoutSession(week: 1, day: 1, sets: 4, reps: "8-12", rest: "90 sec"),
                WorkoutSession(week: 1, day: 2, sets: 4, reps: "8-12", rest: "90 sec"),
                WorkoutSession(week: 2, day: 1, sets: 4, reps: "10-15", rest: "90 sec"),
                WorkoutSession(week: 2, day: 2, sets: 4, reps: "10-15", rest: "90 sec"),
                WorkoutSession(week: 3, day: 1, sets: 5, reps: "12-18", rest: "90 sec"),
                WorkoutSession(week: 3, day: 2, sets: 5, reps: "12-18", rest: "90 sec"),
                WorkoutSession(week: 4, day: 1, sets: 5, reps: "15-20", rest: "90 sec"),
                WorkoutSession(week: 4, day: 2, sets: 5, reps: "15-20", rest: "90 sec"),
                WorkoutSession(week: 5, day: 1, sets: 5, reps: "18-25", rest: "90 sec"),
                WorkoutSession(week: 5, day: 2, sets: 5, reps: "18-25", rest: "90 sec"),
                WorkoutSession(week: 6, day: 1, sets: 5, reps: "20+", rest: "90 sec"),
                WorkoutSession(week: 6, day: 2, sets: 5, reps: "20+", rest: "90 sec")
            ],
            icon: "figure.strengthtraining.traditional"
        ),
        WorkoutPlan(
            name: "Advanced Program",
            description: "Push your limits and reach new heights",
            duration: "8 weeks",
            difficulty: "Advanced",
            weeks: 8,
            sessions: [
                WorkoutSession(week: 1, day: 1, sets: 5, reps: "15-20", rest: "60 sec"),
                WorkoutSession(week: 1, day: 2, sets: 5, reps: "15-20", rest: "60 sec"),
                WorkoutSession(week: 2, day: 1, sets: 5, reps: "20-25", rest: "60 sec"),
                WorkoutSession(week: 2, day: 2, sets: 5, reps: "20-25", rest: "60 sec"),
                WorkoutSession(week: 3, day: 1, sets: 6, reps: "25-30", rest: "60 sec"),
                WorkoutSession(week: 3, day: 2, sets: 6, reps: "25-30", rest: "60 sec"),
                WorkoutSession(week: 4, day: 1, sets: 6, reps: "30-35", rest: "60 sec"),
                WorkoutSession(week: 4, day: 2, sets: 6, reps: "30-35", rest: "60 sec"),
                WorkoutSession(week: 5, day: 1, sets: 6, reps: "35-40", rest: "60 sec"),
                WorkoutSession(week: 5, day: 2, sets: 6, reps: "35-40", rest: "60 sec"),
                WorkoutSession(week: 6, day: 1, sets: 6, reps: "40-45", rest: "60 sec"),
                WorkoutSession(week: 6, day: 2, sets: 6, reps: "40-45", rest: "60 sec"),
                WorkoutSession(week: 7, day: 1, sets: 6, reps: "45-50", rest: "60 sec"),
                WorkoutSession(week: 7, day: 2, sets: 6, reps: "45-50", rest: "60 sec"),
                WorkoutSession(week: 8, day: 1, sets: 6, reps: "50+", rest: "60 sec"),
                WorkoutSession(week: 8, day: 2, sets: 6, reps: "50+", rest: "60 sec")
            ],
            icon: "bolt.fill"
        )
    ]
}

struct WorkoutSession {
    let week: Int
    let day: Int
    let sets: Int
    let reps: String
    let rest: String
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(subtitle)
                    .font(.ubuntu(10))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .cardStyle()
    }
}

struct WorkoutPlanCard: View {
    let plan: WorkoutPlan
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.lightBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: plan.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(plan.description)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(spacing: 12) {
                        Label(plan.duration, systemImage: "clock")
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Label(plan.difficulty, systemImage: "chart.bar.fill")
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .cardStyle()
    }
}

struct TechniqueCard: View {
    let name: String
    let description: String
    let difficulty: String
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text(difficulty)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Text(description)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(16)
        .cardStyle()
    }
}

struct WorkoutPlanDetailView: View {
    let plan: WorkoutPlan
    @ObservedObject var viewModel: PullUpViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        
                        planInfoSection
                        
                        sessionsSection
                        
                        tipsSection
                    }
                    .padding(20)
                }
            }
            .navigationTitle(plan.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.lightBlue.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: plan.icon)
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            Text(plan.description)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .cardStyle()
    }
    
    private var planInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Plan Overview")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                InfoBadge(icon: "clock", text: plan.duration)
                InfoBadge(icon: "chart.bar.fill", text: plan.difficulty)
                InfoBadge(icon: "calendar", text: "\(plan.weeks) weeks")
            }
        }
    }
    
    private var sessionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Training Schedule")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            ForEach(Array(plan.sessions.enumerated()), id: \.offset) { index, session in
                SessionRow(session: session)
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Important Notes")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(alignment: .leading, spacing: 12) {
                TipRow(text: "Rest 48 hours between sessions")
                TipRow(text: "Focus on proper form over quantity")
                TipRow(text: "Track your progress in the app")
                TipRow(text: "Adjust reps based on your current level")
            }
            .padding(16)
            .cardStyle()
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.ubuntu(12))
        }
        .foregroundColor(AppColors.primaryText)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground)
        .cornerRadius(8)
    }
}

struct SessionRow: View {
    let session: WorkoutSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Week \(session.week) - Day \(session.day)")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(session.sets) sets × \(session.reps) reps")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(session.rest)
                .font(.ubuntu(12))
                .foregroundColor(AppColors.lightBlue)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(AppColors.lightBlue.opacity(0.2))
                .cornerRadius(6)
        }
        .padding(16)
        .cardStyle()
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.lightBlue)
            
            Text(text)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

#Preview {
    WorkoutsView(viewModel: PullUpViewModel())
}
