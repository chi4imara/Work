import SwiftUI

struct StatisticsView: View {
    @ObservedObject var bagStore: BagStore
    
    var totalBags: Int {
        bagStore.bags.count
    }
    
    var favoriteBags: Int {
        bagStore.favoriteBags.count
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.bellGothic(32, weight: .bold))
                        .foregroundColor(.appDarkBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.cardGradient)
                                    .frame(width: 120, height: 120)
                                    .shadow(color: Color.appPrimaryBlue.opacity(0.2), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundColor(.appPrimaryBlue)
                            }
                            
                            Text("Bag Collector")
                                .font(.bellGothic(24, weight: .bold))
                                .foregroundColor(.appDarkBlue)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            StatCard(
                                title: "Total Bags",
                                value: "\(totalBags)",
                                icon: "bag.fill",
                                color: .appPrimaryBlue
                            )
                            
                            StatCard(
                                title: "Favorite Bags",
                                value: "\(favoriteBags)",
                                icon: "heart.fill",
                                color: .red
                            )
                            
                            StatCard(
                                title: "Categories",
                                value: "\(bagStore.sizeCategories.count + bagStore.styleCategories.count)",
                                icon: "square.grid.2x2",
                                color: .appAccentYellow
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .font(.bellGothic(20, weight: .bold))
                                .foregroundColor(.appDarkBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 12) {
                                AchievementRow(
                                    title: "First Bag",
                                    description: "Added your first bag",
                                    isUnlocked: totalBags >= 1,
                                    icon: "bag"
                                )
                                
                                AchievementRow(
                                    title: "Collector",
                                    description: "Added 5 bags",
                                    isUnlocked: totalBags >= 5,
                                    icon: "star"
                                )
                                
                                AchievementRow(
                                    title: "Organizer",
                                    description: "Added 10 bags",
                                    isUnlocked: totalBags >= 10,
                                    icon: "crown"
                                )
                                
                                AchievementRow(
                                    title: "Favorite Finder",
                                    description: "Added first favorite",
                                    isUnlocked: favoriteBags >= 1,
                                    icon: "heart"
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bellGothic(14))
                    .foregroundColor(.appTextDark)
                
                Text(value)
                    .font(.bellGothic(24, weight: .bold))
                    .foregroundColor(.appDarkBlue)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct AchievementRow: View {
    let title: String
    let description: String
    let isUnlocked: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon + (isUnlocked ? ".fill" : ""))
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isUnlocked ? .appAccentYellow : .gray)
                .frame(width: 32, height: 32)
                .background((isUnlocked ? Color.appAccentYellow : Color.gray).opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(isUnlocked ? .appDarkBlue : .gray)
                
                Text(description)
                    .font(.bellGothic(12))
                    .foregroundColor(isUnlocked ? .appTextDark : .gray)
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            }
        }
        .padding(12)
        .background(Color.white.opacity(isUnlocked ? 1.0 : 0.5))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(isUnlocked ? 0.05 : 0.02), radius: 4, x: 0, y: 2)
    }
}
