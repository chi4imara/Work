import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ScentViewModel

    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            overviewCards
                            
                            seasonDistribution
                            
                            topBrands
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .onAppear {
            viewModel.applyFilters()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Statistics")
                .font(.playfairDisplay(.bold, size: 28))
                .foregroundColor(AppColors.white)
            
            Text("Your collection insights")
                .font(.playfairDisplay(.regular, size: 16))
                .foregroundColor(AppColors.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "chart.bar")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.yellow)
            }
            
            VStack(spacing: 12) {
                Text("No Statistics Yet")
                    .font(.playfairDisplay(.bold, size: 24))
                    .foregroundColor(AppColors.white)
                
                Text("Add scents to see your collection statistics.")
                    .font(.playfairDisplay(.regular, size: 16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var overviewCards: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 16) {
            StatCard(
                title: "Total Scents",
                value: "\(viewModel.scents.count)",
                icon: "flame.fill",
                color: AppColors.yellow
            )
            
            StatCard(
                title: "Seasons",
                value: "\(Set(viewModel.scents.map { $0.season }).count)",
                icon: "calendar",
                color: AppColors.goldenYellow
            )
            
            StatCard(
                title: "Brands",
                value: "\(uniqueBrandsCount)",
                icon: "tag.fill",
                color: AppColors.brightYellow
            )
            
            StatCard(
                title: "This Month",
                value: "\(scentsAddedThisMonth)",
                icon: "plus.circle.fill",
                color: AppColors.amber
            )
        }
    }
    
    private var seasonDistribution: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Season Distribution")
                .font(.playfairDisplay(.bold, size: 20))
                .foregroundColor(AppColors.white)
            
            VStack(spacing: 12) {
                ForEach(Season.allCases, id: \.self) { season in
                    SeasonStatRow(
                        season: season,
                        count: seasonCount(season),
                        total: viewModel.scents.count
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var topBrands: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Brands")
                .font(.playfairDisplay(.bold, size: 20))
                .foregroundColor(AppColors.white)
            
            if topBrandsList.isEmpty {
                Text("No brands added yet")
                    .font(.playfairDisplay(.regular, size: 14))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(topBrandsList.prefix(5).enumerated()), id: \.element.brand) { index, item in
                        BrandStatRow(
                            rank: index + 1,
                            brand: item.brand,
                            count: item.count
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var uniqueBrandsCount: Int {
        let brands = viewModel.scents.map { $0.brand }.filter { !$0.isEmpty }
        return Set(brands).count
    }
    
    private var scentsAddedThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.scents.filter { scent in
            calendar.isDate(scent.dateAdded, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private func seasonCount(_ season: Season) -> Int {
        viewModel.scents.filter { $0.season == season }.count
    }
    
    private var topBrandsList: [(brand: String, count: Int)] {
        let brandCounts = Dictionary(grouping: viewModel.scents.filter { !$0.brand.isEmpty }, by: { $0.brand })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .map { (brand: $0.key, count: $0.value) }
        return brandCounts
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.playfairDisplay(.bold, size: 24))
                .foregroundColor(AppColors.white)
            
            Text(title)
                .font(.playfairDisplay(.medium, size: 12))
                .foregroundColor(AppColors.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.deepBlue.opacity(0.2), radius: 8, x: 0, y: 4)
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
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: season.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.yellow)
                        .frame(width: 24)
                    
                    Text(season.displayName)
                        .font(.playfairDisplay(.semiBold, size: 16))
                        .foregroundColor(AppColors.white)
                }
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(.bold, size: 18))
                    .foregroundColor(AppColors.yellow)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.yellowGradient)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 8)
    }
}

struct BrandStatRow: View {
    let rank: Int
    let brand: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.yellow.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Text("\(rank)")
                    .font(.playfairDisplay(.bold, size: 14))
                    .foregroundColor(AppColors.yellow)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(brand)
                    .font(.playfairDisplay(.semiBold, size: 16))
                    .foregroundColor(AppColors.white)
                
                Text("\(count) scent\(count == 1 ? "" : "s")")
                    .font(.playfairDisplay(.regular, size: 12))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(12)
        .background(AppColors.cardGradient.opacity(0.5))
        .cornerRadius(12)
    }
}
