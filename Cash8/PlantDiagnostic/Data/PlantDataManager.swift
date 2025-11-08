import Foundation

class PlantDataManager {
    static let shared = PlantDataManager()
    
    private init() {}
    
    func getAllPlants() -> [Plant] {
        return [
            Plant(
                id: "1",
                name: "Monstera Deliciosa",
                latinName: "Monstera deliciosa",
                type: .indoor,
                difficulty: .easy,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Weekly",
                    amount: "Moderate",
                    notes: "Allow top inch of soil to dry between waterings. Water thoroughly until it drains from the bottom."
                ),
                repotting: RepottingInfo(
                    timing: "Every 2-3 years in spring",
                    soilType: "Well-draining potting mix with peat and perlite",
                    potRecommendations: "Use a pot 1-2 inches larger with drainage holes",
                    signs: "Roots growing out of drainage holes, water runs straight through"
                ),
                fertilizing: FertilizingInfo(
                    type: "Balanced liquid fertilizer (10-10-10)",
                    frequency: "Monthly during growing season (spring-summer)",
                    warnings: "Dilute to half strength to avoid fertilizer burn"
                ),
                lighting: LightingInfo(
                    preference: "Bright, indirect light",
                    directSun: false,
                    distance: "3-6 feet from a bright window"
                ),
                temperature: TemperatureInfo(
                    range: "65-80°F (18-27°C)",
                    humidity: "40-60%",
                    drafts: "Avoid cold drafts and heating vents"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Root Rot",
                        symptoms: "Yellow leaves, musty soil smell, black mushy roots",
                        treatment: "Remove from pot, trim black roots, repot in fresh soil, reduce watering"
                    ),
                    DiseaseInfo(
                        name: "Spider Mites",
                        symptoms: "Fine webbing on leaves, yellow stippling, leaf drop",
                        treatment: "Increase humidity, spray with neem oil, isolate plant"
                    )
                ],
                funFacts: [
                    "Can grow up to 10 feet indoors with proper support",
                    "Leaves develop characteristic holes (fenestrations) as they mature",
                    "Native to Central American rainforests",
                    "Also known as Swiss Cheese Plant"
                ]
            ),
            
