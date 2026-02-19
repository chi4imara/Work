import SwiftUI

struct BagCardView: View {
    let bag: Bag
    let onFavoriteToggle: () -> Void
    let onTryOn: () -> Void
    
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme.cardBackground)
                    .frame(height: 120)
                
                if !bag.imageURL.isEmpty, let image = BagPhotoStorage.loadImage(filename: bag.imageURL) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } else {
                    Image(systemName: bag.category.icon)
                        .font(.system(size: 32))
                        .foregroundColor(Color.theme.accentYellow)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: onFavoriteToggle) {
                            Image(systemName: bag.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 14))
                                .foregroundColor(bag.isFavorite ? Color.red : Color.theme.secondaryText)
                        }
                        .padding(8)
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: onTryOn) {
                            HStack(spacing: 2) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 10))
                                Text("Try On")
                                    .font(.ubuntu(10, weight: .medium))
                            }
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.theme.primaryButton)
                            .cornerRadius(12)
                            .scaleEffect(isPulsing ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true),
                                value: isPulsing
                            )
                        }
                        .onAppear {
                            isPulsing = true
                        }
                        Spacer()
                    }
                    .padding(.bottom, 8)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(bag.name)
                    .font(.ubuntu(12, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .lineLimit(1)
                
                Text(bag.brand)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(Color.theme.accentText)
                    .lineLimit(1)
                
                HStack {
                    Text(bag.category.rawValue)
                        .font(.ubuntu(9))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Spacer()
                    
                    Text(bag.size.rawValue)
                        .font(.ubuntu(9))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                HStack {
                    Text("$\(String(format: "%.0f", bag.price))")
                        .font(.ubuntu(12, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(colorFromString(bag.color))
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                        
                        Text(bag.color)
                            .font(.ubuntu(9))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 6)
        }
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "black": return .black
        case "white": return .white
        case "brown": return .brown
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "pink": return .pink
        case "purple": return .purple
        case "orange": return .orange
        case "gray", "grey": return .gray
        case "navy": return Color(red: 0.0, green: 0.0, blue: 0.5)
        case "gold": return Color(red: 1.0, green: 0.8, blue: 0.0)
        default: return Color.theme.accentYellow
        }
    }
}

#Preview {
    BagCardView(
        bag: Bag(name: "Sample Bag", brand: "Brand", category: .tote, size: .medium, price: 199, imageURL: "", color: "Black", style: .casual, description: "Sample"),
        onFavoriteToggle: {},
        onTryOn: {}
    )
    .frame(width: 180)
    .padding()
    .background(Color.theme.gradientStart)
}
