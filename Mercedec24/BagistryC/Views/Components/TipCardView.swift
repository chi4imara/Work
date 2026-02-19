import SwiftUI

struct TipCardView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color.theme.accentYellow)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.ubuntu(14))
                .foregroundColor(Color.theme.primaryText)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(12)
        .background(Color.theme.cardBackground)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 8) {
        TipCardView(
            icon: "lightbulb.fill",
            text: "Try neutral colors for office looks"
        )
        
        TipCardView(
            icon: "star.fill",
            text: "Small bags work great for evening events"
        )
    }
    .padding()
    .background(Color.theme.gradientStart)
}