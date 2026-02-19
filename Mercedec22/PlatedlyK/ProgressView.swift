import SwiftUI
import Charts

struct NutritionProgressView: View {
    @ObservedObject var mealPlanViewModel: MealPlanViewModel
    @ObservedObject var recipeViewModel: RecipeViewModel
    @StateObject private var progressViewModel = ProgressViewModel()
    @State private var selectedMetric: ProgressMetric = .calories
    @State private var showingAllAchievements = false
    
    enum ProgressMetric: String, CaseIterable {
        case calories = "Calories"
        case protein = "Protein"
        case carbs = "Carbs"
        case fat = "Fat"
    }
    
    private var derivedProgress: [NutritionProgress] {
        let calendar = Calendar.current
        let today = Date()
        let interval: DateInterval?
        switch progressViewModel.selectedTimeRange {
        case .week:
            interval = calendar.dateInterval(of: .weekOfYear, for: today)
        case .month:
            interval = calendar.dateInterval(of: .month, for: today)
        case .year:
            interval = calendar.dateInterval(of: .year, for: today)
        }
        guard let interval else { return [] }
        return mealPlanViewModel.mealPlans
            .filter { interval.contains($0.date) }
            .map { plan in
                NutritionProgress(
                    date: plan.date,
                    calories: plan.totalCalories,
                    macros: plan.totalMacros,
                    energyLevel: 3,
                    mood: 3,
                    satietyLevel: 3
                )
            }
            .sorted { $0.date < $1.date }
    }
    
    private var derivedAverageCalories: Int {
        guard !derivedProgress.isEmpty else { return 0 }
        return derivedProgress.reduce(0) { $0 + $1.calories } / derivedProgress.count
    }
    
    private var derivedAverageMacros: Macros {
        guard !derivedProgress.isEmpty else { return Macros(protein: 0, carbs: 0, fat: 0, fiber: 0) }
        let count = Double(derivedProgress.count)
        let p = derivedProgress.reduce(0.0) { $0 + $1.macros.protein } / count
        let c = derivedProgress.reduce(0.0) { $0 + $1.macros.carbs } / count
        let f = derivedProgress.reduce(0.0) { $0 + $1.macros.fat } / count
        let fib = derivedProgress.reduce(0.0) { $0 + $1.macros.fiber } / count
        return Macros(protein: p, carbs: c, fat: f, fiber: fib)
    }
    
    private var derivedAchievements: [Achievement] {
        var list: [Achievement] = []
        let calendar = Calendar.current
        let plans = mealPlanViewModel.mealPlans
        
        if !plans.isEmpty {
            let firstPlan = plans.min(by: { $0.date < $1.date })!
            list.append(Achievement(
                title: "First meal logged",
                description: "You added your first meal to the menu",
                icon: "fork.knife",
                dateEarned: firstPlan.date,
                category: .consistency
            ))
        }
        
        let daysWithMeals = Set(plans.map { calendar.startOfDay(for: $0.date) })
        if daysWithMeals.count >= 7 {
            list.append(Achievement(
                title: "Week of meals",
                description: "You planned meals for 7 different days",
                icon: "calendar",
                dateEarned: Date(),
                category: .consistency
            ))
        }
        
        if recipeViewModel.recipes.count >= 5 {
            list.append(Achievement(
                title: "Recipe collector",
                description: "You have \(recipeViewModel.recipes.count) recipes",
                icon: "book.fill",
                dateEarned: Date(),
                category: .exploration
            ))
        }
        
        return list.sorted { $0.dateEarned > $1.dateEarned }
    }
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        timeRangeSelector
                        
                        quickStatsView
                        
