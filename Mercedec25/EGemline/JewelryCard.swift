import SwiftUI

struct JewelryCard: View {
    let jewelryId: UUID
    @EnvironmentObject var appState: AppState
    @State private var isAnimating = false
    
    private var jewelry: Jewelry? {
        appState.getJewelry(by: jewelryId)
    }
    
    var body: some View {
        if let jewelry = jewelry {
            cardContent(jewelry: jewelry)
        }
    }
    
    private func cardContent(jewelry: Jewelry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                ColorTheme.lightGray,
                                ColorTheme.backgroundWhite
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .overlay(
                        VStack {
                            Image(systemName: getJewelryIcon(jewelry.category))
                                .font(.system(size: 40, weight: .light))
                                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
                            
                            Text(jewelry.name)
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(ColorTheme.secondaryText)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding()
                    )
                
                Button(action: {
                    if appState.isInCollection(id: jewelryId) {
                        appState.removeFromCollection(id: jewelryId)
                    } else {
                        appState.addToCollection(id: jewelryId)
                    }
                }) {
                    Image(systemName: appState.isInCollection(id: jewelryId) ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(appState.isInCollection(id: jewelryId) ? ColorTheme.softPink : ColorTheme.secondaryText)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(ColorTheme.backgroundWhite.opacity(0.9))
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 3)
                        )
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(jewelry.name)
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
                
                Text(jewelry.brand)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                
                HStack(spacing: 4) {
                    Text(jewelry.material)
                        .font(.playfairDisplay(10))
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .frame(maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(ColorTheme.primaryBlue.opacity(0.1))
                        )
                    
                    if !jewelry.stones.isEmpty && jewelry.stones != "None" {
                        Text(jewelry.stones)
                            .font(.playfairDisplay(10))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .frame(maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(ColorTheme.primaryYellow.opacity(0.2))
                            )
                    }
                }
                
                HStack {
                    Text("$\(Int(jewelry.price))")
                        .font(.playfairDisplay(16, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Text(jewelry.category.rawValue)
                        .font(.playfairDisplay(10))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
    
    private func getJewelryIcon(_ category: JewelryCategory) -> String {
        switch category {
        case .rings:
            return "circle.dashed"
        case .earrings:
            return "oval.portrait"
        case .bracelets:
            return "link.circle"
        case .necklaces:
            return "oval.portrait.bottomhalf.filled"
        }
    }
    
    private func startPulseAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
    }
    
    private func tryOnJewelry(jewelry: Jewelry) {
        let session = TryOnSession(
            date: Date(),
            jewelryId: jewelry.id,
            style: jewelry.style,
            brand: jewelry.brand,
            category: jewelry.category,
            notes: jewelry.notes.isEmpty ? "Virtual try-on session" : jewelry.notes
        )
        appState.addTryOnSession(session)
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]) {
            JewelryCard(jewelryId: UUID())
                .environmentObject(AppState())
        }
        .padding()
    }
    .background(ColorTheme.backgroundGradient)
}