            Plant(
                id: "2",
                name: "Snake Plant",
                latinName: "Sansevieria trifasciata",
                type: .indoor,
                difficulty: .easy,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Every 2-3 weeks",
                    amount: "Light",
                    notes: "Water sparingly. Allow soil to dry completely between waterings. Less water in winter."
                ),
                repotting: RepottingInfo(
                    timing: "Every 3-5 years",
                    soilType: "Cactus or succulent potting mix",
                    potRecommendations: "Heavy pot to prevent tipping, good drainage essential",
                    signs: "Plant becomes top-heavy, roots visible at surface"
                ),
                fertilizing: FertilizingInfo(
                    type: "Diluted liquid fertilizer",
                    frequency: "2-3 times during growing season",
                    warnings: "Over-fertilizing can cause leaf tips to brown"
                ),
                lighting: LightingInfo(
                    preference: "Low to bright indirect light",
                    directSun: false,
                    distance: "Tolerates various light conditions"
                ),
                temperature: TemperatureInfo(
                    range: "60-80°F (15-27°C)",
                    humidity: "30-50%",
                    drafts: "Tolerates dry air well"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Root Rot",
                        symptoms: "Soft, mushy base, yellowing leaves",
                        treatment: "Stop watering, remove affected parts, repot in dry soil"
                    )
                ],
                funFacts: [
                    "Can survive in very low light conditions",
                    "Produces oxygen at night, making it great for bedrooms",
                    "Also called Mother-in-Law's Tongue",
                    "Can propagate from leaf cuttings"
                ]
            ),
            
            Plant(
                id: "3",
                name: "Fiddle Leaf Fig",
                latinName: "Ficus lyrata",
                type: .indoor,
                difficulty: .hard,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Weekly",
                    amount: "Moderate",
                    notes: "Water when top 1-2 inches of soil are dry. Consistent watering schedule is important."
                ),
                repotting: RepottingInfo(
                    timing: "Every 1-2 years in spring",
                    soilType: "Well-draining potting mix with good aeration",
                    potRecommendations: "Heavy pot for stability, ensure drainage",
                    signs: "Roots circling pot, slow growth, frequent watering needed"
                ),
                fertilizing: FertilizingInfo(
                    type: "Balanced liquid fertilizer",
                    frequency: "Monthly in spring and summer",
                    warnings: "Avoid fertilizing in winter when growth slows"
                ),
                lighting: LightingInfo(
                    preference: "Bright, indirect light",
                    directSun: false,
                    distance: "Near a bright window but not in direct sun"
                ),
                temperature: TemperatureInfo(
                    range: "65-75°F (18-24°C)",
                    humidity: "40-65%",
                    drafts: "Very sensitive to temperature changes and drafts"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Brown Spots",
                        symptoms: "Brown spots with yellow halos on leaves",
                        treatment: "Remove affected leaves, improve air circulation, avoid overhead watering"
                    ),
                    DiseaseInfo(
                        name: "Leaf Drop",
                        symptoms: "Sudden dropping of healthy-looking leaves",
                        treatment: "Check for environmental stress, maintain consistent conditions"
                    )
                ],
                funFacts: [
                    "Can grow up to 50 feet in its native habitat",
                    "Leaves can grow up to 18 inches long",
                    "Very sensitive to environmental changes",
                    "Popular Instagram plant due to its dramatic appearance"
                ]
            ),
            
            Plant(
                id: "4",
                name: "Pothos",
                latinName: "Epipremnum aureum",
                type: .indoor,
                difficulty: .easy,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Weekly",
                    amount: "Moderate",
                    notes: "Water when top inch of soil feels dry. Can tolerate some neglect."
                ),
                repotting: RepottingInfo(
                    timing: "Every 1-2 years",
                    soilType: "Standard potting mix",
                    potRecommendations: "Any pot with drainage holes",
                    signs: "Roots growing from drainage holes, water runs through quickly"
                ),
                fertilizing: FertilizingInfo(
                    type: "Balanced liquid fertilizer",
                    frequency: "Monthly during growing season",
                    warnings: "Can survive without regular fertilizing"
                ),
                lighting: LightingInfo(
                    preference: "Low to bright indirect light",
                    directSun: false,
                    distance: "Very adaptable to different light conditions"
                ),
                temperature: TemperatureInfo(
                    range: "65-85°F (18-29°C)",
                    humidity: "40-60%",
                    drafts: "Tolerates normal household conditions"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Root Rot",
                        symptoms: "Yellow leaves, musty smell, black roots",
                        treatment: "Reduce watering, improve drainage, trim affected roots"
                    )
                ],
                funFacts: [
                    "Can grow in water indefinitely",
                    "Trails can grow several feet long",
                    "Also called Devil's Ivy",
                    "Excellent air purifier according to NASA studies"
                ]
            ),
            
            Plant(
                id: "5",
                name: "Peace Lily",
                latinName: "Spathiphyllum",
                type: .indoor,
                difficulty: .medium,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Weekly",
                    amount: "Moderate",
                    notes: "Likes consistently moist soil but not waterlogged. Droops when thirsty."
                ),
                repotting: RepottingInfo(
                    timing: "Every 1-2 years in spring",
                    soilType: "Well-draining potting mix",
                    potRecommendations: "Slightly larger pot with good drainage",
                    signs: "Roots visible at surface, frequent watering needed"
                ),
                fertilizing: FertilizingInfo(
                    type: "Balanced liquid fertilizer",
                    frequency: "Monthly during growing season",
                    warnings: "Over-fertilizing can prevent flowering"
                ),
                lighting: LightingInfo(
                    preference: "Low to medium indirect light",
                    directSun: false,
                    distance: "Away from direct sunlight"
                ),
                temperature: TemperatureInfo(
                    range: "65-80°F (18-27°C)",
                    humidity: "40-60%",
                    drafts: "Prefers stable temperatures"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Brown Leaf Tips",
                        symptoms: "Brown, crispy leaf tips",
                        treatment: "Increase humidity, use filtered water, check for over-fertilizing"
                    )
                ],
                funFacts: [
                    "Produces white flowers when happy",
                    "Excellent air purifier",
                    "Drooping leaves indicate it needs water",
                    "Can bloom multiple times per year"
                ]
            ),
            
            Plant(
                id: "6",
                name: "Rubber Plant",
                latinName: "Ficus elastica",
                type: .indoor,
                difficulty: .easy,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Weekly",
                    amount: "Moderate",
                    notes: "Water when top inch of soil is dry. Reduce watering in winter."
                ),
                repotting: RepottingInfo(
                    timing: "Every 1-2 years",
                    soilType: "Well-draining potting mix",
                    potRecommendations: "Sturdy pot as plant can get top-heavy",
                    signs: "Roots growing from drainage holes, slow growth"
                ),
                fertilizing: FertilizingInfo(
                    type: "Balanced liquid fertilizer",
                    frequency: "Monthly in spring and summer",
                    warnings: "Reduce or stop fertilizing in winter"
                ),
                lighting: LightingInfo(
                    preference: "Bright, indirect light",
                    directSun: false,
                    distance: "Near a bright window"
                ),
                temperature: TemperatureInfo(
                    range: "60-80°F (15-27°C)",
                    humidity: "40-50%",
                    drafts: "Avoid cold drafts"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Scale Insects",
                        symptoms: "Small brown bumps on stems and leaves",
                        treatment: "Wipe with alcohol, use insecticidal soap"
                    )
                ],
                funFacts: [
                    "Can grow into a large tree indoors",
                    "Glossy leaves can be wiped clean",
                    "Produces a milky sap when cut",
                    "Symbol of abundance in some cultures"
                ]
            ),
            
            Plant(
                id: "7",
                name: "Lavender",
                latinName: "Lavandula",
                type: .outdoor,
                difficulty: .medium,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Weekly when young, less when established",
                    amount: "Deep but infrequent",
                    notes: "Drought tolerant once established. Avoid overwatering."
                ),
                repotting: RepottingInfo(
                    timing: "Every 2-3 years for potted plants",
                    soilType: "Sandy, well-draining soil",
                    potRecommendations: "Terra cotta pots with excellent drainage",
                    signs: "Plant becomes root-bound, reduced flowering"
                ),
                fertilizing: FertilizingInfo(
                    type: "Low-nitrogen fertilizer",
                    frequency: "Once in spring",
                    warnings: "Too much fertilizer reduces fragrance and flowering"
                ),
                lighting: LightingInfo(
                    preference: "Full sun",
                    directSun: true,
                    distance: "At least 6 hours of direct sunlight daily"
                ),
                temperature: TemperatureInfo(
                    range: "60-70°F (15-21°C) ideal",
                    humidity: "Low humidity preferred",
                    drafts: "Good air circulation important"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Root Rot",
                        symptoms: "Yellowing leaves, wilting despite moist soil",
                        treatment: "Improve drainage, reduce watering, remove affected parts"
                    )
                ],
                funFacts: [
                    "Used for aromatherapy and relaxation",
                    "Attracts bees and butterflies",
                    "Can be harvested for culinary use",
                    "Drought tolerant once established"
                ]
            ),
            
            Plant(
                id: "8",
                name: "Tomato",
                latinName: "Solanum lycopersicum",
                type: .outdoor,
                difficulty: .medium,
                imageName: nil,
                watering: WateringInfo(
                    frequency: "Daily in hot weather",
                    amount: "Deep, consistent watering",
                    notes: "Keep soil consistently moist but not waterlogged. Water at base of plant."
                ),
                repotting: RepottingInfo(
                    timing: "Start seeds indoors, transplant after last frost",
                    soilType: "Rich, well-draining garden soil",
                    potRecommendations: "Large containers (5+ gallons) for container growing",
                    signs: "Seedlings ready when 6-8 inches tall"
                ),
                fertilizing: FertilizingInfo(
                    type: "Balanced fertilizer, then high-potassium when fruiting",
                    frequency: "Every 2-3 weeks during growing season",
                    warnings: "Too much nitrogen produces leaves but few fruits"
                ),
                lighting: LightingInfo(
                    preference: "Full sun",
                    directSun: true,
                    distance: "6-8 hours of direct sunlight daily"
                ),
                temperature: TemperatureInfo(
                    range: "70-80°F (21-27°C) during day",
                    humidity: "Moderate humidity",
                    drafts: "Protect from strong winds"
                ),
                diseases: [
                    DiseaseInfo(
                        name: "Blight",
                        symptoms: "Brown spots on leaves, spreading to stems",
                        treatment: "Remove affected parts, improve air circulation, fungicide if severe"
                    ),
                    DiseaseInfo(
                        name: "Blossom End Rot",
                        symptoms: "Dark, sunken spots on bottom of fruits",
                        treatment: "Ensure consistent watering, add calcium to soil"
                    )
                ],
                funFacts: [
                    "Technically a fruit, botanically speaking",
                    "Can be grown in containers",
                    "Companion plant well with basil",
                    "Over 10,000 varieties exist worldwide"
                ]
            )
        ]
    }
    
    func getPlantById(_ id: String) -> Plant? {
        return getAllPlants().first { $0.id == id }
    }
    
    func getPlantsByType(_ type: Plant.PlantType) -> [Plant] {
        return getAllPlants().filter { $0.type == type }
    }
    
    func getPlantsByDifficulty(_ difficulty: Plant.Difficulty) -> [Plant] {
        return getAllPlants().filter { $0.difficulty == difficulty }
    }
    
    func searchPlants(_ query: String) -> [Plant] {
        guard !query.isEmpty else { return getAllPlants() }
        
        let lowercaseQuery = query.lowercased()
        return getAllPlants().filter { plant in
            plant.name.lowercased().contains(lowercaseQuery) ||
            plant.latinName?.lowercased().contains(lowercaseQuery) == true
        }
    }
    
    func getFavoritePlants(favoriteIds: Set<String>) -> [Plant] {
        let allPlants = getAllPlants()
        return allPlants.filter { favoriteIds.contains($0.id) }
    }
}
