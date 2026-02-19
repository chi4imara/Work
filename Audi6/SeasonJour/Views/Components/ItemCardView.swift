import SwiftUI

struct ItemCardView: View {
    let item: SeasonItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(FontManager.bauhausMedium(18))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: item.season.icon)
                            .foregroundColor(AppColors.primaryBlue)
                        Text(item.season.displayName)
                            .font(FontManager.bauhausLight(14))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
                
                Spacer()
                
                VStack {
                    if item.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(AppColors.accentPink)
                            .font(.system(size: 16))
                    }
                }
            }
            
            if !item.comment.isEmpty {
                Text(item.comment)
                    .font(FontManager.bauhausLight(14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ItemCardView(item: SeasonItem(name: "Light Trench Coat", season: .spring, comment: "Perfect for cool spring days", isFavorite: true))
        .padding()
}