import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: HairstyleViewModel
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        overviewSection
                        categoryBreakdownSection
                        colorsSection
                        timelineSection
                    }
                    .padding(.horizontal, AppDimensions.screenPadding)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Hair Statistics")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            Text("Overview of your hairstyles and looks")
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Hairstyles",
                    value: "\(viewModel.hairstyles.count)",
                    icon: "scissors"
                )
                
                StatCard(
                    title: "Total Looks",
                    value: "\(viewModel.looks.count)",
                    icon: "photo.on.rectangle"
                )
                
                StatCard(
                    title: "Categories Used",
                    value: "\(Set(viewModel.hairstyles.map { $0.category }).count)",
                    icon: "folder"
                )
                
                StatCard(
                    title: "Favorite Looks",
                    value: "\(viewModel.looks.filter { $0.isFavorite }.count)",
                    icon: "heart.fill"
                )
            }
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                ForEach(HairstyleCategory.allCases, id: \.self) { category in
                    HStack {
                        Image(systemName: categoryIcon(category))
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryYellow)
                            .frame(width: 28)
                        
                        Text(category.displayName)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Text("\(viewModel.getHairstyles(for: category).count)")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.primaryYellow)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(AppColors.primaryWhite.opacity(0.1))
                    .cornerRadius(AppDimensions.smallCornerRadius)
                }
            }
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Hair Colors")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            let colorCounts = Dictionary(grouping: viewModel.hairstyles, by: { $0.hairColor }).mapValues { $0.count }
            let sortedColors = colorCounts.sorted { $0.value > $1.value }.prefix(5)
            
            if sortedColors.isEmpty {
                Text("No data yet")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(sortedColors), id: \.key) { color, count in
                        HStack {
                            Text(color.isEmpty ? "Not set" : color)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryWhite)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(AppFonts.subtitle)
                                .foregroundColor(AppColors.primaryYellow)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(AppColors.primaryWhite.opacity(0.1))
                        .cornerRadius(AppDimensions.smallCornerRadius)
                    }
                }
            }
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Month")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primaryWhite)
            
            let thisMonth = Calendar.current.dateInterval(of: .month, for: Date())
            let hairstylesThisMonth = viewModel.hairstyles.filter { thisMonth?.contains($0.dateCreated) == true }
            let looksThisMonth = viewModel.looks.filter { thisMonth?.contains($0.dateCreated) == true }
            
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("\(hairstylesThisMonth.count)")
                        .font(FontManager.playfairBold(size: 32))
                        .foregroundColor(AppColors.primaryYellow)
                    Text("Hairstyles")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppColors.primaryWhite.opacity(0.1))
                .cornerRadius(AppDimensions.cornerRadius)
                
                VStack(spacing: 8) {
                    Text("\(looksThisMonth.count)")
                        .font(FontManager.playfairBold(size: 32))
                        .foregroundColor(AppColors.primaryYellow)
                    Text("Looks")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(AppColors.primaryWhite.opacity(0.1))
                .cornerRadius(AppDimensions.cornerRadius)
            }
        }
        .padding()
        .background(AppColors.primaryWhite.opacity(0.1))
        .cornerRadius(AppDimensions.cornerRadius)
    }
    
    private func categoryIcon(_ category: HairstyleCategory) -> String {
        switch category {
        case .cuts: return "scissors"
        case .styling: return "comb"
        case .color: return "paintbrush"
        case .braids: return "link"
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(HairstyleViewModel())
}
