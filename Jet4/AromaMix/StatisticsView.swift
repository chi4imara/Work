import SwiftUI

struct StatisticsView: View {
    @ObservedObject var combinationsViewModel: ScentCombinationsViewModel
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        statisticsCards
                        
                        categoryBreakdown
                        
                        ratingBreakdown
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Your Aroma Collection")
                .font(AppFonts.title)
                .foregroundColor(AppColors.darkGray)
        }
    }
    
    private var statisticsCards: some View {
        VStack(spacing: 16) {
            StatCard(
                title: "Total Combinations",
                value: "\(combinationsViewModel.combinations.count)",
                icon: "heart.circle.fill",
                color: AppColors.purpleGradientStart
            )
            
            StatCard(
                title: "Total Notes",
                value: "\(notesViewModel.notes.count)",
                icon: "note.text",
                color: AppColors.blueText
            )
            
            StatCard(
                title: "Favorite Combinations",
                value: "\(favoriteCount)",
                icon: "heart.fill",
                color: AppColors.warningRed
            )
        }
    }
    
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.darkGray)
            
            VStack(spacing: 12) {
                ForEach(ScentCategory.allCases, id: \.self) { category in
                    CategoryStatRow(
                        category: category,
                        count: categoryCount(for: category),
                        total: combinationsViewModel.combinations.count
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var ratingBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Rating")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.darkGray)
            
            VStack(spacing: 12) {
                ForEach(Rating.allCases, id: \.self) { rating in
                    RatingStatRow(
                        rating: rating,
                        count: ratingCount(for: rating),
                        total: combinationsViewModel.combinations.count
                    )
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var favoriteCount: Int {
        combinationsViewModel.combinations.filter { $0.rating == .favorite }.count
    }
    
    private func categoryCount(for category: ScentCategory) -> Int {
        combinationsViewModel.combinations.filter { $0.category == category }.count
    }
    
    private func ratingCount(for rating: Rating) -> Int {
        combinationsViewModel.combinations.filter { $0.rating == rating }.count
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.darkGray)
                
                Text(title)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CategoryStatRow: View {
    let category: ScentCategory
    let count: Int
    let total: Int
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 16))
                    .foregroundColor(categoryColor)
                
                Text(category.displayName)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Text("\(count)")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.darkGray)
            }
            
            if total > 0 {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.lightGray)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(categoryColor)
                            .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .warm: return Color.orange
        case .fresh: return Color.blue
        case .floral: return Color.pink
        case .sweet: return AppColors.yellowAccent
        case .other: return AppColors.purpleGradientStart
        }
    }
}

struct RatingStatRow: View {
    let rating: Rating
    let count: Int
    let total: Int
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: rating.icon)
                    .font(.system(size: 16))
                    .foregroundColor(ratingColor)
                
                Text(rating.displayName)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Text("\(count)")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.darkGray)
            }
            
            if total > 0 {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.lightGray)
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ratingColor)
                            .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }
    
    private var ratingColor: Color {
        switch rating {
        case .favorite: return AppColors.warningRed
        case .good: return AppColors.successGreen
        case .trial: return AppColors.yellowAccent
        }
    }
}

#Preview {
    StatisticsView(
        combinationsViewModel: ScentCombinationsViewModel(),
        notesViewModel: NotesViewModel()
    )
}
