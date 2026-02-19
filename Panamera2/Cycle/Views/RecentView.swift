import SwiftUI

struct RecentView: View {
    @EnvironmentObject var store: JewelryStore

    var recentItems: [JewelryItem] {
        store.getRecentItems()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Recent")
                        .font(.bauhausBold(size: 28))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if recentItems.isEmpty {
                    EmptyRecentView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(recentItems) { item in
                                NavigationLink(destination: JewelryDetailView(itemId: item.id, store: store)) {
                                    RecentJewelryCard(item: item, store: store)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct RecentJewelryCard: View {
    let item: JewelryItem
    let store: JewelryStore
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.bauhausBold(size: 18))
                    .foregroundColor(AppColors.darkGray)
                    .lineLimit(1)
                
                Text(item.displayCategory)
                    .font(.bauhausRegular(size: 14))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                
                if let lastWorn = item.lastWornDate {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.accentYellow)
                        
                        Text(timeAgoString(from: lastWorn))
                            .font(.bauhausLight(size: 14))
                            .foregroundColor(AppColors.darkGray)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                store.markAsWornToday(item)
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColors.primaryWhite)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(AppColors.accentYellow)
                            .shadow(radius: 3)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let days = calendar.dateComponents([.day], from: date, to: now).day ?? 0
            return "\(days) days ago"
        }
    }
}

struct EmptyRecentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No recent records")
                .font(.bauhausBold(size: 20))
                .foregroundColor(AppColors.primaryWhite)
                .multilineTextAlignment(.center)
            
            Text("Mark jewelry as worn to see recent activity")
                .font(.bauhausRegular(size: 16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    RecentView()
}
