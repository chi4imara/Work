import SwiftUI

struct PlaceCardView: View {
    let place: Place
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(place.name)
                        .font(FontManager.headline)
                        .foregroundColor(ColorTheme.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if place.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14))
                            .foregroundColor(ColorTheme.accentOrange)
                    }
                }
                
                Text(place.category)
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.secondaryText)
                
                if !place.address.isEmpty {
                    Text(place.address)
                        .font(FontManager.footnote)
                        .foregroundColor(ColorTheme.blueText)
                        .lineLimit(1)
                }
                
                if !place.note.isEmpty {
                    Text(place.note)
                        .font(FontManager.footnote)
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.lightBlue)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}
