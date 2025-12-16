import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = MainViewModel()
    
    private var totalPracticeDays: Int {
        return viewModel.getTotalPracticeDays()
    }
    
    private var currentStreak: Int {
        return viewModel.getCurrentStreak()
    }
    
    private var archivedPhrasesCount: Int {
        return viewModel.archivedPhrases.count
    }
    
    private var totalPhrasesInDatabase: Int {
        return viewModel.allPhrases.count
    }
    
    var body: some View {
        BackgroundContainer {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    
                    VStack(spacing: 20) {
                        statisticsCard(
                            title: "Practice Statistics",
                            icon: "leaf.fill",
                            color: ColorTheme.primaryBlue,
                            items: [
                                StatItem(label: "Total Practice Days", value: "\(totalPracticeDays)"),
                                StatItem(label: "Current Streak", value: "\(currentStreak) days"),
                                StatItem(label: "Last Practice", value: viewModel.getLastPracticeDate())
                            ]
                        )
                        
                        statisticsCard(
                            title: "Phrase Statistics",
                            icon: "text.book.closed.fill",
                            color: ColorTheme.accentPurple,
                            items: [
                                StatItem(label: "Saved Phrases", value: "\(archivedPhrasesCount)"),
                                StatItem(label: "Total Phrases", value: "\(totalPhrasesInDatabase)"),
                                StatItem(label: "Archive Usage", value: "\(Int(Double(archivedPhrasesCount) / Double(max(totalPhrasesInDatabase, 1)) * 100))%")
                            ]
                        )
                        
                        statisticsCard(
                            title: "App Usage",
                            icon: "chart.bar.fill",
                            color: ColorTheme.warmOrange,
                            items: [
                                StatItem(label: "Days Since Install", value: "\(viewModel.getDaysSinceInstall())"),
                                StatItem(label: "Light Reminders", value: "\(viewModel.getLightRemindersCount())"),
                                StatItem(label: "Favorite Features", value: archivedPhrasesCount > 0 ? "Phrase Archive" : "Evening Practice")
                            ]
                        )
                    }
                    
                    motivationalSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(ColorTheme.backgroundWhite)
                )
                .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 12, x: 0, y: 6)
            
            VStack(spacing: 4) {
                Text("Your Progress")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Track your evening ritual journey")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
        .padding(.vertical, 20)
    }
    
    private func statisticsCard(title: String, icon: String, color: Color, items: [StatItem]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color.opacity(0.15))
                    )
                
                Text(title)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    
                    HStack {
                        Text(item.label)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Spacer()
                        
                        Text(item.value)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.textPrimary)
                    }
                    .padding(.vertical, 4)
                    
                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 0)
                    }
                }
            }
        }
        .padding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private var motivationalSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(ColorTheme.primaryYellow)
            
            VStack(spacing: 8) {
                Text("Keep Going!")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Every evening ritual brings you closer to inner peace. Your consistency is building a beautiful habit.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.all, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.primaryYellow.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.primaryYellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct StatItem {
    let label: String
    let value: String
}

#Preview {
    StatisticsView()
}
