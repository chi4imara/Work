import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                    
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Total Items",
                            value: "\(viewModel.wardrobeItems.count)",
                            icon: "tshirt.fill"
                        )
                        StatCard(
                            title: "Outfits",
                            value: "\(viewModel.outfits.count)",
                            icon: "heart.fill"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Items by Category")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, 20)
                        
                        if viewModel.wardrobeItems.isEmpty {
                            Text("No items yet")
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(viewModel.categories, id: \.id) { category in
                                    let count = viewModel.itemsInCategory(category.name).count
                                    let total = max(viewModel.wardrobeItems.count, 1)
                                    let fraction = CGFloat(count) / CGFloat(total)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text(category.name)
                                                .font(.ubuntu(14, weight: .medium))
                                                .foregroundColor(AppColors.textPrimary)
                                            Spacer()
                                            Text("\(count)")
                                                .font(.ubuntu(14))
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(AppColors.cardBackground)
                                                    .frame(height: 8)
                                                
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(AppColors.primary)
                                                    .frame(width: geometry.size.width * fraction, height: 8)
                                            }
                                        }
                                        .frame(height: 8)
                                    }
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.cardBackground)
                                            .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    if !viewModel.wardrobeItems.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Activity")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 16) {
                                MiniStatBox(
                                    title: "Categories",
                                    value: "\(viewModel.categories.count)"
                                )
                                MiniStatBox(
                                    title: "Last 7 days",
                                    value: "\(outfitsLast7Days)"
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private var outfitsLast7Days: Int {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        return viewModel.outfits.filter { $0.dateCreated >= weekAgo }.count
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(AppColors.accent)
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(.ubuntu(12))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 4)
        )
    }
}

struct MiniStatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primary)
            Text(title)
                .font(.ubuntu(12))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    StatisticsView()
        .environmentObject(WardrobeViewModel())
}