                        achievementsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 180)
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Progress & Nutrition")
                    .font(AppFonts.title(28))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Track your nutrition journey")
                    .font(AppFonts.subtitle(16))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { exportProgress() }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.cardBackground)
                            .overlay(
                                Circle()
                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                            )
                    )
            }
        }
        .sheet(isPresented: $showingAllAchievements) {
            AchievementsListView(achievements: derivedAchievements)
        }
    }
    
    private func exportProgress() {
        var lines: [String] = [
            "CookHer - Progress & Nutrition Export",
            "Exported: \(Date().formatted())",
            "",
            "--- Summary ---",
            "Time range: \(progressViewModel.selectedTimeRange.rawValue)",
            "Average calories: \(derivedAverageCalories) kcal",
            "Average protein: \(Int(derivedAverageMacros.protein))g",
            "Average carbs: \(Int(derivedAverageMacros.carbs))g",
            "Average fat: \(Int(derivedAverageMacros.fat))g",
            "Days tracked: \(derivedProgress.count)",
            "",
            "--- Achievements (\(derivedAchievements.count)) ---"
        ]
        for a in derivedAchievements {
            lines.append("  - \(a.title): \(a.description)")
        }
        lines.append("")
        lines.append("Track your nutrition with CookHer")
        ShareHelper.presentShareSheet(items: [lines.joined(separator: "\n")])
    }
    
    private var timeRangeSelector: some View {
        HStack(spacing: 12) {
            ForEach(ProgressViewModel.TimeRange.allCases, id: \.self) { range in
                Button(action: { progressViewModel.selectedTimeRange = range }) {
                    Text(range.rawValue)
                        .font(AppFonts.body(14))
                        .foregroundColor(progressViewModel.selectedTimeRange == range ? .black : AppColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(progressViewModel.selectedTimeRange == range ? AppColors.primaryYellow : AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(progressViewModel.selectedTimeRange == range ? AppColors.primaryYellow : AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                }
            }
            
            Spacer()
        }
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Nutrition Trends")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Menu {
                    ForEach(ProgressMetric.allCases, id: \.self) { metric in
                        Button(metric.rawValue) {
                            selectedMetric = metric
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedMetric.rawValue)
                            .font(AppFonts.caption(14))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
            }
            
            chartContent
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var chartContent: some View {
        let entries = derivedProgress
        let maxVal: Double = {
            guard !entries.isEmpty else { return 1 }
            switch selectedMetric {
            case .calories:
                return Double(entries.map(\.calories).max() ?? 1)
            case .protein:
                return entries.map(\.macros.protein).max() ?? 1
            case .carbs:
                return entries.map(\.macros.carbs).max() ?? 1
            case .fat:
                return entries.map(\.macros.fat).max() ?? 1
            }
        }()
        
        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground.opacity(0.5))
                .frame(height: 200)
            
            if entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.textSecondary)
                    Text("Add meals in Menu to see trends")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(entries) { progress in
                        let value: Double = {
                            switch selectedMetric {
                            case .calories: return Double(progress.calories)
                            case .protein: return progress.macros.protein
                            case .carbs: return progress.macros.carbs
                            case .fat: return progress.macros.fat
                            }
                        }()
                        let height = max(4, (value / max(maxVal, 1)) * 160)
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.primaryYellow)
                                .frame(width: 20, height: height)
                            Text(shortDate(progress.date))
                                .font(AppFonts.caption(9))
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }
        }
        .frame(height: 200)
    }
    
    private func shortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d/M"
        return f.string(from: date)
    }
    
    private var quickStatsView: some View {
        HStack(spacing: 0) {
            statItem(
                title: "Avg Calories",
                value: "\(derivedAverageCalories)",
                unit: "kcal",
                color: AppColors.primaryYellow
            )
            
            Divider()
                .frame(height: 50)
                .background(AppColors.cardBorder)
            
            statItem(
                title: "Protein",
                value: "\(Int(derivedAverageMacros.protein))",
                unit: "g",
                color: AppColors.secondaryGreen
            )
            
            Divider()
                .frame(height: 50)
                .background(AppColors.cardBorder)
            
            statItem(
                title: "Days Active",
                value: "\(derivedProgress.count)",
                unit: "days",
                color: AppColors.secondaryOrange
            )
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var macrosBreakdownView: some View {
        let total = derivedAverageMacros.protein + derivedAverageMacros.carbs + derivedAverageMacros.fat
        let (pctP, pctC, pctF) = total > 0
            ? (derivedAverageMacros.protein / total, derivedAverageMacros.carbs / total, derivedAverageMacros.fat / total)
            : (0.33, 0.33, 0.34)
        let trimP = pctP
        let trimC = trimP + pctC
        let trimF = trimC + pctF
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Macronutrients Breakdown")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            HStack {
                ZStack {
                    Circle()
                        .stroke(AppColors.cardBorder, lineWidth: 2)
                        .frame(width: 120, height: 120)
                    
                    if total > 0 {
                        Circle()
                            .trim(from: 0, to: trimP)
                            .stroke(AppColors.secondaryGreen, lineWidth: 20)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                        
                        Circle()
                            .trim(from: trimP, to: trimC)
                            .stroke(AppColors.secondaryOrange, lineWidth: 20)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90 - trimP * 360))
                        
                        Circle()
                            .trim(from: trimC, to: min(trimF, 1.0))
                            .stroke(AppColors.secondaryPink, lineWidth: 20)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90 - trimC * 360))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    macroLegendItem(
                        color: AppColors.secondaryGreen,
                        title: "Protein",
                        value: "\(Int(derivedAverageMacros.protein))g",
                        percentage: total > 0 ? "\(Int(pctP * 100))%" : "—"
                    )
                    
                    macroLegendItem(
                        color: AppColors.secondaryOrange,
                        title: "Carbs",
                        value: "\(Int(derivedAverageMacros.carbs))g",
                        percentage: total > 0 ? "\(Int(pctC * 100))%" : "—"
                    )
                    
                    macroLegendItem(
                        color: AppColors.secondaryPink,
                        title: "Fat",
                        value: "\(Int(derivedAverageMacros.fat))g",
                        percentage: total > 0 ? "\(Int(pctF * 100))%" : "—"
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Achievements")
                    .font(AppFonts.subtitle(18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(derivedAchievements.count) total")
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            VStack(spacing: 12) {
                ForEach(derivedAchievements.prefix(3)) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
            
            if !derivedAchievements.isEmpty {
                Button {
                    showingAllAchievements = true
                } label: {
                    Text("View All Achievements")
                        .font(AppFonts.button(14))
                        .foregroundColor(AppColors.primaryYellow)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground.opacity(0.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.cardBorder.opacity(0.5), lineWidth: 1)
                                )
                        )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var wellnessTrackingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wellness Tracking")
                .font(AppFonts.subtitle(18))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 16) {
                wellnessItem(
                    title: "Energy Level",
                    value: 4,
                    maxValue: 5,
                    color: AppColors.primaryYellow,
                    icon: "bolt.fill"
                )
                
                wellnessItem(
                    title: "Mood",
                    value: 4,
                    maxValue: 5,
                    color: AppColors.secondaryPink,
                    icon: "face.smiling"
                )
                
                wellnessItem(
                    title: "Satiety",
                    value: 3,
                    maxValue: 5,
                    color: AppColors.secondaryGreen,
                    icon: "heart.fill"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func statItem(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(alignment: .bottom, spacing: 2) {
                Text(value)
                    .font(AppFonts.subtitle(16))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(unit)
                    .font(AppFonts.caption(10))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func macroLegendItem(color: Color, title: String, value: String, percentage: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.body(14))
                    .foregroundColor(AppColors.textPrimary)
                
                HStack {
                    Text(value)
                        .font(AppFonts.caption(12))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("(\(percentage))")
                        .font(AppFonts.caption(12))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
        }
    }
    
    private func wellnessItem(title: String, value: Int, maxValue: Int, color: Color, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(1...maxValue, id: \.self) { index in
                    Circle()
                        .fill(index <= value ? color : AppColors.cardBorder)
                        .frame(width: 12, height: 12)
                }
            }
            
            Text("\(value)/\(maxValue)")
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.textSecondary)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(categoryColor(achievement.category))
                    .frame(width: 40, height: 40)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(AppFonts.subtitle(14))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(achievement.description)
                    .font(AppFonts.caption(12))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(timeAgo(achievement.dateEarned))
                .font(AppFonts.caption(10))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder.opacity(0.7), lineWidth: 1)
                )
        )
    }
    
    private func categoryColor(_ category: Achievement.AchievementCategory) -> Color {
        switch category {
        case .consistency:
            return AppColors.primaryYellow
        case .exploration:
            return AppColors.secondaryOrange
        case .health:
            return AppColors.secondaryGreen
        case .cooking:
            return AppColors.secondaryPurple
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct AchievementsListView: View {
    let achievements: [Achievement]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridPattern()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                if achievements.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "trophy")
                            .font(.system(size: 50))
                            .foregroundColor(AppColors.textSecondary)
                        Text("No achievements yet")
                            .font(AppFonts.subtitle(20))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Complete goals to earn achievements")
                            .font(AppFonts.body(16))
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(achievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("All Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    NutritionProgressView(mealPlanViewModel: MealPlanViewModel(), recipeViewModel: RecipeViewModel())
}
