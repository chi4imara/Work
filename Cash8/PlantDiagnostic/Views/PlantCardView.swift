import SwiftUI

struct PlantCardView: View {
    let plant: Plant
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppGradients.cardGradient)
                    .frame(height: 120)
                
                if let imageName = plant.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.accentGreen.opacity(0.6))
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            appState.toggleFavorite(plant.id)
                        }) {
                            Image(systemName: appState.isFavorite(plant.id) ? "heart.fill" : "heart")
                                .font(.system(size: 18))
                                .foregroundColor(appState.isFavorite(plant.id) ? .red : .white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(plant.name)
                    .font(.titleSmall)
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                
                if let latinName = plant.latinName {
                    Text(latinName)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                        .italic()
                        .lineLimit(1)
                }
                
                HStack(spacing: 6) {
                    TagView(text: plant.type.rawValue, color: .accentBlue)
                    TagView(text: plant.difficulty.rawValue, color: difficultyColor(plant.difficulty))
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(12)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
    }
    
    private func difficultyColor(_ difficulty: Plant.Difficulty) -> Color {
        switch difficulty {
        case .easy:
            return .accentGreen
        case .medium:
            return .accentOrange
        case .hard:
            return .red
        }
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }
}

#Preview {
    PlantCardView(plant: Plant(
        id: "1",
        name: "Monstera Deliciosa",
        latinName: "Monstera deliciosa",
        type: .indoor,
        difficulty: .easy,
        imageName: nil,
        watering: WateringInfo(frequency: "Weekly", amount: "Moderate", notes: "Allow soil to dry between waterings"),
        repotting: RepottingInfo(timing: "Every 2-3 years", soilType: "Well-draining potting mix", potRecommendations: "Use a pot with drainage holes", signs: "Roots growing out of drainage holes"),
        fertilizing: FertilizingInfo(type: "Balanced liquid fertilizer", frequency: "Monthly during growing season", warnings: "Dilute to half strength"),
        lighting: LightingInfo(preference: "Bright, indirect light", directSun: false, distance: "3-6 feet from window"),
        temperature: TemperatureInfo(range: "65-80°F (18-27°C)", humidity: "40-60%", drafts: "Avoid cold drafts"),
        diseases: [],
        funFacts: ["Can grow up to 10 feet indoors", "Leaves develop holes as they mature"]
    ))
    .environmentObject(AppState())
    .frame(width: 180)
}
