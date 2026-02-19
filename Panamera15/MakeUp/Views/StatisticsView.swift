import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if makeupStore.ideas.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.bauhausBold(28))
                .foregroundColor(AppColors.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.white.opacity(0.6))
            
            Text("No statistics available")
                .font(.bauhausMedium(18))
                .foregroundColor(AppColors.white)
                .multilineTextAlignment(.center)
            
            Text("Add some makeup ideas to see your statistics.")
                .font(.bauhausLight(14))
                .foregroundColor(AppColors.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                overviewCards
                
                tagsStatistics
                
                recentActivity
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var overviewCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Ideas",
                    value: "\(makeupStore.ideas.count)",
                    icon: "lightbulb.fill",
                    color: AppColors.purple
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(makeupStore.favoriteIdeas.count)",
                    icon: "heart.fill",
                    color: Color.red
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Tags",
                    value: "\(makeupStore.allTags.count)",
                    icon: "tag.fill",
                    color: AppColors.primaryBlue
                )
                
                StatCard(
                    title: "With Photos",
                    value: "\(makeupStore.ideas.filter { $0.image != nil }.count)",
                    icon: "photo.fill",
                    color: Color.green
                )
            }
        }
    }
    
    private var tagsStatistics: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Most Used Tags")
                .font(.bauhausBold(20))
                .foregroundColor(AppColors.darkGray)
            
            let topTags = makeupStore.allTags.sorted { $0.count > $1.count }.prefix(5)
            
            if topTags.isEmpty {
                Text("No tags yet")
                    .font(.bauhausLight(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(topTags), id: \.id) { tag in
                        TagStatRow(tag: tag)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.bauhausBold(20))
                .foregroundColor(AppColors.darkGray)
            
            let recentIdeas = makeupStore.ideas.sorted { $0.createdAt > $1.createdAt }.prefix(5)
            
            if recentIdeas.isEmpty {
                Text("No recent activity")
                    .font(.bauhausLight(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(recentIdeas), id: \.id) { idea in
                        NavigationLink(destination: IdeaDetailView(ideaId: idea.id)) {
                            ActivityRow(idea: idea)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.bauhausBold(32))
                .foregroundColor(AppColors.darkGray)
            
            Text(title)
                .font(.bauhausLight(14))
                .foregroundColor(AppColors.mediumGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct TagStatRow: View {
    let tag: Tag
    
    var body: some View {
        HStack {
            Image(systemName: "tag.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.purple)
            
            Text(tag.name)
                .font(.bauhausMedium(16))
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
            
            Text("\(tag.count)")
                .font(.bauhausBold(16))
                .foregroundColor(AppColors.purple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.purple.opacity(0.1))
                )
        }
        .padding(.vertical, 8)
    }
}

struct ActivityRow: View {
    let idea: MakeupIdea
    
    var body: some View {
        HStack(spacing: 12) {
            if let image = idea.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.mediumGray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(AppColors.mediumGray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(idea.title)
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(1)
                
                Text(idea.createdAt, style: .relative)
                    .font(.bauhausLight(12))
                    .foregroundColor(AppColors.mediumGray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(AppColors.mediumGray)
        }
        .padding(.vertical, 8)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(MakeupStore())
    }
}
