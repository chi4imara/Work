import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: FragranceViewModel
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection
                            overviewStatsSection
                            seasonalDistributionSection
                            typeDistributionSection
                            brandDistributionSection
                        }
                        .padding(20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text("Collection Statistics")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Insights into your fragrance collection")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 20)
    }
    
    private var overviewStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Total Fragrances",
                    value: "\(viewModel.fragrances.count)",
                    icon: "waterbottle.fill",
                    color: AppColors.accentYellow
                )
                
                StatCard(
                    title: "Unique Brands",
                    value: "\(Set(viewModel.fragrances.map { $0.brand }).count)",
                    icon: "tag.fill",
                    color: AppColors.primaryBlue
                )
                
                StatCard(
                    title: "Daytime",
                    value: "\(daytimeCount)",
                    icon: "sun.max.fill",
                    color: AppColors.primaryPurple
                )
                
                StatCard(
                    title: "Evening",
                    value: "\(eveningCount)",
                    icon: "moon.fill",
                    color: AppColors.accentYellow
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var seasonalDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Seasonal Distribution")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Season.allCases, id: \.self) { season in
                    SeasonStatRow(
                        season: season,
                        count: viewModel.fragrancesForSeason(season).count,
                        total: viewModel.fragrances.count
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var typeDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Type Distribution")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 16) {
                TypeStatCard(
                    type: .daytime,
                    count: daytimeCount,
                    total: viewModel.fragrances.count,
                    color: Color.yellow
                )
                
                TypeStatCard(
                    type: .evening,
                    count: eveningCount,
                    total: viewModel.fragrances.count,
                    color: AppColors.primaryPurple
                )
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var brandDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Brands")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            let brandCounts = getBrandCounts()
            let topBrands = Array(brandCounts.sorted { $0.value > $1.value }.prefix(5))
            
            if topBrands.isEmpty {
                Text("No brands available")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.tertiaryText)
                    .italic()
            } else {
                VStack(spacing: 12) {
                    ForEach(topBrands, id: \.key) { brand, count in
                        BrandStatRow(brand: brand, count: count)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var daytimeCount: Int {
        viewModel.fragrances.filter { $0.type == .daytime }.count
    }
    
    private var eveningCount: Int {
        viewModel.fragrances.filter { $0.type == .evening }.count
    }
    
    private func getBrandCounts() -> [String: Int] {
        var counts: [String: Int] = [:]
        for fragrance in viewModel.fragrances {
            if !fragrance.brand.isEmpty {
                counts[fragrance.brand, default: 0] += 1
            }
        }
        return counts
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.borderPrimary, lineWidth: 1)
        )
    }
}

struct SeasonStatRow: View {
    let season: Season
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: season.icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(season.displayName)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.cardBackground)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.accentYellow)
                            .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TypeStatCard: View {
    let type: FragranceType
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: type == .daytime ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(type.displayName)
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("\(count)")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(color)
            
            Text("\(Int(percentage))%")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.borderPrimary, lineWidth: 1)
        )
    }
}

struct BrandStatRow: View {
    let brand: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "tag.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.accentYellow)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(brand)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(count) fragrance\(count == 1 ? "" : "s")")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.tertiaryText)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.accentYellow)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView(viewModel: FragranceViewModel())
}
