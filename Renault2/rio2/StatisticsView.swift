import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()
                    
                    OverviewSection()
                    
                    CategoryBreakdownSection()
                    
                    ActivitySection()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Statistics")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Your style journey at a glance")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func OverviewSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                StatOverviewCard(
                    value: "\(appState.wardrobeItems.count)",
                    label: "Wardrobe Items",
                    icon: "tshirt",
                    color: AppColors.yellow
                )
                
                StatOverviewCard(
                    value: "\(appState.outfits.count)",
                    label: "Outfits",
                    icon: "person",
                    color: AppColors.pink
                )
            }
            
            HStack(spacing: 16) {
                StatOverviewCard(
                    value: "\(appState.dailyProgress.count)",
                    label: "Active Days",
                    icon: "calendar",
                    color: AppColors.purple
                )
                
                StatOverviewCard(
                    value: "\(appState.dailyChallenges.filter(\.isCompleted).count)",
                    label: "Challenges Done",
                    icon: "star",
                    color: AppColors.green
                )
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    @ViewBuilder
    private func CategoryBreakdownSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wardrobe by Category")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            let grouped = Dictionary(grouping: appState.wardrobeItems, by: { $0.category })
            
            ForEach(WardrobeItem.ClothingCategory.allCases, id: \.self) { category in
                let count = grouped[category]?.count ?? 0
                HStack {
                    Image(systemName: category.icon)
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.yellow)
                        .frame(width: 28)
                    
                    Text(category.rawValue)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.secondaryText)
                    
                    if !appState.wardrobeItems.isEmpty {
                        let pct = Double(count) / Double(appState.wardrobeItems.count)
                        Text("\(Int(pct * 100))%")
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                            .frame(width: 36)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    @ViewBuilder
    private func ActivitySection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            if let progress = appState.todaysProgress {
                VStack(spacing: 12) {
                    HStack {
                        Text("Today")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        Spacer()
                        Text(progress.progressDescription)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.yellow)
                    }
                    
                    HStack(spacing: 20) {
                        MiniStat(label: "Items added", value: progress.wardrobeItemsAdded)
                        MiniStat(label: "Outfits created", value: progress.outfitsCreated)
                        MiniStat(label: "Challenges", value: progress.challengesCompleted)
                    }
                }
                .padding(16)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
            } else {
                Text("No activity yet today")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
        }
        .padding(20)
        .cardStyle()
    }
}

struct StatOverviewCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
            }
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(label)
                .font(.ubuntu(12))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(color.opacity(0.1))
        .cornerRadius(16)
    }
}

struct MiniStat: View {
    let label: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.yellow)
            Text(label)
                .font(.ubuntu(10))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(AppState())
}
