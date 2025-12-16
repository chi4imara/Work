import SwiftUI

struct TipsView: View {
    @State private var selectedCategory: PlantTip.TipCategory? = nil
    @State private var selectedSeason: PlantTip.TipSeason? = nil
    @State private var searchText = ""
    
    private let tips: [PlantTip] = [
        PlantTip(
            title: "Watering Frequency",
            description: "Check soil moisture by inserting your finger 2cm deep. Water only when soil feels dry to touch.",
            category: .watering,
            difficulty: .beginner,
            season: .all,
            icon: "drop.fill"
        ),
        PlantTip(
            title: "Proper Lighting",
            description: "Most houseplants need bright, indirect light. Avoid direct sunlight which can burn leaves.",
            category: .lighting,
            difficulty: .beginner,
            season: .all,
            icon: "sun.max.fill"
        ),
        PlantTip(
            title: "Fertilizing Schedule",
            description: "Fertilize during growing season (spring-summer) every 2-4 weeks. Reduce in winter.",
            category: .fertilizing,
            difficulty: .intermediate,
            season: .spring,
            icon: "leaf.fill"
        ),
        PlantTip(
            title: "When to Repot",
            description: "Repot when roots are visible at drainage holes or plant has outgrown its container.",
            category: .repotting,
            difficulty: .intermediate,
            season: .spring,
            icon: "shippingbox.fill"
        ),
        PlantTip(
            title: "Pruning Techniques",
            description: "Prune just above a leaf node to encourage bushier growth. Use clean, sharp scissors.",
            category: .pruning,
            difficulty: .intermediate,
            season: .spring,
            icon: "scissors"
        ),
        PlantTip(
            title: "Yellow Leaves",
            description: "Yellow leaves often indicate overwatering. Check soil moisture and adjust watering schedule.",
            category: .troubleshooting,
            difficulty: .beginner,
            season: .all,
            icon: "exclamationmark.triangle.fill"
        ),
        PlantTip(
            title: "Winter Care",
            description: "Reduce watering frequency in winter. Most plants go dormant and need less water.",
            category: .watering,
            difficulty: .beginner,
            season: .winter,
            icon: "snowflake"
        ),
        PlantTip(
            title: "Humidity Tips",
            description: "Group plants together or use a humidifier to increase humidity for tropical plants.",
            category: .troubleshooting,
            difficulty: .intermediate,
            season: .winter,
            icon: "cloud.fog.fill"
        ),
        PlantTip(
            title: "Root Rot Prevention",
            description: "Ensure good drainage and never let plants sit in water. Use pots with drainage holes.",
            category: .troubleshooting,
            difficulty: .beginner,
            season: .all,
            icon: "exclamationmark.octagon.fill"
        ),
        PlantTip(
            title: "Propagation Basics",
            description: "Many plants can be propagated from cuttings. Cut below a node and place in water or soil.",
            category: .pruning,
            difficulty: .intermediate,
            season: .spring,
            icon: "arrow.branch"
        ),
        PlantTip(
            title: "Seasonal Watering",
            description: "Plants need more water in spring/summer during active growth. Reduce in fall/winter.",
            category: .watering,
            difficulty: .beginner,
            season: .all,
            icon: "calendar"
        ),
        PlantTip(
            title: "Light Requirements",
            description: "Low light: 2-4 hours indirect light. Medium light: 4-6 hours. Bright light: 6+ hours.",
            category: .lighting,
            difficulty: .beginner,
            season: .all,
            icon: "lightbulb.fill"
        ),
        PlantTip(
            title: "Pest Prevention",
            description: "Keep plants clean, check regularly for pests, and isolate new plants for a few weeks.",
            category: .troubleshooting,
            difficulty: .intermediate,
            season: .all,
            icon: "ant.fill"
        )
    ]
    
    var filteredTips: [PlantTip] {
        var result = tips
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if let season = selectedSeason {
            result = result.filter { $0.season == season || $0.season == .all }
        }
        
        if !searchText.isEmpty {
            result = result.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Plant Care Tips")
                                .font(.playfair(.bold, size: 28))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.secondaryText)
                        
                        TextField("Search tips...", text: $searchText)
                            .font(.playfair(.regular, size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardGradient)
                            .shadow(color: AppColors.lightBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterChip(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(PlantTip.TipCategory.allCases, id: \.self) { category in
                                FilterChip(
                                    title: category.displayName,
                                    isSelected: selectedCategory == category,
                                    action: { 
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(PlantTip.TipSeason.allCases, id: \.self) { season in
                                FilterChip(
                                    title: season.displayName,
                                    isSelected: selectedSeason == season,
                                    action: { 
                                        selectedSeason = selectedSeason == season ? nil : season
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTips) { tip in
                            TipCard(tip: tip)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.playfair(.medium, size: 14))
                .foregroundColor(isSelected ? .white : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AnyShapeStyle(AppColors.primaryBlue) : AnyShapeStyle(AppColors.cardGradient))
                )
        }
    }
}

struct TipCard: View {
    let tip: PlantTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: tip.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryBlue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tip.title)
                        .font(.playfair(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Text(tip.category.displayName)
                                .font(.playfair(.regular, size: 12))
                                .foregroundColor(AppColors.primaryBlue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppColors.primaryBlue.opacity(0.1))
                                )
                            
                            Text(tip.difficulty.displayName)
                                .font(.playfair(.regular, size: 12))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(tip.season.displayName)
                                .font(.playfair(.regular, size: 12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text(tip.description)
                .font(.playfair(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    TipsView()
}
