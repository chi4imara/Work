import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: MakeupIdeaViewModel
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 24) {
                        StatisticsOverviewCard(
                            totalIdeas: viewModel.ideas.count,
                            totalNotes: viewModel.notesWithComments.count
                        )
                        
                        StatisticsSectionView(title: "By Category") {
                            VStack(spacing: 0) {
                                ForEach(MakeupTag.allCases, id: \.self) { tag in
                                    StatisticsCategoryRow(
                                        tag: tag,
                                        count: viewModel.getIdeasCount(for: tag),
                                        total: viewModel.ideas.count
                                    )
                                    
                                    if tag != MakeupTag.allCases.last {
                                        Divider()
                                            .background(Color.white.opacity(0.2))
                                            .padding(.leading, 60)
                                    }
                                }
                            }
                        }
                        
                        StatisticsSectionView(title: "Activity") {
                            VStack(spacing: 0) {
                                StatisticsActivityRow(
                                    icon: "calendar",
                                    title: "Total Ideas",
                                    value: "\(viewModel.ideas.count)",
                                    subtitle: "ideas in collection"
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.leading, 60)
                                
                                StatisticsActivityRow(
                                    icon: "note.text",
                                    title: "Notes Added",
                                    value: "\(viewModel.notesWithComments.count)",
                                    subtitle: "ideas with comments"
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.leading, 60)
                                
                                StatisticsActivityRow(
                                    icon: "tag",
                                    title: "Categories Used",
                                    value: "\(uniqueCategoriesCount)",
                                    subtitle: "different types"
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var uniqueCategoriesCount: Int {
        let uniqueTags = Set(viewModel.ideas.map { $0.tag })
        return uniqueTags.count
    }
}

struct StatisticsOverviewCard: View {
    let totalIdeas: Int
    let totalNotes: Int
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                StatisticsMiniCard(
                    icon: "lightbulb.fill",
                    value: "\(totalIdeas)",
                    label: "Total Ideas",
                    color: AppColors.primaryYellow
                )
                
                StatisticsMiniCard(
                    icon: "note.text",
                    value: "\(totalNotes)",
                    label: "Notes",
                    color: AppColors.primaryPurple
                )
            }
        }
        .padding(20)
        .background(CardBackground())
        .cornerRadius(16)
    }
}

struct StatisticsMiniCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(AppFonts.title)
                .foregroundColor(AppColors.primaryText)
            
            Text(label)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatisticsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(CardBackground())
            .cornerRadius(16)
        }
    }
}

struct StatisticsCategoryRow: View {
    let tag: MakeupTag
    let count: Int
    let total: Int
    
    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(count) / Double(total)) * 100)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: tag.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tag.displayName)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) idea\(count == 1 ? "" : "s")")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(percentage)%")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("of total")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct StatisticsActivityRow: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryPurple.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Text(subtitle)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(value)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryYellow)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

