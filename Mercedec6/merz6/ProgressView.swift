import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var mealPlanViewModel: MealPlanViewModel
    @StateObject private var viewModel = ProgressViewModel()
    @State private var showingAddEnergy = false
    @State private var editingEnergyData: EnergyData?

    private var goalsPercentages: (energy: Int, focus: Int, relax: Int) {
        viewModel.goalsDistributionPercentages(mealEntries: mealPlanViewModel.mealEntries)
    }

    private var achievementsList: [Achievement] {
        viewModel.computedAchievements(mealEntries: mealPlanViewModel.mealEntries)
    }

    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection

                    timeRangePicker

                    energyChartSection

                    energyEntriesListSection

                    goalsDistributionSection

                    achievementsSection
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingAddEnergy) {
            AddEnergyView(editingData: editingEnergyData) { data in
                if let editing = editingEnergyData {
                    viewModel.updateEnergyData(id: editing.id, newData: data)
                } else {
                    viewModel.addEnergyData(data)
                }
            } onDismiss: {
                editingEnergyData = nil
            }
        }
        .onChange(of: editingEnergyData) { newValue in
            if newValue != nil {
                showingAddEnergy = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Progress")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Text("Track your energy and achievements")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var timeRangePicker: some View {
        Picker("Time Range", selection: $viewModel.selectedTimeRange) {
            ForEach(ProgressViewModel.TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .colorScheme(.dark)
    }
    
    private var energyChartSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Energy Levels")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)

                Spacer()

                Button(action: { showingAddEnergy = true }) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.small)
                            .fill(AppColors.accentYellow)
                    )
                }

                Text("Avg: \(viewModel.averageEnergyLevel, specifier: "%.1f")")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.accentText)
            }

            if viewModel.filteredEnergyData.isEmpty {
                emptyChartView
            } else {
                energyLineChart
                    .id(viewModel.filteredEnergyData.count)
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var energyLineChart: some View {
        GeometryReader { geometry in
            let data = viewModel.filteredEnergyData
            let maxEnergy: Double = 10
            let minEnergy: Double = 0
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = data.count > 1 ? width / CGFloat(data.count - 1) : width
            
            ZStack {
                VStack {
                    ForEach(0..<6) { i in
                        Rectangle()
                            .fill(AppColors.cardBorder)
                            .frame(height: 1)
                            .opacity(0.3)
                        if i < 5 {
                            Spacer()
                        }
                    }
                }
                
                if !data.isEmpty {
                    Path { path in
                        for (index, energyData) in data.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = height - (CGFloat(energyData.energyLevel - minEnergy) / CGFloat(maxEnergy - minEnergy)) * height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(AppColors.accentYellow, lineWidth: 3)
                    
                    ForEach(Array(data.enumerated()), id: \.offset) { index, energyData in
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(energyData.energyLevel - minEnergy) / CGFloat(maxEnergy - minEnergy)) * height
                        
                        Circle()
                            .fill(AppColors.accentYellow)
                            .frame(width: 8, height: 8)
                            .position(x: x, y: y)
                    }
                }
            }
        }
        .frame(height: 200)
    }
    
    private var emptyChartView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(AppColors.secondaryText)

            Text("No data for analysis")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)

            Button {
                showingAddEnergy = true
            } label: {
                Text("Add energy entry")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.medium)
                            .fill(AppColors.accentYellow)
                    )
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }

    private var energyEntriesListSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Energy Entries")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)

                Spacer()

                Text("\(viewModel.filteredEnergyData.count) entries")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }

            if viewModel.filteredEnergyData.isEmpty {
                Text("No energy entries for selected period")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppSpacing.md)
            } else {
                LazyVStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.filteredEnergyData) { data in
                        EnergyEntryCard(
                            energyData: data,
                            onEdit: {
                                editingEnergyData = data
                            },
                            onDelete: {
                                viewModel.removeEnergyData(id: data.id)
                            }
                        )
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var goalsDistributionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Goals Distribution")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)

            if mealPlanViewModel.mealEntries.isEmpty {
                Text("Add meals to see distribution by goal")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppSpacing.md)
            } else {
                HStack(spacing: AppSpacing.md) {
                    goalDistributionItem(goal: .energy, percentage: goalsPercentages.energy)
                    goalDistributionItem(goal: .focus, percentage: goalsPercentages.focus)
                    goalDistributionItem(goal: .relax, percentage: goalsPercentages.relax)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func goalDistributionItem(goal: MoodGoal, percentage: Int) -> some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .stroke(AppColors.cardBorder, lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(goalColor(for: goal), lineWidth: 4)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Text("\(percentage)%")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.medium)
            }
            
            Text(goal.rawValue)
                .font(AppFonts.small)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Achievements")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)

            if achievementsList.isEmpty {
                emptyAchievementsView
            } else {
                LazyVStack(spacing: AppSpacing.sm) {
                    ForEach(achievementsList) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var emptyAchievementsView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "trophy")
                .font(.system(size: 40))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No achievements yet")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }
    
    private func goalColor(for goal: MoodGoal) -> Color {
        switch goal {
        case .energy: return AppColors.energyColor
        case .focus: return Color.green
        case .relax: return AppColors.relaxColor
        }
    }
}

struct EnergyEntryCard: View {
    let energyData: EnergyData
    let onEdit: () -> Void
    let onDelete: () -> Void

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("\(Int(energyData.energyLevel))/10")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)

                Text(dateFormatter.string(from: energyData.date))
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)

                if !energyData.mood.isEmpty && energyData.mood != "Not specified" {
                    Text(energyData.mood)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.accentText)
                }
            }

            Spacer()

            HStack(spacing: AppSpacing.sm) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppColors.accentYellow)
                }

                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppColors.error)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.medium)
                .fill(AppColors.cardBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: achievement.isUnlocked ? "trophy.fill" : "trophy")
                .font(.title2)
                .foregroundColor(achievement.isUnlocked ? AppColors.accentYellow : AppColors.secondaryText)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(achievement.title)
                    .font(AppFonts.body)
                    .foregroundColor(achievement.isUnlocked ? AppColors.primaryText : AppColors.secondaryText)
                    .fontWeight(achievement.isUnlocked ? .medium : .regular)
                
                Text(achievement.description)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if let date = achievement.date {
                Text(date, style: .date)
                    .font(AppFonts.small)
                    .foregroundColor(AppColors.secondaryText)
            } else {
                Text("Locked")
                    .font(AppFonts.small)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    ProgressView()
        .environmentObject(MealPlanViewModel())
}
