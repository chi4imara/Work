import SwiftUI

struct StatisticsView: View {
    @ObservedObject var wardrobeViewModel: WardrobeViewModel
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(.primaryPurple)
                            
                            Text("Statistics")
                                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(.textPrimary)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            StatisticsCard(
                                title: "Total Items",
                                value: "\(wardrobeViewModel.items.count)",
                                icon: "tshirt.fill",
                                color: .primaryPurple
                            )
                            
                            StatisticsCard(
                                title: "Items in Use",
                                value: "\(wardrobeViewModel.items.filter { $0.status == .inUse }.count)",
                                icon: "checkmark.circle.fill",
                                color: .accentGreen
                            )
                            
                            StatisticsCard(
                                title: "Items to Store",
                                value: "\(wardrobeViewModel.items.filter { $0.status == .store }.count)",
                                icon: "archivebox.fill",
                                color: .primaryBlue
                            )
                            
                            StatisticsCard(
                                title: "Items to Buy",
                                value: "\(wardrobeViewModel.items.filter { $0.status == .buy }.count)",
                                icon: "cart.fill",
                                color: .accentOrange
                            )
                            
                            StatisticsCard(
                                title: "Total Notes",
                                value: "\(notesViewModel.notes.count)",
                                icon: "note.text",
                                color: .primaryYellow
                            )
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("By Season")
                                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                VStack(spacing: 12) {
                                    ForEach(Season.allCases, id: \.rawValue) { season in
                                        SeasonStatRow(
                                            season: season,
                                            count: wardrobeViewModel.items.filter { $0.season == season }.count
                                        )
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.cardBackground)
                                    .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: 4)
                            )
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("By Category")
                                    .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                VStack(spacing: 12) {
                                    ForEach(Category.allCases, id: \.rawValue) { category in
                                        CategoryStatRow(
                                            category: category,
                                            count: wardrobeViewModel.items.filter { $0.category == category }.count
                                        )
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.cardBackground)
                                    .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: 4)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
    }
}

struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
                
                Text(value)
                    .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

struct SeasonStatRow: View {
    let season: Season
    let count: Int
    
    var body: some View {
        HStack {
            Text(season.displayName)
                .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text("\(count)")
                .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(.primaryPurple)
        }
        .padding(.vertical, 8)
    }
}

struct CategoryStatRow: View {
    let category: Category
    let count: Int
    
    var body: some View {
        HStack {
            Text(category.displayName)
                .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text("\(count)")
                .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(.primaryBlue)
        }
        .padding(.vertical, 8)
    }
}
