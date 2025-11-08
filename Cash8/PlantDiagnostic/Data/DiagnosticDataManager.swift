import Foundation

class DiagnosticDataManager {
    static let shared = DiagnosticDataManager()
    
    private init() {}
    
    func getAllSymptoms() -> [DiagnosticSymptom] {
        return [
            DiagnosticSymptom(
                id: "1",
                symptom: "yellow leaves",
                possibleCauses: [
                    PossibleCause(
                        id: "1a",
                        name: "Overwatering",
                        description: "Too much water causes root rot and yellowing leaves",
                        symptoms: "Yellow leaves starting from bottom, musty soil smell, soft stems",
                        treatment: "Stop watering immediately. Check roots for rot. Remove affected roots and repot in fresh, well-draining soil. Reduce watering frequency.",
                        prevention: "Water only when top inch of soil is dry. Ensure proper drainage holes in pot."
                    ),
                    PossibleCause(
                        id: "1b",
                        name: "Underwatering",
                        description: "Lack of water causes stress and leaf yellowing",
                        symptoms: "Yellow leaves, dry soil, wilting, leaves feel crispy",
                        treatment: "Water thoroughly until water drains from bottom. Increase watering frequency gradually.",
                        prevention: "Check soil moisture regularly. Water when top inch feels dry."
                    ),
                    PossibleCause(
                        id: "1c",
                        name: "Natural Aging",
                        description: "Older leaves naturally yellow and drop",
                        symptoms: "Only older, lower leaves turning yellow, new growth looks healthy",
                        treatment: "Simply remove yellowed leaves. This is normal plant behavior.",
                        prevention: "No prevention needed - this is natural."
                    )
                ]
            ),
            DiagnosticSymptom(
                id: "2",
                symptom: "brown leaves",
                possibleCauses: [
                    PossibleCause(
                        id: "2a",
                        name: "Low Humidity",
                        description: "Dry air causes leaf edges to brown",
                        symptoms: "Brown, crispy leaf edges, leaves feel dry",
                        treatment: "Increase humidity around plant using humidifier, pebble trays, or grouping plants together.",
                        prevention: "Maintain 40-60% humidity, especially in winter."
                    ),
                    PossibleCause(
                        id: "2b",
                        name: "Too Much Direct Sun",
                        description: "Intense sunlight burns plant leaves",
                        symptoms: "Brown patches on leaves facing light source, bleached appearance",
                        treatment: "Move plant away from direct sunlight or provide shade during peak hours.",
                        prevention: "Know your plant's light requirements and place accordingly."
                    ),
                    PossibleCause(
                        id: "2c",
                        name: "Fertilizer Burn",
                        description: "Too much fertilizer damages roots and leaves",
                        symptoms: "Brown leaf tips and edges, white crust on soil surface",
                        treatment: "Flush soil with water to remove excess salts. Stop fertilizing for several weeks.",
                        prevention: "Always dilute fertilizer to half strength. Follow package directions."
                    )
                ]
            ),
            DiagnosticSymptom(
                id: "3",
                symptom: "wilting",
                possibleCauses: [
                    PossibleCause(
                        id: "3a",
                        name: "Underwatering",
                        description: "Plant lacks sufficient water",
                        symptoms: "Drooping leaves, dry soil, leaves feel limp",
                        treatment: "Water thoroughly and deeply. Check that water reaches all roots.",
                        prevention: "Establish regular watering schedule based on plant needs."
                    ),
                    PossibleCause(
                        id: "3b",
                        name: "Root Rot",
                        description: "Damaged roots cannot uptake water",
                        symptoms: "Wilting despite moist soil, musty smell, black roots",
                        treatment: "Remove from pot, trim black/mushy roots, repot in fresh soil.",
                        prevention: "Avoid overwatering and ensure good drainage."
                    ),
                    PossibleCause(
                        id: "3c",
                        name: "Heat Stress",
                        description: "High temperatures cause water loss",
                        symptoms: "Wilting during hottest part of day, recovery in evening",
                        treatment: "Move to cooler location, increase watering frequency, provide shade.",
                        prevention: "Protect from afternoon sun and maintain consistent temperatures."
                    )
                ]
            ),
            DiagnosticSymptom(
                id: "4",
                symptom: "dropping leaves",
                possibleCauses: [
                    PossibleCause(
                        id: "4a",
                        name: "Environmental Stress",
                        description: "Changes in environment shock the plant",
                        symptoms: "Sudden leaf drop after moving or repotting",
                        treatment: "Keep conditions stable, avoid further changes, be patient.",
                        prevention: "Gradually acclimate plants to new conditions."
                    ),
                    PossibleCause(
                        id: "4b",
                        name: "Overwatering",
                        description: "Root damage from too much water",
                        symptoms: "Leaf drop with yellowing, soggy soil",
                        treatment: "Reduce watering, improve drainage, check for root rot.",
                        prevention: "Water only when needed, ensure proper drainage."
                    ),
                    PossibleCause(
                        id: "4c",
                        name: "Temperature Shock",
                        description: "Sudden temperature changes stress plant",
                        symptoms: "Leaf drop after exposure to cold or heat",
                        treatment: "Move to stable temperature location, maintain consistent conditions.",
                        prevention: "Avoid placing near heating/cooling vents or drafty areas."
                    )
                ]
            ),
            DiagnosticSymptom(
                id: "5",
                symptom: "slow growth",
                possibleCauses: [
                    PossibleCause(
                        id: "5a",
                        name: "Insufficient Light",
                        description: "Plant not getting enough light for photosynthesis",
                        symptoms: "Leggy growth, pale leaves, slow development",
                        treatment: "Move to brighter location or add grow lights.",
                        prevention: "Research plant's light requirements and place accordingly."
                    ),
                    PossibleCause(
                        id: "5b",
                        name: "Nutrient Deficiency",
                        description: "Plant lacks essential nutrients",
                        symptoms: "Slow growth, pale or small leaves, poor flowering",
                        treatment: "Begin regular fertilizing schedule with balanced fertilizer.",
                        prevention: "Fertilize regularly during growing season."
                    ),
                    PossibleCause(
                        id: "5c",
                        name: "Root Bound",
                        description: "Plant has outgrown its container",
                        symptoms: "Roots circling pot, water runs straight through, stunted growth",
                        treatment: "Repot into larger container with fresh soil.",
                        prevention: "Check root system annually and repot when necessary."
                    )
                ]
            ),
            DiagnosticSymptom(
                id: "6",
                symptom: "spots on leaves",
                possibleCauses: [
                    PossibleCause(
                        id: "6a",
                        name: "Fungal Disease",
                        description: "Fungal infection causing leaf spots",
                        symptoms: "Brown or black spots with yellow halos, spreading pattern",
                        treatment: "Remove affected leaves, improve air circulation, apply fungicide if severe.",
                        prevention: "Avoid overhead watering, ensure good air flow, don't overcrowd plants."
                    ),
                    PossibleCause(
                        id: "6b",
                        name: "Bacterial Infection",
                        description: "Bacterial disease affecting leaves",
                        symptoms: "Water-soaked spots, yellowing around spots, rapid spread",
                        treatment: "Remove affected parts, isolate plant, improve growing conditions.",
                        prevention: "Avoid getting water on leaves, maintain good hygiene."
                    ),
                    PossibleCause(
                        id: "6c",
                        name: "Pest Damage",
                        description: "Insects feeding on plant tissue",
                        symptoms: "Small holes or stippled appearance, visible insects",
                        treatment: "Identify pest and treat accordingly with appropriate insecticide or natural methods.",
                        prevention: "Regular inspection, quarantine new plants, maintain plant health."
                    )
                ]
            )
        ]
    }
    
    func searchSymptoms(_ query: String) -> [DiagnosticSymptom] {
        guard !query.isEmpty else { return [] }
        
        let lowercaseQuery = query.lowercased()
        return getAllSymptoms().filter { symptom in
            symptom.symptom.lowercased().contains(lowercaseQuery) ||
            symptom.possibleCauses.contains { cause in
                cause.name.lowercased().contains(lowercaseQuery) ||
                cause.description.lowercased().contains(lowercaseQuery) ||
                cause.symptoms.lowercased().contains(lowercaseQuery)
            }
        }
    }
    
    func getCommonSymptoms() -> [String] {
        return [
            "yellow leaves",
            "brown leaves",
            "wilting",
            "dropping leaves",
            "slow growth",
            "spots on leaves",
            "curling leaves",
            "pale leaves",
            "musty smell",
            "white powder on leaves"
        ]
    }
}


