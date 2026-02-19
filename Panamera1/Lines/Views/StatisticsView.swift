import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.bellGothicBold(size: 24))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Text("Statistics")
                                .font(.bellGothicBold(size: 28))
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Your fragrance collection insights")
                                .font(.bellGothicRegular(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.cardGradient)
                                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                        )
                        
                        VStack(spacing: 16) {
                            Text("Your Collection")
                                .font(.bellGothicBold(size: 20))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 20) {
                                StatisticView(
                                    title: "Total",
                                    value: "\(viewModel.fragrances.count)",
                                    icon: "drop.fill"
                                )
                                
                                StatisticView(
                                    title: "Favorites",
                                    value: "\(viewModel.favoriteFragrances.count)",
                                    icon: "heart.fill"
                                )
                                
                                StatisticView(
                                    title: "Styles",
                                    value: "\(viewModel.styleCategories.count)",
                                    icon: "sparkles"
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardGradient)
                                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                        )
                        
                        if !viewModel.fragrances.isEmpty {
                            VStack(spacing: 16) {
                                Text("Season Distribution")
                                    .font(.bellGothicBold(size: 20))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 12) {
                                    ForEach(viewModel.seasonCategories) { category in
                                        SeasonStatisticRowView(category: category)
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardGradient)
                                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        if !viewModel.fragrances.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recent Activity")
                                    .font(.bellGothicBold(size: 20))
                                    .foregroundColor(AppColors.textPrimary)
                                
                                VStack(spacing: 12) {
                                    ForEach(Array(viewModel.fragrances.sorted { $0.dateAdded > $1.dateAdded }.prefix(3))) { fragrance in
                                        RecentActivityRowView(fragranceId: fragrance.id)
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.cardGradient)
                                    .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct StatisticView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppColors.primaryYellow)
            
            Text(value)
                .font(.bellGothicBold(size: 24))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(.bellGothicRegular(size: 12))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.buttonSecondary)
        )
    }
}

struct SeasonStatisticRowView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    let category: Category
    
    var body: some View {
        HStack {
            Image(systemName: seasonIcon(for: category))
                .foregroundColor(AppColors.primaryYellow)
                .font(.title3)
                .frame(width: 24)
            
            Text(category.name)
                .font(.bellGothicRegular(size: 16))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Text("\(category.count)")
                .font(.bellGothicBold(size: 18))
                .foregroundColor(AppColors.textAccent)
        }
        .padding(.vertical, 8)
    }
    
    private func seasonIcon(for category: Category) -> String {
        switch category.type {
        case .season(let season):
            switch season {
            case .spring: return "leaf"
            case .summer: return "sun.max"
            case .autumn: return "leaf.fill"
            case .winter: return "snowflake"
            case .allSeasons: return "circle"
            }
        case .style(_):
            return "sparkles"
        }
    }
}

struct RecentActivityRowView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    let fragranceId: UUID
    
    private var fragrance: Fragrance? {
        viewModel.fragrances.first { $0.id == fragranceId }
    }
    
    var body: some View {
        if let fragrance = fragrance {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(AppColors.primaryYellow)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Added \(fragrance.name)")
                        .font(.bellGothicRegular(size: 14))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(DateFormatter.shortDate.string(from: fragrance.dateAdded))
                        .font(.bellGothicRegular(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(FragranceViewModel())
}
