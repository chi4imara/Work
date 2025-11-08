import SwiftUI

struct GiftIdeaCardView: View {
    let gift: GiftIdea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(gift.recipientName)
                    .font(.theme.headline)
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                StatusBadge(status: gift.status)
            }
            
            Text(gift.giftDescription)
                .font(.theme.body)
                .foregroundColor(Color.theme.primaryText)
                .lineLimit(2)
            
            HStack {
                if let occasion = gift.occasion {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(Color.theme.secondaryText)
                        Text(occasion.displayName)
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                
                Spacer()
                
                if let price = gift.estimatedPrice {
                    Text(String(format: "$%.2f", price))
                        .font(.theme.headline)
                        .foregroundColor(Color.theme.primaryBlue)
                }
            }
            
            if !gift.comment.isEmpty {
                Text(gift.comment)
                    .font(.theme.caption)
                    .foregroundColor(Color.theme.secondaryText)
                    .italic()
                    .lineLimit(2)
            }
            
            HStack {
                Spacer()
                Text("Added \(gift.dateAdded, formatter: dateFormatter)")
                    .font(.theme.caption2)
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(16)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct StatusBadge: View {
    let status: GiftStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.iconName)
                .font(.caption)
            Text(status.displayName)
                .font(.theme.caption)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor)
        .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch status {
        case .idea:
            return Color.theme.ideaColor
        case .bought:
            return Color.theme.boughtColor
        case .gifted:
            return Color.theme.giftedColor
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

