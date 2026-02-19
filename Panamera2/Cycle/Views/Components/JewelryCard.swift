import SwiftUI

struct JewelryCard: View {
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
                
                Text(item.lastWornText)
                    .font(.bauhausLight(size: 14))
                    .foregroundColor(item.hasBeenWorn ? AppColors.darkGray : AppColors.darkGray.opacity(0.6))
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
}

#Preview {
    let sampleItem = JewelryItem(
        name: "Diamond Earrings",
        category: .earrings,
        description: "Beautiful diamond earrings",
        lastWornDate: Date()
    )
    
    JewelryCard(item: sampleItem, store: JewelryStore())
        .padding()
        .background(AppColors.backgroundGradient)
}
