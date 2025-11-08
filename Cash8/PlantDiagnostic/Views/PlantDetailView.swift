import SwiftUI
import UIKit

struct PlantDetailView: View {
    let plant: Plant
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    
    private let tabs = ["Care", "Info", "Diseases"]
    
    var body: some View {
        
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        if let imageName = plant.imageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                                .clipped()
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        } else {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.accentGreen.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            appState.toggleFavorite(plant.id)
                        }) {
                            Image(systemName: appState.isFavorite(plant.id) ? "heart.fill" : "heart")
                                .font(.system(size: 18))
                                .foregroundColor(appState.isFavorite(plant.id) ? .red : .white)
                                .padding(10)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    plantInfoCard
                    
                    tabSelectionView
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        tabContentView
                    }
                    .padding(.top, 20)
                }
                .padding(.top, -5)
                
            }
        }
        .navigationBarHidden(true)
    }
    
    private var plantInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name)
                    .font(.titleLarge)
                    .foregroundColor(.primaryText)
                
                if let latinName = plant.latinName {
                    Text(latinName)
                        .font(.bodyMedium)
                        .foregroundColor(.secondaryText)
                        .italic()
                }
            }
            
            HStack(spacing: 12) {
                TagView(text: plant.type.rawValue, color: .accentBlue)
                TagView(text: plant.difficulty.rawValue, color: difficultyColor(plant.difficulty))
                
                Spacer()
            }
        }
        .padding(20)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .offset(y: -20)
    }
    
    private var tabSelectionView: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    Text(tabs[index])
                        .font(.buttonText)
                        .foregroundColor(selectedTab == index ? .accentGreen : .secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .fill(selectedTab == index ? Color.accentGreen.opacity(0.1) : Color.clear)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(0)
        .offset(y: -10)
    }
    
    private var tabContentView: some View {
        VStack(spacing: 20) {
            switch selectedTab {
            case 0:
                careTabContent
            case 1:
                infoTabContent
            case 2:
                diseasesTabContent
            default:
                careTabContent
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .offset(y: -20)
    }
    
    private var careTabContent: some View {
        VStack(spacing: 16) {
            CareInfoCard(
                icon: "drop.fill",
                title: "Watering",
                frequency: plant.watering.frequency,
                details: plant.watering.notes,
                color: .accentBlue
            )
            
            CareInfoCard(
                icon: "sun.max.fill",
                title: "Lighting",
                frequency: plant.lighting.preference,
                details: "Distance: \(plant.lighting.distance)",
                color: .accentOrange
            )
            
            CareInfoCard(
                icon: "thermometer",
                title: "Temperature",
                frequency: plant.temperature.range,
                details: "Humidity: \(plant.temperature.humidity)",
                color: .accentPurple
            )
            
            CareInfoCard(
                icon: "leaf.arrow.circlepath",
                title: "Fertilizing",
                frequency: plant.fertilizing.frequency,
                details: plant.fertilizing.type,
                color: .accentGreen
            )
        }
    }
    
    private var infoTabContent: some View {
        VStack(spacing: 16) {
            InfoCard(
                title: "Repotting",
                content: "Timing: \(plant.repotting.timing)\nSoil: \(plant.repotting.soilType)\nSigns: \(plant.repotting.signs)"
            )
            
            if !plant.funFacts.isEmpty {
                InfoCard(
                    title: "Fun Facts",
                    content: plant.funFacts.joined(separator: "\n• ")
                )
            }
        }
    }
    
    private var diseasesTabContent: some View {
        VStack(spacing: 16) {
            if plant.diseases.isEmpty {
                Text("No common diseases reported for this plant.")
                    .font(.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .padding(.top, 40)
            } else {
                ForEach(plant.diseases, id: \.name) { disease in
                    DiseaseCard(disease: disease)
                }
            }
        }
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

struct CareInfoCard: View {
    let icon: String
    let title: String
    let frequency: String
    let details: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.titleSmall)
                    .foregroundColor(.primaryText)
                
                Text(frequency)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryText)
                    .fontWeight(.medium)
                
                Text(details)
                    .font(.bodySmall)
                    .foregroundColor(.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct InfoCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.titleSmall)
                .foregroundColor(.primaryText)
            
            Text(content)
                .font(.bodyMedium)
                .foregroundColor(.primaryText)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct DiseaseCard: View {
    let disease: DiseaseInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(disease.name)
                .font(.titleSmall)
                .foregroundColor(.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Symptoms:")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text(disease.symptoms)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryText)
                
                Text("Treatment:")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text(disease.treatment)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    PlantDetailView(plant: Plant(
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
        diseases: [
            DiseaseInfo(name: "Root Rot", symptoms: "Yellow leaves, musty smell", treatment: "Reduce watering, improve drainage")
        ],
        funFacts: ["Can grow up to 10 feet indoors", "Leaves develop holes as they mature"]
    ))
    .environmentObject(AppState())
}
